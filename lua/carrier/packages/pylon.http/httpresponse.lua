local self = {}
HTTP.HTTPResponse = Class(self)

function HTTP.HTTPResponse.FromHTTPResponse(url, code, content, headers)
	local httpResponse = HTTP.HTTPResponse(url, code)
	
	httpResponse.Message = HTTP.HTTPCodes.ToMessage(code) or ""
	httpResponse.Content = content
	httpResponse.Headers = headers or {}
	
	return httpResponse
end

function HTTP.HTTPResponse.FromFailure(url, message)
	local httpResponse = HTTP.HTTPResponse(url, nil)
	
	httpResponse.Message = message
	
	return httpResponse
end

function self:ctor(url, code)
	self.Url     = url
	self.Code    = code
	self.Message = nil
	self.Content = nil
	
	self.Headers = {}
end

function self:GetUrl()
	return self.Url
end

function self:GetCode()
	return self.Code
end

function self:GetContent()
	return self.Content
end

function self:GetContentLength()
	if self.Content == nil then return 0 end
	
	return #self.Content
end

function self:GetMessage()
	return self.Message
end

function self:IsSuccess()
	return self.Code == 200
end
