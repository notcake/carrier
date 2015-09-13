function OOP.Enum (enum)
	if not next (enum) then
		OOP.Error ("Knotcake.OOP.Enum : This enum appears to be empty!")
	end
	
	OOP.Table.Invert (enum, enum)
	return enum
end