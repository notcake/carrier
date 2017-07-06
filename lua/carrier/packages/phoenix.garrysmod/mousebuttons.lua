MouseButtons = {}

local nativeToButton = {}
nativeToButton [MOUSE_LEFT]   = Core.MouseButtons.Left
nativeToButton [MOUSE_RIGHT]  = Core.MouseButtons.Right
nativeToButton [MOUSE_MIDDLE] = Core.MouseButtons.Middle
nativeToButton [MOUSE_4]      = Core.MouseButtons.Mouse4
nativeToButton [MOUSE_5]      = Core.MouseButtons.Mouse5

local Table = require ("Pylon.Table")
local buttonToNative = Table.Invert (nativeToButton)

function MouseButtons.Poll ()
	local mouseButtons = 0
	
	for mouseCode, mouseButton in pairs (nativeToButton) do
		if input.IsMouseDown (mouseCode) then
			mouseButtons = mouseButtons + mouseButton
		end
	end
	
	return mouseButtons
end

function MouseButtons.FromNative (mouseCode)
	return nativeToButton [mouseCode]
end

function MouseButtons.ToNative (mouseButton)
	return buttonToNative [mouseButton]
end
