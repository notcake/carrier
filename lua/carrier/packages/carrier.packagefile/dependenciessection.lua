local self = {}
PackageFile.DependenciesSection = Class(self, PackageFile.Section)
PackageFile.DependenciesSection.Name = "dependencies"

function self:ctor()
	self.DependencyNames    = {}
	self.DependencyVersions = {}
end

-- ISerializable
function self:Serialize(streamWriter)
	streamWriter:UInt32(#self.DependencyNames)
	for i = 1, #self.DependencyNames do
		streamWriter:StringN8(self.DependencyNames   [i])
		streamWriter:StringN8(self.DependencyVersions[i])
	end
end

function self:Deserialize(streamReader)
	local dependencyCount = streamReader:UInt32()
	for i = 1, dependencyCount do
		local dependencyName    = streamReader:StringN8()
		local dependencyVersion = streamReader:StringN8()
		self:AddDependency(dependencyName, dependencyVersion)
	end
end

-- ISection
function self:GetName()
	return PackageFile.DependenciesSection.Name
end

-- DependenciesSection
function self:AddDependency(name, version)
	self.DependencyNames   [#self.DependencyNames    + 1] = name
	self.DependencyVersions[#self.DependencyVersions + 1] = version
end

function self:GetDependency(i)
	return self.DependencyNames[i], self.DependencyVersions[i]
end

function self:GetDependencyCount()
	return #self.DependencyNames
end
