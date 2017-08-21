local leftAngleBracket  = string.byte ("<")
local rightAngleBracket = string.byte (">")
local exclamationMark   = string.byte ("!")
local forwardSlash      = string.byte ("/")

function Xml.Parse (str, yield)
	local stack = {}
	
	local parser = StringParser (str)
	parser:AcceptWhitespace ()
	
	while not parser:IsEndOfInput () do
		if parser:AcceptLiteral ("<") then
			parser:AcceptWhitespace ()
			
			if parser:AcceptLiteral ("/") then
				-- Closing tag
				parser:AcceptWhitespace ()
				
				local name = parser:AcceptPattern ("[^ \r\n\t>]+")
				parser:AcceptWhitespace ()
				parser:AcceptLiteral (">")
				parser:AcceptWhitespace ()
				
				-- Remove element from stack
				if stack [#stack] and
				   string.lower (stack [#stack]:GetName ()) == string.lower (name) then
					stack [#stack] = nil
				end
				
				-- Emit closing tag
				yield (Xml.TagType.Closing, Xml.ElementNode (name))
				
				-- Advance
				startIndex = nextStartIndex
			elseif parser:AcceptLiteral ("!") then
				if parser:AcceptLiteral ("[CDATA[") then
					local text = parser:AcceptPattern ("(.-)()]]>") or
								 parser:AcceptPattern ("(.-)()$")
					parser:AcceptLiteral ("]]>")
					parser:AcceptWhitespace ()
					yield (Xml.TagType.Text, Xml.TextNode (text))
				else
					assert(false)
				end
			else
				-- Opening tag
				local name = parser:AcceptPattern ("[^ \r\n\t/>]+")
				parser:AcceptWhitespace ()
				
				local element = Xml.ElementNode (name)
				
				local selfClosing = false
				while not parser:IsEndOfInput () do
					if parser:AcceptLiteral ("/") then
						parser:AcceptPattern ("[^>]+") -- eat junk
						parser:AcceptLiteral (">")
						parser:AcceptWhitespace ()
						
						selfClosing = true
						break
					elseif parser:AcceptLiteral (">") then
						parser:AcceptWhitespace ()
						break
					else
						-- Attribute
						local name = parser:AcceptPattern ("[^ \t\r\n=>/]*")
						if parser:AcceptLiteral ("=") then
							if parser:AcceptLiteral ("\"") then
								local value = parser:AcceptPattern ("[^\"]*")
								element:AddAttribute (name, value)
								parser:AcceptLiteral ("\"")
							else
								local value = parser:AcceptPattern ("[^ \t\r\n>/]*")
								element:AddAttribute (name, value)
							end
						else
							element:AddAttribute (name, name)
						end
						
						parser:AcceptWhitespace ()
					end
				end
				
				-- Add element to stack
				if not selfClosing then
					stack [#stack + 1] = element
				end
				
				-- Emit tag
				yield (selfClosing and Xml.TagType.SelfClosing or Xml.TagType.Opening, element)
			end
		else
			-- Text
			-- Find '<' or end of input
			local text = parser:AcceptPattern ("([^<]-)()[ \t\r\n]*<") or
			             parser:AcceptPattern ("([^<]-)()[ \t\r\n]*$")
			parser:AcceptWhitespace ()
			
			-- Emit text
			yield (Xml.TagType.Text, Xml.TextNode (text))
			
			-- Advance
			startIndex = nextStartIndex
		end
	end
	
	return nil, nil
end

Xml.Parse = YieldEnumeratorFactory (Xml.Parse)
