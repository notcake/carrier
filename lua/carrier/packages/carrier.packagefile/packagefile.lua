local self = {}
PackageFile = Class (self, ISerializable)

function PackageFile.Deserialize (streamReader)
	local signature = streamReader:Bytes (8)
	if signature ~= "\xffPKG\r\n\x1a\n" then return nil end
	
	local formatVersion = streamReader:UInt32 ()
	if formatVersion == 1 then
		local name    = streamReader:StringN8 ()
		local version = streamReader:StringN8 ()
		local packageFile = PackageFile (name, version)
		packageFile.FileLength   = streamReader:UInt64 ()
		packageFile.SectionCount = streamReader:UInt32 ()
		
		for i = 1, packageFile.SectionCount do
			local name = streamReader:StringN8 ()
			local section = nil
			if name == "dependencies" then
				section = PackageFile.DependenciesSection.Deserialize (streamReader)
			elseif name == "code" then
				section = PackageFile.FileSystemSection.Deserialize (streamReader)
			else
				section = PackageFile.UnknownSection.Deserialize (streamReader, name)
			end
			packageFile.SectionsByName [name] = section
			packageFile.Sections [#packageFile.Sections + 1] = section
		end
		
		return packageFile
	else
		return nil
	end
end

function self:ctor (name, version)
	self.Signature = "\xffPKG\r\n\x1a\n"
	self.FormatVersion = 1
	self.Name = name
	self.Version = version
	self.FileLength = 0
	
	self.SectionCount = 0
	self.SectionsByName = {}
	self.Sections = {}
end

-- ISerializable
function self:Serialize (streamWriter)
	streamWriter:Bytes    (self.Signature)
	streamWriter:UInt32   (self.FormatVersion)
	streamWriter:StringN8 (self.Name)
	streamWriter:StringN8 (self.Version)
	streamWriter:UInt64   (self.FileLength)
	streamWriter:UInt32   (self.SectionCount)
	
	for section in self:GetSectionEnumerator () do
		section:Serialize (streamWriter)
	end
end

-- PackageFile
function self:AddSection (section)
	self:RemoveSection (section:GetName ())
	
	self.SectionsByName [section:GetName ()] = section
	self.Sections [#self.Sections + 1] = section
	
	self.SectionCount = self.SectionCount + 1
end

function self:GetSection (indexOrName)
	return self.SectionsByName [indexOrName] or self.Sections [indexOrName]
end

function self:GetSectionCount ()
	return self.SectionCount
end

function self:GetSectionEnumerator ()
	return ArrayEnumerator (self.Sections)
end

function self:RemoveSection (name)
	local section = self.SectionsByName [name]
	
	if not section then return end
	
	for i = 1, #self.Sections do
		if self.Sections [i] == section then
			table.remove (self.Sections, i)
			break
		end
	end
	
	self.SectionCount = self.SectionCount - 1
end

function self:Update ()
	self.FileLength = 8 + 4 + 1 + #self.Name + 1 + #self.Version + 8 + 4
	for section in self:GetSectionEnumerator () do
		section:Update ()
		self.FileLength = self.FileLength + 1 + #section:GetName () + 4 + section:GetDataLength ()
	end
end
