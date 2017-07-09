local self = {}
GarrysMod.Window = Class (self, GarrysMod.View, IWindow)

local DragMode = Enum (
	{
		None   = 0,
		Move   = 1,
		Resize = 2
	}
)

local ResizeDirection = Enum (
	{
		None     =  0,
		Negative = -1,
		Positive =  1
	}
)

function self:ctor ()
	self.TitleBarHeight = 24
	
	self.DragMode   = DragMode.None
	
	-- Mouse position in parent coordinates at start of drag operation
	self.DragX      = nil
	self.DragY      = nil
	
	-- Saved bounds at start of drag operation
	self.DragLeft   = nil
	self.DragTop    = nil
	self.DragRight  = nil
	self.DragBottom = nil
	
	-- Resize directions
	self.ResizeHorizontal = ResizeDirection.None
	self.ResizeVertical   = ResizeDirection.None
end

-- IView
-- Content layout
function self:GetContentPosition ()
	return 4, self.TitleBarHeight
end

function self:GetContentSize ()
	local w, h = self:GetSize ()
	return w - 8, h - self.TitleBarHeight - 4
end

-- Internal
function self:OnMouseDown (buttons, x, y)
	if buttons == Core.MouseButtons.Left then
		local dragMode, resizeHorizontal, resizeVertical = self:HitTest (x, y)
		if dragMode ~= DragMode.None then
			-- Start resize or move
			self.DragMode = dragMode
			
			-- Save bounds
			self.DragLeft, self.DragTop = self:GetPosition ()
			local w, h = self:GetSize ()
			self.DragRight  = self.DragLeft + w
			self.DragBottom = self.DragTop  + h
			
			-- Save drag position in parent coordinates
			self.DragX = x + self.DragLeft
			self.DragY = y + self.DragTop
			
			self.ResizeHorizontal = resizeHorizontal
			self.ResizeVertical   = resizeVertical
			
			self:CaptureMouse ()
		end
	end
end

function self:OnMouseMove (buttons, x, y)
	if self.DragMode == DragMode.None then
		-- Update cursor
		local dragMode, resizeHorizontal, resizeVertical = self:HitTest (x, y)
		
		if dragMode == DragMode.Resize then
			if resizeHorizontal == ResizeDirection.None then
				self:SetCursor (Core.Cursor.SizeNorthSouth)
			elseif resizeVertical == ResizeDirection.None then
				self:SetCursor (Core.Cursor.SizeEastWest)
			elseif resizeHorizontal == resizeVertical then
				self:SetCursor (Core.Cursor.SizeNorthWestSouthEast)
			else
				self:SetCursor (Core.Cursor.SizeNorthEastSouthWest)
			end
		else
			self:SetCursor (Core.Cursor.Default)
		end
	else
		-- Convert to parent coordinates
		local dx, dy = self:GetPosition ()
		local x, y = x + dx, y + dy
		
		-- Clamp to parent bounds
		local parentWidth, parentHeight = self:GetParent ():GetSize ()
		local x = math.max (0, math.min (parentWidth  - 1, x))
		local y = math.max (0, math.min (parentHeight - 1, y))
		
		local dx = x - self.DragX
		local dy = y - self.DragY
		
		if self.DragMode == DragMode.Move then
			self:SetPosition (self.DragLeft + dx, self.DragTop + dy)
		elseif self.DragMode == DragMode.Resize then
			local x1, y1 = self.DragLeft,  self.DragTop
			local x2, y2 = self.DragRight, self.DragBottom
			
			if self.ResizeHorizontal == ResizeDirection.Negative then
				x1 = math.min (x1 + dx, x2 - self:GetPanel ():GetMinWidth ())
			elseif self.ResizeHorizontal == ResizeDirection.Positive then
				x2 = math.max (x2 + dx, x1 + self:GetPanel ():GetMinWidth ())
			end
			if self.ResizeVertical == ResizeDirection.Negative then
				y1 = math.min (y1 + dy, y2 - self:GetPanel ():GetMinHeight ())
			elseif self.ResizeVertical == ResizeDirection.Positive then
				y2 = math.max (y2 + dy, y1 + self:GetPanel ():GetMinHeight ())
			end
			
			self:SetRectangle (x1, y1, x2 - x1, y2 - y1)
		end
	end
end

function self:OnMouseUp (buttons, x, y)
	-- End resize or move
	if buttons == Core.MouseButtons.Left and
	   self.DragMode ~= DragMode.None then
		self.DragMode = DragMode.None
		self:ReleaseMouse ()
	end
end

-- IWindow
function self:GetTitle ()
	return self:GetPanel ():GetTitle ()
end

function self:SetTitle (title)
	self:GetPanel ():SetTitle (title)
end

-- View
function self:CreatePanel ()
	local panel = vgui.Create ("DFrame")
	panel:SetSizable (true)
	panel:SetDeleteOnClose (false)
	panel:MakePopup ()
	panel:SetKeyboardInputEnabled (false)
	panel:SetVisible (false)
	
	panel.Think = nil
	return panel
end

-- Window
-- Internal
function self:HitTest (x, y)
	local w, h = self:GetSize ()
	
	local resizeHorizontal
	local resizeVertical
	
	if     x < 4      then resizeHorizontal = ResizeDirection.Negative
	elseif x >= w - 4 then resizeHorizontal = ResizeDirection.Positive
	else                   resizeHorizontal = ResizeDirection.None
	end
	
	if     y < 4      then resizeVertical = ResizeDirection.Negative
	elseif y >= h - 4 then resizeVertical = ResizeDirection.Positive
	else                   resizeVertical = ResizeDirection.None
	end
	
	if resizeHorizontal ~= ResizeDirection.None or
	   resizeVertical   ~= ResizeDirection.None then
		return DragMode.Resize, resizeHorizontal, resizeVertical
	elseif y < self.TitleBarHeight then
		return DragMode.Move
	else
		return DragMode.None
	end
end
