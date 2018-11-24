local self = {}
GarrysMod.Window = Class(self, Glass.View, Glass.IWindow)

local DragMode = Enum(
	{
		None   = 0,
		Move   = 1,
		Resize = 2
	}
)

local ResizeDirection = Enum(
	{
		None     =  0,
		Negative = -1,
		Positive =  1
	}
)

function self:ctor()
	self.Title = ""
	
	self.TitleBarHeight = 24
	
	self.Maximizable = true
	self.Maximized   = false
	
	self.RestoredX      = nil
	self.RestoredY      = nil
	self.RestoredWidth  = nil
	self.RestoredHeight = nil
	
	self.Resizable = true
	
	self.DragMode = DragMode.None
	
	-- Saved bounds at start of drag operation
	self.DragLeft   = nil
	self.DragTop    = nil
	self.DragRight  = nil
	self.DragBottom = nil
	
	self:SetConsumesMouseEvents(true)
	
	self.DragBehaviour = Glass.DragBehaviour(self, false)
	self.DragBehaviour.Started:AddListener(
		function()
			-- Save bounds
			self.DragLeft, self.DragTop = self:GetPosition()
			local w, h = self:GetSize()
			self.DragRight  = self.DragLeft + w
			self.DragBottom = self.DragTop  + h
		end
	)
	self.DragBehaviour.Updated:AddListener(
		function(dx, dy)
			-- Clamp(dx, dy) to parent bounds
			local x0, y0 = self.DragBehaviour:GetStartPosition()
			local parentWidth, parentHeight = self:GetParent():GetSize()
			local dx = math.max(-x0, math.min(parentWidth  - 1 - x0, dx))
			local dy = math.max(-y0, math.min(parentHeight - 1 - y0, dy))
			
			if self.DragMode == DragMode.Move then
				if self:IsMaximized() then
					local newLocalX = (x0 + dx - self:GetX()) / self:GetWidth() * self.RestoredWidth
					self.DragLeft   = x0 + dx - newLocalX
					self.DragRight  = self.DragLeft + self.RestoredWidth
					self.DragBottom = self.DragTop + self.RestoredHeight
					self:Restore(false)
				end
				
				self:SetPosition(self.DragLeft + dx, self.DragTop + dy)
			elseif self.DragMode == DragMode.Resize then
				local x1, y1 = self.DragLeft,  self.DragTop
				local x2, y2 = self.DragRight, self.DragBottom
				
				if self.ResizeHorizontal == ResizeDirection.Negative then
					x1 = math.min(x1 + dx, x2 - self:GetHandle():GetMinWidth())
				elseif self.ResizeHorizontal == ResizeDirection.Positive then
					x2 = math.max(x2 + dx, x1 + self:GetHandle():GetMinWidth())
				end
				if self.ResizeVertical == ResizeDirection.Negative then
					y1 = math.min(y1 + dy, y2 - self:GetHandle():GetMinHeight())
				elseif self.ResizeVertical == ResizeDirection.Positive then
					y2 = math.max(y2 + dy, y1 + self:GetHandle():GetMinHeight())
				end
				
				self:SetRectangle(x1, y1, x2 - x1, y2 - y1)
			end
		end
	)
	
	-- Resize directions
	self.ResizeHorizontal = ResizeDirection.None
	self.ResizeVertical   = ResizeDirection.None
	
	-- Restore button
	self.RestoreButton = GarrysMod.Window.RestoreButton()
	self.RestoreButton:SetParent(self)
	self.RestoreButton.Click:AddListener(
		function()
			self:Restore()
		end
	)
	self.RestoreButton:SetVisible(false)
	
	self.Layout:AddListener(
		function(w, h)
			self.RestoreButton:GetHandle():SetPos (self:GetHandle().btnMaxim:GetPos ())
			self.RestoreButton:GetHandle():SetSize(self:GetHandle().btnMaxim:GetSize())
		end
	)
	
	self:SetVisible(false)
end

-- IView
-- Children layout
function self:GetContainerPosition()
	return 4, self.TitleBarHeight
end

function self:GetContainerSize()
	local w, h = self:GetSize()
	return w - 8, h - self.TitleBarHeight - 4
end

-- Internal
function self:OnMouseDown(mouseButtons, x, y)
	if mouseButtons == Glass.MouseButtons.Left then
		local dragMode, resizeHorizontal, resizeVertical = self:HitTest(x, y)
		if dragMode ~= DragMode.None then
			self.DragMode = dragMode
			
			self.ResizeHorizontal = resizeHorizontal
			self.ResizeVertical   = resizeVertical
			
			self.DragBehaviour:OnMouseDown(mouseButtons, x, y)
		end
	end
end

function self:OnMouseMove(mouseButtons, x, y)
	if self.DragMode == DragMode.None then
		-- Update cursor
		local dragMode, resizeHorizontal, resizeVertical = self:HitTest(x, y)
		
		if dragMode == DragMode.Resize then
			if resizeHorizontal == ResizeDirection.None then
				self:SetCursor(Glass.Cursor.SizeNorthSouth)
			elseif resizeVertical == ResizeDirection.None then
				self:SetCursor(Glass.Cursor.SizeEastWest)
			elseif resizeHorizontal == resizeVertical then
				self:SetCursor(Glass.Cursor.SizeNorthWestSouthEast)
			else
				self:SetCursor(Glass.Cursor.SizeNorthEastSouthWest)
			end
		else
			self:SetCursor(Glass.Cursor.Default)
		end
	else
		self.DragBehaviour:OnMouseMove(mouseButtons, x, y)
	end
end

function self:OnMouseUp(mouseButtons, x, y)
	-- End resize or move
	if mouseButtons == Glass.MouseButtons.Left and
	   self.DragMode ~= DragMode.None then
		self.DragMode = DragMode.None
		self.DragBehaviour:OnMouseUp(mouseButtons, x, y)
	end
end

function self:OnDoubleClick()
	local x, y = self:GetMousePosition()
	if y < self.TitleBarHeight then
		if not self:CanMaximize() then return end
		
		if self:IsMaximized() then
			self:Restore()
		else
			self:Maximize()
		end
	end
end

local blurX = Material("pp/blurx")
local blurY = Material("pp/blury")
function self:Render(w, h, render2d)
	render.SetStencilEnable(true)
	render.SetStencilTestMask(0xFF)
	render.SetStencilWriteMask(0xFF)
	render.ClearStencil()
	render.SetStencilReferenceValue(0x80)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	surface.SetDrawColor(Color.ToRGBA8888(Color.White))
	surface.DrawRect(0, 0, w, h)
	
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	
	for i = 1, 6 do
		render.UpdateScreenEffectTexture()
		blurX:SetTexture("$basetexture", render.GetScreenEffectTexture())
		blurX:SetFloat("$size", 1)
		render.SetMaterial(blurX)
		render.DrawScreenQuad()
		
		render.UpdateScreenEffectTexture()
		blurY:SetTexture("$basetexture", render.GetScreenEffectTexture())
		blurY:SetFloat("$size", 1)
		render.SetMaterial(blurY)
		render.DrawScreenQuad()
	end
	
	render.SetStencilEnable(false)
	
	render2d:FillRectangle(Color.WithAlpha(self:GetEnvironment():GetSkin():GetBackgroundColor(), 0xE0), 0, 0, w, h)
	-- render2d:FillRectangle(self:GetEnvironment():GetSkin():GetBackgroundColor(), 0, 0, w, h)
	
	if self:GetHandle():HasHierarchicalFocus() then
		render2d:DrawRectangle(Color.CornflowerBlue, 0, 0, w, h)
	else
		render2d:DrawRectangle(Color.Gray, 0, 0, w, h)
	end
end

-- IWindow
function self:GetTitle()
	return self.Title
end

function self:SetTitle(title)
	if self.Title == title then return end
	
	self.Title = title
	
	if self:IsHandleCreated() then
		self:GetEnvironment():SetWindowTitle(self, self:GetHandle(), title)
	end
end

-- View
function self:CreateHandleInEnvironment(environment, parent)
	local panel = environment:CreateWindowHandle(self, parent:GetHandle())
	panel:SetSizable(self:IsResizable())
	panel:SetDeleteOnClose(false)
	panel:MakePopup()
	panel:SetKeyboardInputEnabled(false)
	
	-- Disable default resizing and moving behaviour
	panel.Think = nil
	
	-- Fix maximize button
	panel.btnMaxim:SetDisabled(not self:CanMaximize())
	panel.btnMaxim.DoClick = function(_)
		self:Maximize()
	end
	
	panel:SetMinWidth(8 + 24 + 4 + 31 + 31 + 31 + 4)
	
	panel.lblTitle:SetFont(FontCache:GetFontId(environment:GetSkin():GetDefaultFont()))
	panel.lblTitle:SetTextColor(_G.Color(Color.ToRGBA8888(environment:GetSkin():GetTextColor())))
	
	return panel
end

-- Window
function self:Show()
	self:SetVisible(true)
end

function self:Hide()
	self:SetVisible(false)
end

function self:CanMaximize()
	return self.Maximizable
end

function self:IsMaximized()
	return self.Maximized
end

function self:IsResizable()
	return self.Resizable
end

function self:Maximize(animated)
	local animated = animated == nil and true or animated
	
	if self:IsMaximized() then return end
	
	self.RestoreButton:SetVisible(true)
	self:GetHandle().btnMaxim:SetVisible(false)
	
	self.Maximized = true
	self.RestoredX,     self.RestoredY      = self:GetPosition()
	self.RestoredWidth, self.RestoredHeight = self:GetSize()
	
	local x, y, w, h = 0, 0, self:GetParent():GetSize()
	local animator = animated and self:CreateAnimator(Glass.Interpolators.ExponentialDecay(0.001), 0.25) or nil
	self:SetRectangle(x, y, w, h, animator)
end

function self:Restore(animated)
	local animated = animated == nil and true or animated
	
	if not self:IsMaximized() then return end
	
	self.RestoreButton:SetVisible(false)
	self:GetHandle().btnMaxim:SetVisible(true)
	
	self.Maximized = false
		
	local x, y, w, h = self.RestoredX, self.RestoredY, self.RestoredWidth, self.RestoredHeight
	local animator = animated and self:CreateAnimator(Glass.Interpolators.ExponentialDecay(0.001), 0.25) or nil
	self:SetRectangle(x, y, w, h, animator)
end


function self:SetMaximizable(maximizable)
	self.Maximizable = maximizable
	self.btnMaxim:SetDisabled(not self.Maximizable)
end

function self:SetResizable(resizable)
	self.Resizable = resizable
	self:GetHandle():SetSizable(self.Resizable)
end

-- Internal
function self:HitTest(x, y)
	local w, h = self:GetSize()
	
	local resizeHorizontal = ResizeDirection.None
	local resizeVertical   = ResizeDirection.None
	
	if not self:IsMaximized() then
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
