local self = {}
PackageFile.ISection = Class (self, ISerializable)

function self:ctor ()
end

-- ISection
function self:GetName ()
	Error ("ISection:GetName : Not implemented.")
end
