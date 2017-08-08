local self = {}
GarrysMod.Keyboard = Class (self, Glass.IKeyboard)

function self:ctor ()
end

function self:IsControlDown ()
	return input.IsKeyDown (KEY_LCONTROL)
end

function self:IsShiftDown ()
	return input.IsKeyDown (KEY_LSHIFT)
end

function self:IsAltDown ()
	return input.IsKeyDown (KEY_LALT)
end

GarrysMod.Keyboard = GarrysMod.Keyboard ()
