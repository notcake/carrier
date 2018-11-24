Aether.Identity.API = {}

local tostring    = tostring
local string_find = string.find

function Aether.Identity.API.ComputeChallengeResponse(algorithm, challenge, difficulty)
	local challenge = String.FromHex(challenge)
	local pattern   = "^" .. string.rep("0", math.ceil(difficulty / 4))
	
	-- string.char cache
	local string_char = {}
	for i = 0, 255 do string_char[i] = string.char(i) end
	
	local hasher = nil
	if algorithm == "md5" then
		hasher = Crypto.MD5
	elseif algorithm == "sha256" then
		hasher = Crypto.SHA256
	else
		return false, "Unknown challenge algorithm " .. algorithm
	end
	
	local nonce = nil
	Lua.WithoutDebugHook(
		function()
			
			local initial = hasher()
			initial:Update(challenge)
			
			local hash = hasher()
			for c0 = 0x00, 0xFF do
				for c1 = 0x00, 0xFF do
					for c2 = 0x00, 0xFF do
						initial:Clone(hash)
						hash:Update(string_char[c0])
						hash:Update(string_char[c1])
						hash:Update(string_char[c2])
						local hash = hash:Finish()
						
						if string_find(hash, pattern) then
							nonce = string.format("%02x%02x%02x", c0, c1, c2)
							return
						end
					end
				end
			end
		end
	)
	
	return true, nonce
end

function Aether.Identity.API.Register(ip, port, name)
	return Task.Run(
		function()
			local success, response = Aether.API.Post("/api/servers/v1/register"):Await()
			if not success then return response end
			
			local success, nonce = Aether.Identity.API.ComputeChallengeResponse(response.algorithm, response.challenge, tonumber(response.difficulty))
			if not success then return false, nonce end
			
			local success, response = Aether.API.Post("/api/servers/v1/register",
				{
					challenge = response.challenge,
					nonce     = nonce,
					ip        = ip,
					port      = port,
					name      = name
				}
			):Await()
			if not success then return response end
			
			return true, response.id, response.privateKey
		end
	)
end

function Aether.Identity.API.ParsePrivateKey(privateKey)
	local base64 = privateKey
	base64 = string.gsub(base64, "%-%-%-%-%-[^\n]*\n", "")
	base64 = string.gsub(base64, "%s+", "")
	
	local data = Base64.Decode(base64)
	data = Asn1.Deserialize(data)
	-- version, N, e, d, p, q, d mod (p - 1), d mod (q - 1), q^-1 mod p
	
	-- N, e, d
	return data[2], data[3], data[4]
end

function Aether.Identity.API.Login(id, privateKey)
	return Task.Run(
		function()
			local success, response = Aether.API.Post("/api/servers/v1/login", { id = id }):Await()
			if not success then return response end
			
			local N, e, d = Aether.Identity.API.ParsePrivateKey(privateKey)
			
			local t0 = SysTime()
			local signature = Lua.WithoutDebugHook(
				function()
					local sha256 = Crypto.SHA256.Compute(String.FromHex(response.challenge))
					local sha256 = String.FromHex(sha256)
					
					local asn1 = { { Asn1.ObjectIdentifier.sha256, Asn1.Null() }, sha256 }
					local asn1 = Asn1.Serialize(asn1)
					
					local byteCount = math.ceil(N:GetBitCount() / 8)
					local signature = "\x01" .. string.rep("\xFF", byteCount - #asn1 - 3) .. "\x00" .. asn1
					local signature = BigInteger.FromBlob(signature):ExponentiateMod(d, N):ToBlob()
					return String.ToHex(signature)
				end
			)
			
			local success, response = Aether.API.Post("/api/servers/v1/login", { id = id, challenge = response.challenge, response = signature }):Await()
			if not success then return response end
			
			return response.sessionKey
		end
	)
end
