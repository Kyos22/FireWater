--!strict
--service
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players             = game:GetService("Players")
--refs
local WORLDS = game.Workspace:WaitForChild("Worlds")
--modules
local ZonePlus = require(ReplicatedStorage.Packages.ZonePlus)
local Yumi = require(ReplicatedStorage.Shared.Core.Yumi)
--observers
local PlayerObserver = require(ServerScriptService.Observers.PlayerProfileObserver)
-- interfaces
local PlayerInterface = require(ServerScriptService.Interfaces.PlayerProfile)
export type APIsType = {

}

local module = {} :: APIsType & Yumi.System
local connections = {}
-- apis
module._Start = function()
    connections["PlayerAdded"] = 
        -- Players.PlayerAdded:Connect(function(player: Player)
        --     local data = PlayerInterface.GetPlayerProfileAsync(player,5)
        --     print("data",data)
        -- end)
        PlayerObserver.ListenEvent(PlayerObserver.Event.Loaded, function(event: PlayerObserver.LoadedEventArgs)
            local data = event.Data
            print("data",data)
        end)

end

--yumi

--apis

return module
