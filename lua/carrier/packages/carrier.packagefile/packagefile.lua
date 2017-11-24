local self = {}
PackageFile = Class (self, ISerializable)
PackageFile.Signature     = "\xffPKG\r\n\x1a\n"
PackageFile.FormatVersion = 1

function PackageFile.Deserialize (streamReader, exponent, modulus)
	local signature = streamReader:Bytes (#PackageFile.Signature)
	if signature ~= PackageFile.Signature then return nil end
	
	local formatVersion = streamReader:UInt32 ()
	if formatVersion == PackageFile.FormatVersion then
		local name    = streamReader:StringN8 ()
		local version = streamReader:StringN8 ()
		local packageFile = PackageFile (name, version)
		streamReader:UInt64 ()
		
		local sectionPositions = {}
		local sectionLengths   = {}
		
		local sectionCount = streamReader:UInt32 ()
		for i = 1, sectionCount do
			local startPosition = streamReader:GetPosition ()
			local name   = streamReader:StringN8 ()
			local length = streamReader:UInt32 ()
			sectionLengths [name] = streamReader:GetPosition () - startPosition + length
			sectionPositions [name] = startPosition
			
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
				section = PackageFile.UnknownSection (name, streamReader:Bytes (sectionLengths [name]))
			end
			
			section:Deserialize (streamReader)
			packageFile.SectionsByName [name] = section
			packageFile.Sections [#packageFile.Sections + 1] = section
		end
		
		-- Verify
		if exponent and modulus then
			local signatureSection = packageFile:GetSection ("signature")
			signatureSection:SetVerified (signatureSection:VerifySelf (name, version, exponent, modulus))
			
			if signatureSection:IsVerified () then
				local endPosition = streamReader:GetPosition ()
				for i = 1, signatureSection:GetSectionHashCount () do
					local sectionName, md5a, sha256a = signatureSection:GetSectionHash (i)
					if sectionPositions [sectionName] then
						streamReader:SeekAbsolute (sectionPositions [sectionName])
						local data = streamReader:Bytes (sectionLengths [sectionName])
						local md5b = String.FromHex (Crypto.MD5.Compute (data))
						packageFile:GetSection (sectionName):SetVerified (md5a == md5b)
					end
				end
				streamReader:SeekAbsolute (endPosition)
			end
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
		local lengthPosition = streamWriter:GetPosition ()
		streamWriter:UInt32 (0)
		local startPosition = streamWriter:GetPosition ()
		
		section:Serialize (streamWriter)
		
		-- Write section length
		local endPosition = streamWriter:GetPosition ()
		streamWriter:SeekAbsolute (lengthPosition)
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
