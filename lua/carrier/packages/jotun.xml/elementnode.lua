local self = {}
Xml.ElementNode = Class (self, Xml.Node)

function self:ctor (name)
	self.Name = name
	
	self.Children         = nil
	
	self.AttributeIndices = nil
	self.AttributeNames   = nil
	self.AttributeValues  = nil
end

-- Node
function self:GetNodeType ()
	return Xml.NodeType.Element
end

function self:ToString ()
	local str = "<" .. self.Name
	
	for name, value in self:GetAttributeEnumerator () do
		str = str .. " " .. name .. "=\"" .. Xml.Escape (value) .. "\""
	end
	
	if self:GetChildCount () > 0 then
		str = str .. ">"
		for node in self:GetChildEnumerator () do
			str = str .. node:ToString ()
		end
		str = str .. "</" .. self.Name .. ">"
	else
		str = str .. "/>"
	end
	
	return str
end

-- ElementNode
function self:GetName ()
	return self.Name
end

-- Children
function self:AddChild (node)
	if self:IndexOfChild (node) then return end
	
	self.Children = self.Children or {}
	self.Children [#self.Children + 1] = node
	
	node:SetParent (self)
end

function self:GetChild (i)
	if not self.Children then return nil end
	return self.Children [i]
end

function self:GetChildCount ()
	if not self.Children then return 0 end
	return #self.Children
end

function self:GetChildEnumerator ()
	return ArrayEnumerator (self.Children)
end

function self:RemoveChild (node)
	if not self.Children then return end
	
	local index = self:IndexOfChild (node)
	table.remove (self.Children, index)
	
	if node:GetParent () == self then
		node:SetParent (nil)
	end
end

function self:IndexOfChild (node)
	if not self.Children then return nil end
	
	for i = 1, #self.Children do
		if self.Children [i] == node then
			return i
		end
	end
	
	return nil
end

-- Attributes
function self:AddAttribute (name, value)
	local value = value or ""
	
	self.AttributeIndices = self.AttributeIndices or {}
	self.AttributeNames   = self.AttributeNames   or {}
	self.AttributeValues  = self.AttributeValues  or {}
	
	local lowercaseName = string.lower (name)
	self.AttributeIndices [lowercaseName] = self.AttributeIndices [lowercaseName] or #self.AttributeNames + 1
	
	self.AttributeNames  [#self.AttributeNames  + 1] = name
	self.AttributeValues [#self.AttributeValues + 1] = value
end

function self:ClearAttributes ()
	self.AttributeIndices = nil
	self.AttributeNames   = nil
	self.AttributeValues  = nil
end

function self:GetAttribute (name)
	if not self.AttributeIndices then return nil end
	
	local index = self.AttributeIndices [name] or
	              self.AttributeIndices [string.lower (name)]
	return self.AttributeValues [index]
end

function self:GetAttributeEnumerator ()
	if not self.AttributeNames then
		return function () return nil, nil end
	end
	
	local i = 0
	return function ()
		i = i + 1
		return self.AttributeNames [i], self.AttributeValues [i]
	end
end

function self:RemoveAttribute (name)
	if not self.AttributeIndices then return end
	
	local lowercaseName = string.lower (name)
	local index = self.AttributeIndices [lowercaseName]
	if not index then return end
	
	table.remove (self.AttributeNames,  index)
	table.remove (self.AttributeValues, index)
	
	for i = index, #self.AttributeNames do
		if string.lower (self.AttributeNames [i] == lowercaseName) then
			self.AttributeIndices [self.AttributeNames [i]] = i
			break
		end
	end
end

function self:SetAttribute (name, value)
	local value = value or ""
	
	self.AttributeIndices = self.AttributeIndices or {}
	self.AttributeNames   = self.AttributeNames   or {}
	self.AttributeValues  = self.AttributeValues  or {}
	
	local lowercaseName = nil
	local index = self.AttributeIndices [name]
	if not index then
		lowercaseName = string.lower (name)
		index = self.AttributeIndices [string.lower (name)]
	end
	
	if index then
		self.AttributeValues [index] = value
	else
		self.AttributeIndices [lowercaseName] = #self.AttributeNames + 1
		
		self.AttributeNames  [#self.AttributeNames  + 1] = name
		self.AttributeValues [#self.AttributeValues + 1] = value
	end
end
