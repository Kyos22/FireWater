--!strict
--services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DisplayHelper = require(ReplicatedStorage.Shared.Core.Utils.DisplayHelper)

local SelectMap = require(script.SelectMap)

export type Panels = {
    SelectMap: SelectMap.Type,
}
local selectMapGui = DisplayHelper:CloneSingleton("SelectMap")
local panels = {}

task.spawn(function()
    panels.SelectMap = SelectMap.new(selectMapGui)
    -- panels.Vignette = Vignette.new()
    -- panels.CallIn = CallIn.new(callInGui)
    -- panels.Rank = Rank.new(rankGui)
end)

return panels
