FileSystem.FileMode = Flags(
	{
		Read         = 0x00000001,
		Write        = 0x00000002,
		ReadWrite    = 0x00000003,
		
		Append       = 0x00000006,
		Truncate     = 0x0000000A, -- truncate an existing file
		
		Open         = 0x00000010, -- open if file exists
		Create       = 0x00000020, -- create if file does not exist
		OpenOrCreate = 0x00000030, -- create if file does not exist, open otherwise
	}
)

function FileSystem.FileMode:ToCString(flags)
	-- r   Read, Open
	-- w   Write, OpenOrCreate, Truncate
	-- a   Write, OpenOrCreate, Append
	-- r+  Read, Write, Open
	-- w+  Read, Write, OpenOrCreate, Truncate
	-- a+  Read, Write, OpenOrCreate, Append

	if self:HasFlag(flags, FileSystem.FileMode.Truncate) then
		return self:HasFlag(flags, FileSystem.FileMode.Read) and "w+" or "w"
	elseif self:HasFlag(flags, FileMode.Append) then
		return self:HasFlag(flags, FileSystem.FileMode.Read) and "a+" or "a"
	else
		return self:HasFlag(flags, FileSystem.FileMode.Write) and "r+" or "r"
	end
end
