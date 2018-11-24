-- PACKAGE GarrysMod.FontCache

OOP = require("Pylon.OOP")

Glass = require("Glass")

local self = {}
FontCache = OOP.Class(self)

function self:ctor()
	self.FontIds = setmetatable({}, { __mode = "k" })
	self.IdFonts = setmetatable({}, { __mode = "v" })
end

function self:GetFont(id)
	return self.IdFonts[id]
end

function self:GetFontId(font)
	local id = self.FontIds[font]
	if id then return id end
	
	local id = "GarrysMod.FontCache_" .. font:GetName() .. "_" .. font:GetSize() .. "_" .. font:GetWeight()
	self.FontIds[font] = id
	self.IdFonts[id] = font
	
	surface.CreateFont(id,
		{
			font     = font:GetName(),
			size     = font:GetSize(),
			weight   = font:GetWeight(),
			extended = true
		}
	)
	
	return id
end

FontCache = FontCache()

return FontCache
