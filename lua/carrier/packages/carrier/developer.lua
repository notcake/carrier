local sv_allowcslua = GetConVar("sv_allowcslua")
local carrier_developer_sv = CreateConVar("carrier_developer_sv", "0", FCVAR_ARCHIVE + FCVAR_REPLICATED)
local carrier_developer_cl = CLIENT and CreateClientConVar("carrier_developer_cl", "0", true, false) or nil
local carrier_developer    = CLIENT and carrier_developer_cl or carrier_developer_sv

function Carrier.IsLocalDeveloperEnabled()
	return carrier_developer:GetBool() and(SERVER or sv_allowcslua:GetBool())
end

function Carrier.IsServerDeveloperEnabled()
	return carrier_developer_sv:GetBool() and util.NetworkStringToID("Carrier.RequestDeveloperPackageList") ~= 0
end
