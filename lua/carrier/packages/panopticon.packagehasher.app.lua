-- PACKAGE Panopticon.PackageHasher.App
local PackageFile = require ("Carrier.PackageFile")
local IO = require_provider ("Pylon.IO")
local Verification = require ("Panopticon.Verification")

local String = require ("Pylon.String")

return function (command, inputFileName, outputFileName)
	if not inputFileName or not outputFileName then
		print ("Usage: " .. command .. " <package file> <output file>")
	else
		local inputStream = IO.FileInputStream.FromPath (inputFileName)
		if not inputStream then
			print ("Could not open '" .. inputFileName .. "' for reading!")
			return
		end
		
		-- Read package
		local streamReader = inputStream:ToStreamReader ()
		local packageFile = PackageFile.Deserialize (streamReader)
		print ("Package " .. packageFile:GetName () .. " " .. packageFile:GetVersion ())
		streamReader:Close ()
		
		-- Process package
		local codeSection = packageFile:GetSection ("code")
		local luaHashesSection = PackageFile.LuaHashesSection ()
		for file in codeSection:GetFileEnumerator () do
			local luaFile = Verification.LuaFile (file:GetPath (), true)
			luaFile:SetCRC32 (file:GetCRC32 ())
			luaFile:SetLastModificationTime (file:GetLastModificationTime ())
			luaFile:SetSize (file:GetSize ())
			
			-- Add code
			local success, err = luaFile:AddCode (file:GetData ())
			if err then print ("\tError: " .. err) end
			
			-- Add lua file to hashes section
			luaHashesSection:AddLuaFile (luaFile)
			
			-- Print debug
			print ("\t" .. file:GetPath () .. " (" .. #file:GetData () .. " B, " .. luaFile:GetFunctionCount () .. " functions)")
			for i = 1, luaFile:GetFunctionCount () do
				local startLine, endLine, md5, crc32, sha256 = luaFile:GetFunction (i)
				assert (#md5 == 16)
				assert (#sha256 == 32)
			end
		end
		
		-- Add hashes section to package
		packageFile:AddSection (luaHashesSection)
		
		-- Update size fields
		packageFile:Update ()
		
		-- Write new package
		local outputStream = IO.FileOutputStream.FromPath (outputFileName)
		local streamWriter = outputStream:ToStreamWriter ()
		packageFile:Serialize (streamWriter)
		streamWriter:Close ()
	end
end
