local self = {}
Glass.AnimatorHost = Class (self, Glass.IAnimatorHost)

function self:ctor ()
	self.Animators = nil
end

-- IAnimatorHost
function self:AttachAnimator (name, animator)
	local animator = animator or name
	
	self.Animators = self.Animators or {}
	self.Animators [name] = animator
end

function self:DetachAnimator (name)
	if not self.Animators then return end
	
	self.Animators [name] = nil
end

function self:GetAnimatorEnumerator ()
	if not self.Animators then return NullEnumerator () end
	
	return ValueEnumerator (self.Animators)
end

-- AnimatorHost
function self:UpdateAnimators (...)
	if not self.Animators then return end
	
	for _, animator in pairs (self.Animators) do
		animator (...)
	end
end
