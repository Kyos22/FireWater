--// Services
local ServerScriptService = game:GetService("ServerScriptService")

--// Modules
local PlayerProfileSystem = require(ServerScriptService.Systems.PlayerProfile)

--// Interface
local interface = {} :: PlayerProfileSystem.APIsType

interface.GetPlayerProfile = function(...)
	return PlayerProfileSystem.GetPlayerProfile(...)
end
interface.GetEditablePlayerProfile = function(...)
	return PlayerProfileSystem.GetEditablePlayerProfile(...)
end
interface.UpdateClientProfile = function(...)
	return PlayerProfileSystem.UpdateClientProfile(...)
end

return interface
