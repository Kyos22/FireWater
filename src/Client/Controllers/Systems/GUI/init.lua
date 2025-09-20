--!strict
--service
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--refs
--modules
local Yumi = require(ReplicatedStorage.Shared.Core.Yumi)
local Client = require(ReplicatedStorage.Shared.Network.Client)
local Panels = require(script.Panels)
--
export type APIsType = {
    Panels : Panels.Panels,
}

local GUI = {} :: APIsType & Yumi.System
local connections = {} :: {}
--yumi
function GUI:_Setup()
    self.Panels = Panels
end

function GUI:_Start()
    Panels.SelectMap:Initialize()


    connections["Open_Select_Map"] = 
        Client.Open_Select_Map.On(function(isEnabled:boolean)
            print("isEnabled",isEnabled)
            Panels.SelectMap._private.enabled.Value = isEnabled
        end)
end
--apis

return GUI
