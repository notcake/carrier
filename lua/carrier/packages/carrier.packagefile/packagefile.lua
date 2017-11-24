local self = {}
PackageFile = Class (self, ISerializable)
PackageFile.Signature     = "\xffPKG\r\n\x1a\n"
PackageFile.FormatVersion = 1

function PackageFile.Deserialize (streamReader)
	local signature = streamReader:Bytes (#PackageFile.Signature)
	if signature ~= PackageFile.Signature then return nil end
	
	local formatVersion = streamReader:UInt32 ()
	if formatVersion == PackageFile.FormatVersion then
		local name    = streamReader:StringN8 ()
		local version = streamReader:StringN8 ()
		local packageFile = PackageFile (name, version)
		streamReader:UInt64 ()
		
		local sectionCount = streamReader:UInt32 ()
		for i = 1, sectionCount do
			local name   = streamReader:StringN8 ()
			local length = streamReader:UInt32 ()
			local section = nil
			if name == PackageFile.DependenciesSection.Name then
				section = PackageFile.DependenciesSection ()
			elseif name == PackageFile.FileSystemSection.Name then
				section = PackageFile.FileSystemSection ()
			elseif name == PackageFile.LuaHashesSection.Name then
				section = PackageFile.LuaHashesSection ()
			elseif name == PackageFile.SignatureSection.Name then
				section = PackageFile.SignatureSection ()
			else
				section = PackageFile.UnknownSection (name, streamReader:Bytes (length))
			end
			
			section:Deserialize (streamReader)
			packageFile.SectionsByName [name] = section
			packageFile.Sections [#packageFile.Sections + 1] = section
		end
		
		return packageFile
	else
		return nil
	end
end

function self:ctor (name, version)
	self.Name           = name
	self.Version        = version
	
	self.Sections       = {}
	self.SectionsByName = {}
end

-- ISerializable
function self:Serialize (streamWriter)
	local startPosition = streamWriter:GetPosition ()
	streamWriter:Bytes    (PackageFile.Signature)
	streamWriter:UInt32   (PackageFile.FormatVersion)
	streamWriter:StringN8 (self.Name)
	streamWriter:StringN8 (self.Version)
	local fileLengthPosition = streamWriter:GetPosition ()
	streamWriter:UInt64   (0)
	streamWriter:UInt32   (#self.Sections)
	
	for section in self:GetSectionEnumerator () do
		streamWriter:StringN8 (section:GetName ())
		local startPosition = streamWriter:GetPosition ()
		streamWriter:UInt32 (0)
		
		section:Serialize (streamWriter)
		
		-- Write section length
		local endPosition = streamWriter:GetPosition ()
		streamWriter:SeekAbsolute (startPosition)
		streamWriter:UInt32 (endPosition - startPosition)
		streamWriter:SeekAbsolute (endPosition)
	end
	
	-- Write file length
	local endPosition = streamWriter:GetPosition ()
	streamWriter:SeekAbsolute (fileLengthPosition)
	streamWriter:UInt64 (endPosition - startPosition)
	streamWriter:SeekAbsolute (endPosition)
end

-- PackageFile
function self:GetName ()
	return self.Name
end

function self:GetVersion ()
	return self.Version
end

-- Sections
function self:AddSection (section)
	self:RemoveSection (section:GetName ())
	
	self.Sections [#self.Sections + 1] = section
	self.SectionsByName [section:GetName ()] = section
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
end
