local self = {}
Carrier.RemoteDeveloperPackageRelease = Class (self, Carrier.IPackageRelease)

function self:ctor (name, timestamp)
	self.Version   = "dev-remote-" .. string.format ("%08x", timestamp)
	self.Timestamp = timestamp
	
	self.Size      = nil
	self.FileName  = "dev-remote-" .. Carrier.ToFileName (self.Name) .. "-" .. string.format ("%08x", self.Timestamp) .. ".dat"
end

-- IPackageRelease
function self:GetVersion ()
	return self.Version
end

function self:GetTimestamp ()
	return self.Timestamp
end

function self:IsDeprecated ()
	return false
end

function self:IsDeveloper ()
	return true
end

-- RemoteDeveloperPackageRelease
function self:IsLocal ()
	return false
end

function self:IsRemote ()
	return true
end

function self:GetSize ()
	return self
end
