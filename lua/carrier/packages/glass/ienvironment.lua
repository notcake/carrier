local self = {}
Glass.IEnvironment = Interface (self)

function self:ctor ()
end

function self:GetGraphicsContext ()
	Error ("IEnvironment:GetGraphicsContext : Not implemented.")
end

function self:GetTextRenderer ()
	Error ("IEnvironment:GetTextRenderer : Not implemented.")
end

function self:CreateView ()
	Error ("IEnvironment:CreateView : Not implemented.")
end
