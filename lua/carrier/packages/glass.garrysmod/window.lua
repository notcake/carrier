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
	
	self.Maximizable = true
	self.Maximized   = false
	
	self.RestoredX      = nil
	self.RestoredY      = nil
	self.RestoredWidth  = nil
	self.RestoredHeight = nil
	
	self.Resizable = true
	
	self.DragMode = DragMode.None
	
	-- Dragging only starts when the mouse has moved enough
	-- or the mouse is pressed for long enough
	self.DragConfirmed = false
	self.DragStartTime = nil
	
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
	
	-- Restore button
	self.RestoreButton = GarrysMod.Window.RestoreButton ()
	self.RestoreButton:SetParent (self)
	self.RestoreButton.Click:AddListener (
		function ()
			self:Restore ()
		end
	)
	self.RestoreButton:SetVisible (false)
	
	self.Layout:AddListener (
		function (w, h)
			self.RestoreButton:GetPanel ():SetPos  (self:GetPanel ().btnMaxim:GetPos  ())
			self.RestoreButton:GetPanel ():SetSize (self:GetPanel ().btnMaxim:GetSize ())
		end
	)
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
	if buttons == Glass.MouseButtons.Left then
		local dragMode, resizeHorizontal, resizeVertical = self:HitTest (x, y)
		if dragMode ~= DragMode.None then
			-- Start resize or move
			self.DragMode = dragMode
			self.DragConfirmed = false
			self.DragStartTime = Clock ()
			
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
				self:SetCursor (Glass.Cursor.SizeNorthSouth)
			elseif resizeVertical == ResizeDirection.None then
				self:SetCursor (Glass.Cursor.SizeEastWest)
			elseif resizeHorizontal == resizeVertical then
				self:SetCursor (Glass.Cursor.SizeNorthWestSouthEast)
			else
				self:SetCursor (Glass.Cursor.SizeNorthEastSouthWest)
			end
		else
			self:SetCursor (Glass.Cursor.Default)
		end
	else
		-- Convert (x, y) to parent coordinates
		local dx, dy = self:GetPosition ()
		local x, y = x + dx, y + dy
		
		-- Clamp (x, y) to parent bounds
		local parentWidth, parentHeight = self:GetParent ():GetSize ()
		local x = math.max (0, math.min (parentWidth  - 1, x))
		local y = math.max (0, math.min (parentHeight - 1, y))
		
		local dx = x - self.DragX
		local dy = y - self.DragY
		
		self.DragConfirmed = self.DragConfirmed or (Clock () - self.DragStartTime > 0.5)
		self.DragConfirmed = self.DragConfirmed or (dx * dx + dy * dy >= 64)
		
		if not self.DragConfirmed then return end
		
		if self.DragMode == DragMode.Move then
			if self:IsMaximized () then
				local newLocalX = (x - self:GetX ()) / self:GetWidth () * self.RestoredWidth
				self.DragLeft   = x - newLocalX
				self.DragRight  = self.DragLeft + self.RestoredWidth
				self.DragBottom = self.DragTop + self.RestoredHeight
				self:Restore ()
			end
			
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
	if buttons == Glass.MouseButtons.Left and
	   self.DragMode ~= DragMode.None then
		self.DragMode = DragMode.None
		self:ReleaseMouse ()
	end
end

function self:OnDoubleClick ()
	local x, y = self:GetMousePosition ()
	if y < self.TitleBarHeight then
		if not self:CanMaximize () then return end
		
		if self:IsMaximized () then
			self:Restore ()
		else
			self:Maximize ()
		end
	end
end

local blurX = Material ("pp/blurx")
local blurY = Material ("pp/blury")
function self:Render (w, h, render2d)
	render.SetStencilEnable (true)
	render.SetStencilTestMask (0xFF)
	render.SetStencilWriteMask (0xFF)
	render.ClearStencil ()
	render.SetStencilReferenceValue (0x80)
	render.SetStencilCompareFunction (STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilFailOperation (STENCILOPERATION_REPLACE)
	surface.SetDrawColor (Color.ToRGBA8888 (Color.White))
	surface.DrawRect (0, 0, w, h)
	
	render.SetStencilCompareFunction (STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilFailOperation (STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation (STENCILOPERATION_KEEP)
	
	for i = 1, 6 do
		render.UpdateScreenEffectTexture ()
		blurX:SetTexture ("$basetexture", render.GetScreenEffectTexture ())
		blurX:SetFloat ("$size", 1)
		render.SetMaterial (blurX)
		render.DrawScreenQuad ()
		
		render.UpdateScreenEffectTexture ()
		blurY:SetTexture ("$basetexture", render.GetScreenEffectTexture ())
		blurY:SetFloat ("$size", 1)
		render.SetMaterial (blurY)
		render.DrawScreenQuad ()
	end
	
	render.SetStencilEnable (false)
	
	render2d:FillRectangle (Color.WithAlpha (GarrysMod.Skin.Default.Colors.Background, 0x80), 0, 0, w, h)
	-- render2d:FillRectangle (GarrysMod.Skin.Default.Colors.Background, 0, 0, w, h)
	
	if self:GetPanel ():HasHierarchicalFocus () then
		render2d:DrawRectangle (Color.CornflowerBlue, 0, 0, w, h)
	else
		render2d:DrawRectangle (Color.Gray, 0, 0, w, h)
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
	panel:SetSizable (self:IsResizable ())
	panel:SetDeleteOnClose (false)
	panel:MakePopup ()
	panel:SetKeyboardInputEnabled (false)
	panel:SetVisible (false)
	
	-- Disable default resizing and moving behaviour
	panel.Think = nil
	
	-- Fix maximize button
	panel.btnMaxim:SetDisabled (not self:CanMaximize ())
	panel.btnMaxim.DoClick = function (_)
		self:Maximize ()
	end
	
	panel:SetMinWidth (8 + 24 + 4 + 31 + 31 + 31 + 4)
	
	self.TitleLabel = GarrysMod.Label ()
	self.TitleLabel:InjectPanel (panel.lblTitle)
	self.TitleLabel:SetFont (GarrysMod.Skin.Default.Fonts.Default)
	self.TitleLabel:SetTextColor (GarrysMod.Skin.Default.Colors.Text)
	
	return panel
end

-- Window
function self:CanMaximize ()
	return self.Maximizable
end

function self:IsMaximized ()
	return self.Maximized
end

function self:IsResizable ()
	return self.Resizable
end

function self:Maximize ()
	if self:IsMaximized () then return end
	
	self.RestoreButton:SetVisible (true)
	self:GetPanel ().btnMaxim:SetVisible (false)
	
	self.Maximized = true
	self.RestoredX,     self.RestoredY      = self:GetPosition ()
	self.RestoredWidth, self.RestoredHeight = self:GetSize ()
	
	self:SetPosition (0, 0)
	self:SetSize (self:GetParent ():GetSize ())
end

function self:Restore ()
	if not self:IsMaximized () then return end
	
	self.RestoreButton:SetVisible (false)
	self:GetPanel ().btnMaxim:SetVisible (true)
	
	self.Maximized = false
	self:SetPosition (self.RestoredX, self.RestoredY)
	self:SetSize (self.RestoredWidth, self.RestoredHeight)
end

function self:SetMaximizable (maximizable)
	self.Maximizable = maximizable
	self.btnMaxim:SetDisabled (not self.Maximizable)
end

function self:SetResizable (resizable)
	self.Resizable = resizable
	self:GetPanel ():SetSizable (self.Resizable)
end

-- Internal
function self:HitTest (x, y)
	local w, h = self:GetSize ()
	
	local resizeHorizontal = ResizeDirection.None
	local resizeVertical   = ResizeDirection.None
	
	if not self:IsMaximized () then
		if     x < 6      then resizeHorizontal = ResizeDirection.Negative
		elseif x >= w - 6 then resizeHorizontal = ResizeDirection.Positive
		end
		
		if     y < 6      then resizeVertical = ResizeDirection.Negative
		elseif y >= h - 6 then resizeVertical = ResizeDirection.Positive
		end
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
