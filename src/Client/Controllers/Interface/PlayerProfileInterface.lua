local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerProfileSystem = require(ReplicatedStorage.Controllers.Systems.PlayerProfile)

local module = {} :: PlayerProfileSystem.APIsType

module.GetProfile = function(...)
	return PlayerProfileSystem.GetProfile(...)
end
module.RequestProfileDataAsync = function(...)
	return PlayerProfileSystem.RequestProfileDataAsync(...)
end
return module
