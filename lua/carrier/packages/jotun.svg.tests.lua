local Color = require ("Pylon.Color")
local Svg   = require ("Jotun.Svg")

return function ()
	local image = Svg.Image.FromXml (
		[=[
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="1 2 100 101">
			  <path d="M30,1h40l29,29v40l-29,29h-40l-29-29v-40z" stroke="#000" fill="none"/> 
			  <path d="M31,3h38l28,28v38l-28,28h-38l-28-28v-38z" fill="#a23"/> 
			  <text x="50" y="68" font-size="48" fill="#FFF" text-anchor="middle"><![CDATA[410]]></text>
			</svg>
		]=]
	)
	assert (image:GetViewX      () == 1)
	assert (image:GetViewY      () == 2)
	assert (image:GetViewWidth  () == 100)
	assert (image:GetViewHeight () == 101)
	
	assert (image:GetChildCount () == 3)
	
	assert (image:GetChild (1):GetFillColor   () == nil)
	assert (image:GetChild (1):GetStrokeColor () == Color.Black)
	
	assert (image:GetChild (2):GetFillColor   () == Color.FromRGBA8888 (0xAA, 0x22, 0x33, 0xFF))
	assert (image:GetChild (2):GetStrokeColor () == nil)
	
	assert (image:GetChild (3):GetX () == 50)
	assert (image:GetChild (3):GetY () == 68)
end
