local self = {}
HTTP.HTTPResponse = Class (self)

self.Url     = Property (nil,   "StringN32")

self.Success = Property (false, "Boolean")
self.Message = Property ("",    "StringN32")

self.Code    = Property (0,     "UInt16")
self.Content = Property (nil,   "StringN32")

function HTTP.HTTPResponse.FromHTTPResponse (url, code, content, headers)
	local httpResponse = HTTP.HTTPResponse ()
	
	httpResponse:SetUrl (url)
	httpResponse:SetSuccess (code == 200)
	httpResponse:SetCode (code)
	httpResponse:SetMessage (HTTP.HTTPCodes.ToMessage (code) or "")
	httpResponse:SetContent (content)
	httpResponse:SetHeaders (headers or {})
	
	return httpResponse
end

function HTTP.HTTPResponse.FromFailure (url, message)
	local httpResponse = HTTP.HTTPResponse ()
	
	httpResponse:SetUrl (url)
	httpResponse:SetSuccess (false)
	httpResponse:SetMessage (message)
	
	return httpResponse
end

function self:ctor ()
	self.Headers = {}
end

function self:GetContentLength ()
	if self:GetContent () == nil then return 0 end
	
	return #self:GetContent ()
end

function self:SetHeaders (headers)
	self.Headers = headers
end
