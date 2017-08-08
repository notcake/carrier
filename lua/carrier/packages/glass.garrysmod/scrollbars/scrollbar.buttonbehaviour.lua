local self = {}
Scrollbar.ButtonBehaviour = Class (self)

function self:ctor (scrollbar, button, smallIncrementMultiplier)
	self.Scrollbar = scrollbar
	self.Button    = button
	
	self.SmallIncrementMultiplier = smallIncrementMultiplier
	
	self.HoldAnimation = nil
	
	self.Button.MouseDown:AddListener ("Glass.GarrysMod.Scrollbar.ButtonBehaviour." .. self:GetHashCode (),
		function (mouseButtons, x, y)
			if mouseButtons == Glass.MouseButtons.Left then
				self.HoldAnimation = self.Scrollbar:CreateAnimation (
					function (t0, t)
						if not self.Button:IsPressed () then return end
						self.Scrollbar:ScrollSmallIncrement (self.SmallIncrementMultiplier)
					end
				)
			end
		end
	)
	self.Button.MouseUp:AddListener ("Glass.GarrysMod.Scrollbar.ButtonBehaviour." .. self:GetHashCode (),
		function (mouseButtons, x, y)
			if mouseButtons == Glass.MouseButtons.Left then
				self.Scrollbar:RemoveAnimation (self.HoldAnimation)
				self.Scrollbar:ScrollSmallIncrement (self.SmallIncrementMultiplier)
			end
		end
	)
end

function self:dtor ()
	self.Button.MouseDown:RemoveListener ("Glass.GarrysMod.Scrollbar.ButtonBehaviour." .. self:GetHashCode ())
	self.Button.MouseUp  :RemoveListener ("Glass.GarrysMod.Scrollbar.ButtonBehaviour." .. self:GetHashCode ())
end
