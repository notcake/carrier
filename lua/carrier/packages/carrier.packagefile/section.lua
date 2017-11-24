local self = {}
PackageFile.Section = Class (self, ISerializable)

function self:ctor ()
	self.Verified = nil
end

-- Section
function self:GetName ()
	Error ("ISection:GetName : Not implemented.")
end

function self:IsVerified ()
	return self.Verified
end

function self:SetVerified (verified)
	self.Verified = verified
end
