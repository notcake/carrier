local self = {}
EnumeratorFunction = Class (self)

function self:ctor ()
	self.Functions = WeakKeyTable (self)
	
	self.ExtensionInstalled = false
	self.FunctionIndexer    = nil
	self.NextIndexer        = nil
	
	self:InstallFunctionExtension ()
end

function self:dtor ()
	self:UninstallFunctionExtension ()
end

function self:RegisterFunction (f)
	self.Functions [f] = true
	return f
end

function self:UnregisterFunction (f)
	self.Functions [f] = nil
end

function self:InstallFunctionExtension ()
	if self.ExtensionInstalled then return end
	
	self.ExtensionInstalled = true
	
	local metatable = getmetatable (function () end)
	local indexer = nil
	local indexerIsFunction = false
	if metatable then
		indexer = metatable.__index or metatable
		indexerIsFunction = type (indexer) == "function"
	else
		metatable = {}
		indexer = metatable
		indexerIsFunction = false
		debug.setmetatable (function () end, metatable)
	end
	
	self.NextIndexer = indexer
	
	local enumeratorFunctions = self.Functions
	local flattenedEnumeratorMethodTable = Enumeration.FunctionEnumerator:GetFlattenedMethodTable ()
	self.FunctionIndexer = function (self, k)
		if enumeratorFunctions [self] then
			local v = flattenedEnumeratorMethodTable [k]
			if v ~= nil then return v end
		end
		
		if not indexer then return nil end
		
		if indexerIsFunction then return indexer (self, k) end
		return indexer [k]
	end
	
	metatable.__index = self.FunctionIndexer
end

function self:UninstallFunctionExtension ()
	if not self.ExtensionInstalled then return end
	
	self.ExtensionInstalled = false
	
	local metatable = getmetatable (function () end)
	if not metatable then return end
	
	if metatable.__index ~= self.FunctionIndexer then
		Error ("EnumeratorFunctionExtension:UninstallFunctionExtension : Unable to restore function __indexer cleanly!")
	end
	
	metatable.__index = self.NextIndexer
end

EnumeratorFunction = EnumeratorFunction ()
