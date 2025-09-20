--!strict
--service
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
--refs
local CONSTANTS = require(ReplicatedStorage.Shared.CONSTANT)
--modules
local Yumi = require(ReplicatedStorage.Shared.Core.Yumi)
--interfaces
local PlayerInterface= require(ReplicatedStorage.Controllers.Interface.PlayerProfileInterface)
local ProfileTemplate = require(ReplicatedStorage.Controllers.Systems.PlayerProfile.ProfileTemplate)
--
export type APIsType = {}

local module = {} :: APIsType & Yumi.System

--yumi

--apis
module._Setup = function()
   local data = PlayerInterface:RequestProfileDataAsync() :: ProfileTemplate.Profile
        if not data then
            return
        end
        local world = data.CurrentWorld :: number 
        if world and typeof(world) == "number" and world > 0 then
            local player = Players.LocalPlayer :: Player
            player:SetAttribute(CONSTANTS.PLAYER_ATTRIBUTE_CLIENT._WORLD,world)
            
        end
end

module._Start = function()
    
end

module.SetAttribute = function()

end

return module
