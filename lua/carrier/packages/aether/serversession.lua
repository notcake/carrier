local self = {}
Aether.ServerSession = Class (self, Aether.IServerSession)

function self:ctor (apiKey)
	self.ApiKey = apiKey
end

function self:GetApiKey ()
	return self.ApiKey
end
