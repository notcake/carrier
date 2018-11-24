local self = {}
Parser = Class(self)

function self:ctor(str, yield)
	self.Parser = StringParser(str)
	
	self.Document = nil
	
	local stack = {}
	self.Parser:AcceptWhitespace()
	
	while not self.Parser:IsEndOfInput() do
		if self.Parser:AcceptLiteral("<") then
			self.Parser:AcceptWhitespace()
			
			if self.Parser:AcceptLiteral("/") then
				-- Closing tag
				self.Parser:AcceptWhitespace()
				
				local name = self.Parser:AcceptPattern("[^ \r\n\t>]+")
				self.Parser:AcceptWhitespace()
				self.Parser:AcceptLiteral(">")
				self.Parser:AcceptWhitespace()
				
				-- Remove element from stack
				local element = nil
				if stack[#stack] and
				   string.lower(stack[#stack]:GetName()) == string.lower(name) then
					element = stack[#stack]
					if yield and element:GetParent() then
						element:GetParent():RemoveChild(element)
					end
					
					stack[#stack] = nil
				end
				
				-- Emit closing tag
				if yield then
					yield(Xml.TagType.Closing, element:GetName() == name and element or Xml.ElementNode(name))
				end
				
				-- Advance
				startIndex = nextStartIndex
			elseif self.Parser:AcceptLiteral("!") then
				if self.Parser:AcceptLiteral("[CDATA[") then
					local text = self.Parser:AcceptPattern("(.-)()]]>") or
								 self.Parser:AcceptPattern("(.-)()$")
					self.Parser:AcceptLiteral("]]>")
					self.Parser:AcceptWhitespace()
					
					-- Emit text
					local text = Xml.TextNode(text)
					if stack[#stack] then
						stack[#stack]:AddChild(text)
					end
					
					if yield then
						yield(Xml.TagType.Text, text)
					
						if stack[#stack] then
							stack[#stack]:RemoveChild(text)
						end
					end
				elseif self.Parser:AcceptLiteral("--") then
					local text = self.Parser:AcceptPattern("(.-)()%-%->") or
								 self.Parser:AcceptPattern("(.-)()$")
					self.Parser:AcceptLiteral("-->")
					self.Parser:AcceptWhitespace()
					
					-- Emit comment
					local comment = Xml.CommentNode(text)
					if stack[#stack] then
						stack[#stack]:AddChild(comment)
					end
					
					if yield then
						yield(Xml.TagType.Comment, comment)
					
						if stack[#stack] then
							stack[#stack]:RemoveChild(comment)
						end
					end
				else
					assert(false)
				end
			else
				-- Opening tag
				local name = self.Parser:AcceptPattern("[^ \r\n\t/>]+")
				self.Parser:AcceptWhitespace()
				
				local element = Xml.ElementNode(name)
				self.Document = self.Document or element
				
				local selfClosing = false
				while not self.Parser:IsEndOfInput() do
					if self.Parser:AcceptLiteral("/") then
						self.Parser:AcceptPattern("[^>]+") -- eat junk
						self.Parser:AcceptLiteral(">")
						self.Parser:AcceptWhitespace()
						
						selfClosing = true
						break
					elseif self.Parser:AcceptLiteral(">") then
						self.Parser:AcceptWhitespace()
						break
					else
						-- Attribute
						local name = self.Parser:AcceptPattern("[^ \t\r\n=>/]*")
						if self.Parser:AcceptLiteral("=") then
							if self.Parser:AcceptLiteral("\"") then
								local value = self.Parser:AcceptPattern("[^\"]*")
								element:AddAttribute(name, value)
								self.Parser:AcceptLiteral("\"")
							elseif self.Parser:AcceptLiteral("'") then
								local value = self.Parser:AcceptPattern("[^']*")
								element:AddAttribute(name, value)
								self.Parser:AcceptLiteral("'")
							else
								local value = self.Parser:AcceptPattern("[^ \t\r\n>/]*")
								element:AddAttribute(name, value)
							end
						else
							element:AddAttribute(name, name)
						end
						
						self.Parser:AcceptWhitespace()
					end
				end
				
				if stack[#stack] then
					stack[#stack]:AddChild(element)
				end
				
				-- Add element to stack
				if not selfClosing then
					stack[#stack + 1] = element
				end
				
				-- Emit tag
				if yield then
					yield(selfClosing and Xml.TagType.SelfClosing or Xml.TagType.Opening, element)
				
					if selfClosing then
						if stack[#stack] then
							stack[#stack]:RemoveChild(element)
						end
					end
				end
			end
		else
			-- Text
			-- Find '<' or end of input
			local text = self.Parser:AcceptPattern("([^<]-)()[ \t\r\n]*<") or
			             self.Parser:AcceptPattern("([^<]-)()[ \t\r\n]*$")
			self.Parser:AcceptWhitespace()
			
			-- Emit text
			local text = Xml.TextNode(text)
			if stack[#stack] then
				stack[#stack]:AddChild(text)
			end
			
			if yield then
				yield(Xml.TagType.Text, text)
			
				if stack[#stack] then
					stack[#stack]:RemoveChild(text)
				end
			end
			
			-- Advance
			startIndex = nextStartIndex
		end
	end
	
	self.Document = self.Document or stack[1]
end

function self:GetDocument()
	return self.Document
end
