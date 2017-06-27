local self = {}
Util.ISavable = Interface (self)

function self:ctor ()
end

function self:Save ()
	Error ("ISavable:Save : Not implemented.")
end

function self:Load ()
	Error ("ISavable:Load : Not implemented.")
end
