local self = {}
GarrysMod.View = Class (self, IView)

function self:ctor ()
	self.Environment = nil
	self.Handle      = nil
	
	self.Parent      = nil
	self.Children    = nil
	
	self.X           = 0
	self.Y           = 0
	self.Width       = 128
	self.Height      = 128
	self.Visible     = true
	self.Cursor      = Glass.Cursor.Default
	
	self.RectangleAnimator = nil
	
	self.AnimationCount = 0
	self.Animations = nil
end

function self:dtor ()
	if self.Handle then
		self:DestroyHandle ()
	end
end

-- IView
-- Environment
function self:GetEnvironment ()
	return self.Environment
end

function self:CreateHandle ()
	if self.Handle then return self.Handle end
	
	-- Create own handle
	self.Environment = self:GetParent ():GetEnvironment ()
	self.Handle = self:CreateHandleInEnvironment (self.Environment, self:GetParent ())
	
	-- Create child handles recursively
	if self.Children then
		for i = 1, #self.Children do
			self.Children [i]:CreateHandle ()
		end
	end
end

function self:DestroyHandle ()
	if not self.Handle then return end
	
	-- Destroy child handles recursively
	if self.Children then
		for i = 1, #self.Children do
			self.Children [i]:DestroyHandle ()
		end
	end
	
	-- Destroy own handle
	self.Environment:DestroyHandle (self, self.Handle)
	self.Environment = nil
	self.Handle = nil
end

function self:GetHandle ()
	return self.Handle
end

function self:IsHandleCreated ()
	return self.Handle ~= nil
end

-- Hierarchy
function self:AddChild (view)
	-- Add to children
	self.Children = self.Children or {}
	self.Children [#self.Children + 1] = view
	
	-- Update parent
	view:SetParent (self)
end

function self:RemoveChild (view)
	-- Remove from children
	local childIndex = self:IndexOfChild (view)
	if not childIndex then return end
	
	table.remove (self.Children, childIndex)
	
	-- Update parent
	if view:GetParent () == self then
		view:SetParent (nil)
	end
end

function self:GetParent ()
	return self.Parent
end

function self:SetParent (view)
	if self.Parent == view then return end
	
	local previousParent = self.Parent
	local previousEnvironment = previousParent and previousParent:GetEnvironment ()
	self.Parent = view
	
	if previousParent then
		previousParent:RemoveChild (self)
	end
	
	if view then
		view:AddChild (self)
	end
	
	local environment = view and view:GetEnvironment ()
	
	if previousEnvironment == environment then
		-- Reparent within the same environment
		if self.Handle then
			self.Environment:SetParent (self, self.Handle, view:GetHandle ())
		end
	else
		-- Switch environments
		if previousEnvironment then
			self:DestroyHandle ()
		end
		if environment then
			self:CreateHandle ()
		end
	end
end

function self:BringChildToFront (view)
	local childIndex = self:IndexOfChild (view)
	if not childIndex then return end
	
	table.remove (self.Children, childIndex)
	self.Children [#self.Children + 1] = view
	
	if self.Handle then
		self.Environment:BringChildToFront (self, self.Handle, view:GetHandle ())
	end
end

function self:SendChildToBack (view)
	local childIndex = self:IndexOfChild (view)
	if not childIndex then return end
	
	table.remove (self.Children, childIndex)
	table.insert (self.Children, 1, view)
	
	if self.Handle then
		self.Environment:SendChildToBack (self, self.Handle, view:GetHandle ())
	end
end

-- Layout
local function AnimatedRectangleSetter1 (setter, name)
	local setterName = "Set" .. name
	return function (self, x, animator)
		if animator == true then animator = self:CreateDefaultAnimation () end
		
		if not animator then
			setter (self, x)
		else
			self:AddAnimation (self:CreateRectangleAnimator ())
		end
		
		if not self.RectangleAnimator then return end
		self.RectangleAnimator [setterName] (self.RectangleAnimator, Clock (), x, animator)
	end
end

local function AnimatedRectangleSetter2 (setter, name)
	local setterName = "Set" .. name
	return function (self, x1, x2, animator)
		if animator == true then animator = self:CreateDefaultAnimation () end
		
		if not animator then
			setter (self, x1, x2)
		else
			self:AddAnimation (self:CreateRectangleAnimator ())
		end
		
		if not self.RectangleAnimator then return end
		self.RectangleAnimator [setterName] (self.RectangleAnimator, Clock (), x1, x2, animator)
	end
end

function self:GetRectangle ()
	return self.X, self.Y, self.Width, self.Height
end

function self:SetRectangle (x, y, w, h, animator)
	if animator == true then animator = self:CreateDefaultAnimation () end
	
	self:SetPosition (x, y, animator)
	self:SetSize     (w, h, animator)
end

function self:GetPosition ()
	return self.X, self.Y
end

function self:GetX ()
	return self.X
end

function self:GetY ()
	return self.Y
end

function self:SetPosition (x, y)
	self.X, self.Y = x, y
	
	if self.Handle then
		self.Environment:SetPosition (self, self.Handle, x, y)
	end
end

function self:SetX (x)
	self.X = x
	
	if self.Handle then
		self.Environment:SetPosition (self, self.Handle, x, self.Y)
	end
end

function self:SetY (y)
	self.Y = y
	
	if self.Handle then
		self.Environment:SetPosition (self, self.Handle, self.X, y)
	end
end

self.SetPosition = AnimatedRectangleSetter2 (self.SetPosition, "Position")
self.SetX        = AnimatedRectangleSetter1 (self.SetX, "X")
self.SetY        = AnimatedRectangleSetter1 (self.SetY, "Y")

function self:GetSize ()
	return self.Width, self.Height
end

function self:GetWidth ()
	return self.Width
end

function self:GetHeight ()
	return self.Height
end

function self:SetSize (w, h)
	self.Width, self.Height = w, h
	
	if self.Handle then
		self.Environment:SetSize (self, self.Handle, w, h)
	end
end

function self:SetWide (w)
	self.Width = w
	
	if self.Handle then
		self.Environment:SetSize (self, self.Handle, w, self.Height)
	end
end

function self:SetHeight (h)
	self.Height = h
	
	if self.Handle then
		self.Environment:SetSize (self, self.Handle, self.Width, h)
	end
end

self.SetSize   = AnimatedRectangleSetter2 (self.SetSize,   "Size")
self.SetWidth  = AnimatedRectangleSetter1 (self.SetWidth,  "Width")
self.SetHeight = AnimatedRectangleSetter1 (self.SetHeight, "Height")

-- Content layout
function self:InvalidateLayout ()
	if not self.Handle then return end
	self.Environment:InvalidateLayout (self, self.Handle)
end

-- Appearance
function self:IsVisible ()
	return self.Visible
end

function self:SetVisible (visible)
	if self.Visible == visible then return end
	
	self.Visible = visible
	
	if self.Handle then
		self.Environment:SetVisible (self, self.Handle, visible)
	end
	
	self:OnVisibleChanged (visible)
	self.VisibleChanged:Dispatch (visible)
end

-- Mouse
function self:GetCursor ()
	return self.Cursor
end

function self:SetCursor (cursor)
	if self.Cursor == cursor then return end
	
	self.Cursor = cursor
	
	if self.Handle then
		self.Environment:SetCursor (self, self.Handle, cursor)
	end
end

function self:GetMousePosition ()
	if not self.Handle then return nil, nil end
	return self.Environment:GetMousePosition (self, self:GetHandle ())
end

function self:CaptureMouse ()
	if not self.Handle then return end
	self.Environment:CaptureMouse (self, self.Handle)
end

function self:ReleaseMouse ()
	if not self.Handle then return end
	self.Environment:ReleaseMouse (self, self.Handle)
end

function self:IsMouseEventConsumer ()
	return self.ConsumesMouseEvents
end

function self:SetConsumesMouseEvents (consumesMouseEvents)
	self.ConsumesMouseEvents = consumesMouseEvents
end

-- Animations
function self:AddAnimation (animation)
	self.Animations = self.Animations or {}
	if self.Animations [animation] then return end
	self.Animations [animation] = true
	self.AnimationCount = self.AnimationCount + 1
	
	if self.Handle then
		self.Environment:AddAnimation (self, self.Handle, animation)
	end
end

function self:CreateAnimation (updater)
	local animation = Glass.Animation (Clock (), updater)
	
	self:AddAnimation (animation)
	return animation
end

function self:CreateAnimator (interpolator, duration, updater)
	local animator = Glass.Animator (Clock (), interpolator, duration)
	if updater then
		animator.Updated:AddListener (updater)
	end
	
	self:AddAnimation (animator)
	return animator
end

function self:GetAnimationCount ()
	return self.AnimationCount
end

function self:GetAnimationEnumerator ()
	if not self.Animations then return NullEnumerator () end
	return KeyEnumerator (self.Animations)
end

function self:RemoveAnimation (animation)
	if not self.Animations then return end
	if not self.Animations [animation] then return end
	
	self.Animations [animation] = nil
	self.AnimationCount = self.AnimationCount - 1
	
	if self.Handle then
		self.Environment:RemoveAnimation (self, self.Handle, animation)
	end
end

function self:UpdateAnimations (t)
	for animation in self:GetAnimationEnumerator () do
		local uncompleted = animation:Update (t)
		if not uncompleted then
			self:RemoveAnimation (animation)
		end
	end
end

-- Internal
function self:OnMouseDown (mouseButtons, x, y) end
function self:OnMouseMove (mouseButtons, x, y) end
function self:OnMouseUp   (mouseButtons, x, y) end

function self:OnMouseWheel (delta) end

function self:OnMouseEnter () end
function self:OnMouseLeave () end

function self:Render (w, h, render2d) end

-- View
-- Internal
function self:CreateHandleInEnvironment (environment, parent)
	return environment:CreateHandle (self, parent:GetHandle ())
end

function self:InjectHandle (environment, handle)
	self:DestroyHandle ()
	
	self.Environment = environment
	self.Handle      = handle
end

function self:IndexOfChild (view)
	if not self.Children then return nil end
	
	for i = 1, #self.Children do
		if self.Children [i] == view then
			return i
		end
	end
	
	return nil
end

function self:CreateRectangleAnimator ()
	if self.RectangleAnimator then return self.RectangleAnimator end
	
	local x, y, w, h = self:GetRectangle ()
	self.RectangleAnimator = Glass.RectangleAnimator (x, y, w, h)
	self.RectangleAnimator.Updated:AddListener (
		function (x, y, w, h)
			self.X, self.Y, self.Width, self.Height = x, y, w, h
			self.Environment:SetRectangle (self, self:GetHandle (), x, y, w, h)
		end
	)
	
	return self.RectangleAnimator
end

function self:CreateDefaultAnimator ()
	return self:CreateAnimator (Glass.Interpolators.Linear (), 0.25)
end
