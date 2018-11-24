MouseButtons = {}

local nativeToButton = {}
nativeToButton[MOUSE_LEFT]   = Glass.MouseButtons.Left
nativeToButton[MOUSE_RIGHT]  = Glass.MouseButtons.Right
nativeToButton[MOUSE_MIDDLE] = Glass.MouseButtons.Middle
nativeToButton[MOUSE_4]      = Glass.MouseButtons.Mouse4
nativeToButton[MOUSE_5]      = Glass.MouseButtons.Mouse5

local buttonToNative = Map.Invert(nativeToButton)

function MouseButtons.Poll()
	local mouseButtons = 0
	
	for mouseCode, mouseButton in pairs(nativeToButton) do
		if input.IsMouseDown(mouseCode) then
			mouseButtons = mouseButtons + mouseButton
		end
	end
	
	return mouseButtons
end

function MouseButtons.FromNative(mouseCode)
	return nativeToButton[mouseCode]
end

function MouseButtons.ToNative(mouseButton)
	return buttonToNative[mouseButton]
end
