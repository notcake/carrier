-- PACKAGE Panopticon.Verification.Tests
local Verification = require("Panopticon.Verification")
local String = require("Pylon.String")

local function TestFile(path)
	local code = file.Read(path, CLIENT and "LCL" or "LSV")
	
	local luaSourceInformation = CAC.LuaSourceInformation(path)
	luaSourceInformation:AddCode(code)
	
	local luaFile = Verification.LuaFile(path, true)
	luaFile:AddCode(code)
	
	assert(luaSourceInformation:GetFunctionCount() == luaFile:GetFunctionCount())
	
	MsgN(path .. " [" .. luaFile:GetFunctionCount() .. "]")
	for i = 1, luaFile:GetFunctionCount() do
		local startLine, endLine, md5, crc32, sha256 = luaFile:GetFunction(i)
		local luaFunctionInformation = luaSourceInformation:GetFunction(i)
		assert(luaFunctionInformation:GetStartLine() == startLine)
		assert(luaFunctionInformation:GetEndLine() == endLine)
		assert(luaFunctionInformation:GetHash() == crc32)
		MsgN("\tLines " .. startLine .. "-" .. endLine .. " " .. string.format("%08x", crc32) .. " " .. String.ToHex(md5) .. " " .. String.ToHex(sha256))
	end
end

return function()
	if not CAC then include("cac/cac.lua") end
	
	local queue = { "carrier" }
	while #queue > 0 do
		local folder = queue[#queue]
		queue[#queue] = nil
		
		local files, folders = file.Find(folder .. "/*", CLIENT and "LCL" or "LSV")
		for _, v in ipairs(files) do
			TestFile(folder .. "/" .. v)
		end
		for _, v in ipairs(folders) do
			queue[#queue + 1] = folder .. "/" .. v
		end
	end
end
