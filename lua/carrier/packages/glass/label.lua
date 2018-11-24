local self = {}
Glass.Label = Class(self, Glass.View, Glass.ILabel)

function self:ctor()
	self.Text = ""
	self.TextClass = Glass.TextClass.Default
	self.TextColor = nil
	self.Font = nil
	self.HorizontalAlignment = Glass.HorizontalAlignment.Left
	self.VerticalAlignment   = Glass.VerticalAlignment.Center
end

-- IView
-- Content layout
function self:GetPreferredSize(maximumWidth, maximumHeight)
	if not self:IsHandleCreated() then return self:GetSize() end
	return self:GetEnvironment():GetLabelPreferredSize(self, self:GetHandle(), maximumWidth, maximumHeight)
end

-- Internal
function self:OnSkinChanged(skin)
	self:SetTextColor(skin:GetTextColor())
end

-- View
-- Internal
function self:CreateHandleInEnvironment(environment, parent)
	return environment:CreateLabelHandle(self, parent:GetHandle())
end

-- ILabel
function self:GetText()
	return self.Text
end

function self:GetTextClass()
	return self.TextClass
end

function self:GetTextColor()
	return self.TextColor
end

function self:GetFont()
	return self.Font
end

function self:GetHorizontalAlignment()
	return self.HorizontalAlignment
end

function self:GetVerticalAlignment()
	return self.VerticalAlignment
end

function self:SetText(text)
	if self.Text == text then return end
	
	self.Text = text
	
	if self:IsHandleCreated() then
		self:GetEnvironment():SetLabelText(self, self:GetHandle(), self.Text)
	end
end

function self:SetTextClass(textClass)
	if self.TextClass == textClass then return end
	
	self.TextClass = textClass
	
	if self:IsHandleCreated() then
		self:GetEnvironment():SetLabelTextClass(self, self:GetHandle(), self.TextClass)
	end
end

function self:SetTextColor(textColor)
	if self.TextColor == textColor then return end
	
	self.TextColor = textColor
	
	if self:IsHandleCreated() then
		self:GetEnvironment():SetLabelTextColor(self, self:GetHandle(), self.TextColor)
	end
end

function self:SetFont(font)
	if self.Font == font then return end
	
	self.Font = font
	
	if self:IsHandleCreated() then
		self:GetEnvironment():SetLabelFont(self, self:GetHandle(), self.Font)
	end
end

function self:SetHorizontalAlignment(horizontalAlignment)
	if self.HorizontalAlignment == horizontalAlignment then return end
	
	self.HorizontalAlignment = horizontalAlignment
	
	if self:IsHandleCreated() then
		self:GetEnvironment():SetLabelHorizontalAlignment(self, self:GetHandle(), self.HorizontalAlignment)
	end
end

function self:SetVerticalAlignment(verticalAlignment)
	if self.VerticalAlignment == verticalAlignment then return end
	
	self.VerticalAlignment = verticalAlignment
	
	if self:IsHandleCreated() then
		self:GetEnvironment():SetLabelVerticalAlignment(self, self:GetHandle(), self.VerticalAlignment)
	end
end
