-- PACKAGE Carrier.Bootstrap.Generator.App

local loadstring = require_provider("loadstring")
local IO = require_provider("Pylon.IO")

local escapeSequences =
{
	["\\n"] = "\n",
	["\\r"] = "\r",
	["\\t"] = "\t",
	["\\\""] = "\""
}
local function String_Unescape(s)
	return string.gsub(s, "\\.", escapeSequences)
end

local function Preprocess(inputStream, outputStream)
	local code = inputStream:Read(inputStream:GetSize())
	for line in string.gmatch(code, "([^\n]-)\r?\n") do
		if string.match(line, "^%-%- EVAL (.*)") then
			local code = string.match(line, "^%-%- EVAL (.*)")
			local f = loadstring("return " .. code)
			setfenv(f, _ENV)
			outputStream:Write(f() .. "\r\n")
			print(f())
		elseif string.match(line, "^%-%- SED ([^%s]+) /(.+)/(g?)") then
			local path, escapedPattern, g = string.match(line, "^%-%- SED ([^%s]+) /(.+)/(g?)")
			local sourceInputStream = IO.FileInputStream.FromPath(path)
			sourceInputStream = sourceInputStream or IO.FileInputStream.FromPath("carrier/packages/" .. string.lower(path) .. ".lua")
			sourceInputStream = sourceInputStream or IO.FileInputStream.FromPath("carrier/packages/" .. string.lower(path) .. "/_ctor.lua")
			local code = sourceInputStream:Read(sourceInputStream:GetSize())
			sourceInputStream:Close()
			
			local pattern = String_Unescape(escapedPattern)
			local limit = g == "g" and math.huge or 1
			local count = 0
			for code in string.gmatch(code, pattern) do
				-- Remove comments
				code = string.gsub(code, "\n%s*%-%-%s[^\n]*", "")
				code = string.gsub(code, "%-%-%s[^\n]*", "")
				
				outputStream:Write(code .. "\r\n")
				print(code)
				count = count + 1
				if count >= limit then break end
			end
			
			if count == 0 then
				local line = "-- ERROR: SED " .. path .. " /" .. escapedPattern .. "/" .. g .. " FAILED!"
				outputStream:Write(line .. "\r\n")
				print(line)
			end
		elseif string.match(line, "^%-%- INCLUDE ([^%s]+)") then
			local path = string.match(line, "^%-%- INCLUDE ([^%s]+)")
			local sourceInputStream = IO.FileInputStream.FromPath(path)
			sourceInputStream = sourceInputStream or IO.FileInputStream.FromPath("carrier/packages/" .. string.lower(path) .. ".lua")
			sourceInputStream = sourceInputStream or IO.FileInputStream.FromPath("carrier/packages/" .. string.lower(path) .. "/_ctor.lua")
			local code = sourceInputStream:Read(sourceInputStream:GetSize())
			sourceInputStream:Close()
			
			local packageName = string.match(code, "%-%- PACKAGE ([^%s]+)")
			
			-- Remove comments
			code = string.gsub(code, "\n%s*%-%-%s[^\n]*", "")
			code = string.gsub(code, "%-%-%s[^\n]*", "")
			
			-- Remove requires
			code = string.gsub(code, "\nlocal[^%s]+%s*=%s*require_?p?r?o?v?i?d?e?r?%s*%(?%s*[\"'][^\n]*", "")
			
			-- Remove final return
			code = string.gsub(code, "return%s*([^\n]-)%s*$",
				function(expr)
					if expr == "" then return "" end
					return "local " .. string.match(packageName, "[^%.]+$") .. " = " .. expr
				end
			)
			
			outputStream:Write(code .. "\r\n")
			print(code)
		else
			outputStream:Write(line .. "\r\n")
			print(line)
		end
	end
end

local function PreprocessFile(inputPath, outputPath)
	local inputStream  = IO.FileInputStream.FromPath(inputPath)
	local outputStream = IO.FileOutputStream.FromPath(outputPath)
	Preprocess(inputStream, outputStream)
	inputStream:Close()
	outputStream:Close()
end

return function()
	PreprocessFile(
		"carrier/packages/carrier.bootstrap.generator.app/prebootstrap.source.lua",
		"carrier/packages/carrier.prebootstrap/carrier.prebootstrap.lua"
	)
	PreprocessFile(
		"carrier/packages/carrier.bootstrap.generator.app/bootstrap.source.lua",
		"carrier/packages/carrier.bootstrap/carrier.bootstrap.lua"
	)
end
