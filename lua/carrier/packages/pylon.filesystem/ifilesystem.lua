-- interface IFileSystem
local self = {}
FileSystem.IFileSystem = Interface(self)

-- :() -> bool
function self:IsCaseSensitive(path)
	Error("IFileSystem:IsCaseSensitive : Not implemented.")
end

-- :(string) -> Future<()>
function self:CreateDirectory(path)
	Error("IFileSystem:CreateDirectory : Not implemented.")
end

-- :(string) -> Future<()>
function self:Delete(path)
	Error("IFileSystem:Delete : Not implemented.")
end

-- :(string) -> yielding IEnumerator<NodeType, string>
function self:EnumerateChildren(path)
	Error("IFileSystem:EnumerateChildren : Not implemented.")
end

-- :(string) -> Future<bool>
function self:Exists(path)
	Error("IFileSystem:Exists : Not implemented.")
end

-- :(string) -> Future<uint64?>
function self:GetFileSize(path)
	Error("IFileSystem:GetFileSize : Not implemented.")
end

-- :(string) -> Future<double?>
function self:GetModificationTime(path)
	Error("IFileSystem:GetModificationTime : Not implemented.")
end

-- :(string) -> Future<bool>
function self:IsDirectory(path)
	Error("IFileSystem:IsDirectory : Not implemented.")
end

-- :(string) -> Future<bool>
function self:IsFile(path)
	Error("IFileSystem:IsFile : Not implemented.")
end

-- :(string, FileMode) -> Future<I>
function self:Open(path, fileMode)
	Error("IFileSystem:Open : Not implemented.")
end

function self:Read(path, data)
	return Task.Run(
		function()
			local success, fileStream = self:Open():await()
			if not success then return false end
			
			local success, data = fileStream:Read(fileStream:GetSize()):await()
			success = success and fileStream:Close():await()
			
			return success, data
		end
	)
end

function self:Write(path, data)
	return Task.Run(
		function()
			local success, fileStream = self:Open(path, "wb"):await()
			if not success then return false end
			
			success = fileStream:Write(data, #data):await()
			success = success and fileStream:Close():await()
			
			return success
		end
	)
end
