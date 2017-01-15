local self = {}
OOP.Property = OOP.Class (self)

OOP.Property.NextInstanceId = 0

function self:ctor (initialValue, type, evented)
	self.InstanceId = OOP.Property.NextInstanceId
	OOP.Property.NextInstanceId = OOP.Property.NextInstanceId + 1
	
	self.Name         = nil
	self.Description  = nil
	self.InitialValue = initialValue
	self.Nullable     = false
	self.Type         = type
	self.Evented      = evented
	
	if self.Type and string.sub (self.Type, -1) == "?" then
		self.Nullable = true
		self.Type = string.sub (self.Type, 1, -2)
	end
end

-- Property
function self:GetInstanceId ()
	return self.InstanceId
end

function self:GetName ()
	return self.Name
end

function self:SetName (name)
	self.Name = name
	return self
end

function self:GetDescription ()
	return self.Description
end

function self:SetDescription (description)
	self.Description = description
	return self
end

function self:GetInitialValue ()
	return self.InitialValue
end

function self:SetInitialValue (initialValue)
	self.InitialValue = initialValue
	return self
end

function self:IsNullable ()
	return self.Nullable
end

function self:SetNullable (nullable)
	self.Nullable = nullable
	return self
end

function self:GetType ()
	return self.Type
end

function self:SetType (type)
	self.Type = type
	return self
end

function self:IsEvented ()
	return self.Evented
end

function self:SetEvented (evented)
	self.Evented = evented
	return self
end

function self:GetGetterName ()
	if self.Type == "Boolean" then
		return "Is" .. self.Name
	else
		return "Get" .. self.Name
	end
end

function self:GetSetterName ()
	return "Set" .. self.Name
end

function self:GetGetter ()
	local name = self.Name
	return function (self)
		return self [name]
	end
end

function self:GetSetter ()
	local name = self.Name
	local eventName = self.Name .. "Changed"
	if self:IsEvented () then
		return function (self, value)
			local previousValue = self [name]
			
			if previousValue == value then return self end
			
			self [name] = value
			
			self [eventName]:Dispatch (previousValue, value)
			self.Changed:Dispatch ()
			
			return self
		end
	else
		return function (self, value)
			self [name] = value
			return self
		end
	end
end
