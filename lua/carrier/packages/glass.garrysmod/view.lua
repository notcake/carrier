local self = {}
GarrysMod.View = Class (self, IView)

function self:ctor ()
	self.Environment = GarrysMod.Environment
	
	self.Handle = nil
	
	self.RectangleAnimator = nil
	
	self.Cursor = Glass.Cursor.Default
	
	self.AnimationCount = 0
	self.Animations = nil
end

function self:dtor ()
	if self:IsHandleCreated () then
		self.Environment:DestroyHandle (self, self:GetHandle ())
	end
end

-- IView
-- Environment
function self:GetEnvironment ()
	return self.Environment
end
local DummyPanel = {}
function DummyPanel:IsValid ()
	Error ("Cannot use View:GetHandle () within View:CreatePanel ()!")
end
function DummyPanel:Remove () end

function self:GetHandle ()
	if not self.Handle or
	   not self.Handle:IsValid () then
		self.Handle = DummyPanel
		self.Handle = self:CreatePanel ()
	end
	
	return self.Handle
end

function self:IsHandleCreated ()
	return self.Handle and self.Handle:IsValid () or false
end

-- Hierarchy
function self:AddChild (view)
	self.Environment:AddChild (self, self:GetHandle (), view)
end

function self:RemoveChild (view)
	self.Environment:RemoveChild (self, self:GetHandle (), view)
end

function self:GetParent ()
	return self.Environment:GetParent (self, self:GetHandle ())
end

function self:SetParent (view)
	if view then
		view:AddChild (self)
	else
		self.Environment:SetParent (self, self:GetHandle (), nil)
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
	return self.Environment:GetRectangle (self, self:GetHandle ())
end

function self:SetRectangle (x, y, w, h, animator)
	if animator == true then animator = self:CreateDefaultAnimation () end
	
	self:SetPosition (x, y, animator)
	self:SetSize     (w, h, animator)
end

function self:GetPosition ()
	return self.Environment:GetPosition (self, self:GetHandle ())
end

function self:SetPosition (x, y)
	self.Environment:SetPosition (self, self:GetHandle (), x, y)
end

function self:SetX (x)
	self.Environment:SetPosition (self, self:GetHandle (), x, self:GetY ())
end

function self:SetY (y)
	self.Environment:SetPosition (self, self:GetHandle (), self:GetX (), y)
end

self.SetPosition = AnimatedRectangleSetter2 (self.SetPosition, "Position")
self.SetX        = AnimatedRectangleSetter1 (self.SetX, "X")
self.SetY        = AnimatedRectangleSetter1 (self.SetY, "Y")

function self:GetSize ()
	return self.Environment:GetSize (self, self:GetHandle ())
end

function self:GetWidth ()
	local w, _ = self.Environment:GetSize (self, self:GetHandle ())
	return w
end

function self:GetHeight ()
	local _, h = self.Environment:GetSize (self, self:GetHandle ())
	return h
end

function self:SetSize (w, h)
	self.Environment:SetSize (self, self:GetHandle (), w, h)
end

function self:SetWide (w)
	self.Environment:SetSize (self, self:GetHandle (), w, self:GetHeight ())
end

function self:SetHeight (h)
	self.Environment:SetSize (self, self:GetHandle (), self:GetWidth (), h)
end

self.SetSize   = AnimatedRectangleSetter2 (self.SetSize,   "Size")
self.SetWidth  = AnimatedRectangleSetter1 (self.SetWidth,  "Width")
self.SetHeight = AnimatedRectangleSetter1 (self.SetHeight, "Height")

function self:BringToFront ()
	self.Environment:BringToFront (self, self:GetHandle ())
end

function self:SendToBack ()
	self.Environment:SendToBack (self, self:GetHandle ())
end

-- Content layout
function self:InvalidateLayout ()
	self.Environment:InvalidateLayout (self, self:GetHandle ())
end

-- Appearance
function self:IsVisible ()
	return self.Environment:IsVisible (self, self:GetHandle ())
end

function self:SetVisible (visible)
	self.Environment:SetVisible (self, self:GetHandle (), visible)
end

-- Mouse
function self:GetCursor ()
	return self.Cursor
end

function self:SetCursor (cursor)
	self.Cursor = cursor
	self.Environment:SetCursor (self, self:GetHandle (), cursor)
end

function self:GetMousePosition ()
	return self.Environment:GetMousePosition (self, self:GetHandle ())
end

function self:CaptureMouse ()
	self.Environment:CaptureMouse (self, self:GetHandle ())
end

function self:ReleaseMouse ()
	self.Environment:ReleaseMouse (self, self:GetHandle ())
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
	
	self.Environment:AddAnimation (self, self:GetHandle (), animation)
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
	
	self.Environment:RemoveAnimation (self, self:GetHandle (), animation)
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
function self:CreatePanel ()
	return self:GetEnvironment ():CreateHandle (self)
end

function self:InjectPanel (panel)
	if self.Handle and self.Handle:IsValid () then
		self.Handle:Remove ()
	end
	
	self.Handle = panel
end

function self:CreateRectangleAnimator ()
	if self.RectangleAnimator then return self.RectangleAnimator end
	
	local x, y, w, h = self:GetRectangle ()
	self.RectangleAnimator = Glass.RectangleAnimator (x, y, w, h)
	self.RectangleAnimator.Updated:AddListener (
		function (x, y, w, h)
			self.Environment:SetRectangle (self, self:GetHandle (), x, y, w, h)
		end
	)
	
	return self.RectangleAnimator
end

function self:CreateDefaultAnimator ()
	return self:CreateAnimator (Glass.Interpolators.Linear (), 0.25)
end
