local self = {}
PackageFile.DependenciesSection = Class (self, PackageFile.Section)

function PackageFile.DependenciesSection.Deserialize (streamReader)
	local section = PackageFile.DependenciesSection ()
	section:SetDataLength (streamReader:UInt32 ())
	
	section.DependencyCount = streamReader:UInt32 ()
	for i = 1, section.DependencyCount do
		section.DependencyNames    [#section.DependencyNames + 1] = streamReader:StringN8 ()
		section.DependencyVersions [#section.DependencyVersions + 1] = streamReader:StringN8 ()
	end
	
	return section
end

function self:ctor ()
	self:SetName ("dependencies")
	
	self.DependencyCount = 0
	self.DependencyNames    = {}
	self.DependencyVersions = {}
end

-- ISerializable
function self:Serialize (streamWriter)
	PackageFile.Section:GetMethodTable ().Serialize (self, streamWriter)
	streamWriter:UInt32 (self.DependencyCount)
	
	for i = 1, self.DependencyCount do
		streamWriter:StringN8 (self.DependencyNames    [i])
		streamWriter:StringN8 (self.DependencyVersions [i])
	end
end

-- Section
function self:Update ()
	local dataLength = 4
	
	for i = 1, self.DependencyCount do
		dataLength = dataLength + 1 + #self.DependencyNames [i] + 1 + #self.DependencyVersions [i]
	end
	
	self:SetDataLength (dataLength)
end

-- DependenciesSection
function self:AddDependency (name, version)
	self.DependencyNames    [#self.DependencyNames    + 1] = name;
	self.DependencyVersions [#self.DependencyVersions + 1] = version;
	self.DependencyCount = self.DependencyCount + 1
end

function self:GetDependency (i)
	return self.DependencyNames [i], self.DependencyVersions [i]
end

function self:GetDependencyCount ()
	return self.DependencyCount
end