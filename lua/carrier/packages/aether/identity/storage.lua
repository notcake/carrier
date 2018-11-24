Aether.Identity.Storage = {}

function Aether.Identity.Storage.Initialize ()
	local success, result = Aether.Identity.Storage.Query (
		"CREATE TABLE IF NOT EXISTS `aether.identities`(\n" ..
		"	`ip` VARCHAR(15) NOT NULL,\n" ..
		"	`port` SMALLINT UNSIGNED NOT NULL,\n" ..
		"	`id` BIGINT UNSIGNED NOT NULL,\n" ..
		"	`privateKey` TEXT NOT NULL,\n" ..
		"	\n" ..
		"	PRIMARY KEY(`ip`, `port`)\n" ..
		");"
	)
	assert (success, result)
end

function Aether.Identity.Storage.Load (ip, port)
	local success, rows = Aether.Identity.Storage.Query ("SELECT * FROM `aether.identities` WHERE `ip` = ? AND `port` = ?;", ip, port)
	if not success then return nil, nil end
	
	if not rows then return nil, nil end
	return rows [1].id, rows [1].privateKey
end

function Aether.Identity.Storage.Save (ip, port, id, privateKey)
	local success, _ = Aether.Identity.Storage.Query ("INSERT OR REPLACE INTO `aether.identities`(`ip`, `port`, `id`, `privateKey`) VALUES (?, ?, ?, ?);", ip, port, id, privateKey)
	return success
end

function Aether.Identity.Storage.Query (query, ...)
	local arguments = {...}
	
	local i = 0
	local query = string.gsub (query, "%?",
		function ()
			i = i + 1
			if type (arguments [i]) == "string" then
				return sql.SQLStr (arguments [i])
			elseif type (arguments [i]) == "number" then
				return tostring (arguments [i])
			end
		end
	)
	
	local result = sql.Query (query)
	if result ~= false then
		return true, result
	else
		return false, sql.LastError ()
	end
end
