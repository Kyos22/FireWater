--!strict
--service
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CollectionService   = game:GetService("CollectionService")
local Players             = game:GetService("Players")
local TweenService        = game:GetService("TweenService")
--refs
local WORLDS = game.Workspace:WaitForChild("Worlds")
--modules
local ZonePlus = require(ReplicatedStorage.Packages.ZonePlus)
local Yumi = require(ReplicatedStorage.Shared.Core.Yumi)
local Server = require(ReplicatedStorage.Shared.Network.Server)
--observers
local PlayerObserver = require(ServerScriptService.Observers.PlayerProfileObserver)
-- interfaces
local PlayerInterface = require(ServerScriptService.Interfaces.PlayerProfile)
-- templates
local ProfileTemplate = require(ServerScriptService.Systems.PlayerProfile.ProfileTemplate)

export type APIsType = {
    waitingMatch: {
        -- [string] : {
        --     [Player] : boolean
        -- }
        [string] : {
            Players: {
                [Player] : boolean
            },
            SelectMap: number 
        }
    },
    tasks : {[string]: thread},

    -- functions
    InitZone: (self: APIsType) -> (),
    Zones: {[Instance]: typeof(ZonePlus.new())},
}

-- Players.CharacterAutoLoads = false

local module = {} :: APIsType & Yumi.System
local connections = {} :: {}


-- apis
module._Setup = function()
    module.waitingMatch = {}
    module.tasks = {}
    module.Zones = {}
end

module._Start = function()

    module:InitZone()


    connections["Player_CheckWorld"] = 
       PlayerObserver.ListenEvent(PlayerObserver.Event.Loaded, function(event: PlayerObserver.LoadedEventArgs)
            if not connections[event.Player] then connections[event.Player] = {} end
            
            local data = event.Data :: ProfileTemplate.Profile
            local player = event.Player :: Player
            if not data then warn("data is nil")
                return
            end
            print("data",data)
            local world = data.CurrentWorld :: number 
            if world and typeof(world) == "number" and world > 0 then
                local worldFolder = WORLDS:FindFirstChild(world)  :: Folder
                local lobby = worldFolder:FindFirstChild("Lobby") :: Folder
                local SpawnLocation = lobby:FindFirstChild("SpawnLocation") :: SpawnLocation
                SpawnLocation.Enabled = true
                print("SpawnLocation",SpawnLocation)

                local character = player.Character or player.CharacterAdded:Wait()
                if not character then
                    return
                end
                character:PivotTo(SpawnLocation.CFrame + Vector3.new(0,5,0))
                
            end

            module:CheckZone(event.Player)

        end)
    
    connections["Player_Removing"] = Players.PlayerRemoving:Connect(function(player:Player)
        module:Destroy(player)
    end)

    connections["API_Select_Map"] =
        Server.Select_Map.SetCallback(function(player:Player, world: number, map: number)
            return module:SelectMap(player,world,map)
        end)

    --init all zone
    -- module:CheckZone()
    module:CreateRoom()

end

module.InitZone = function(self:APIsType)
    local FireZones = CollectionService:GetTagged("FIRE_ZONE")

    self.tasks["InitZone"] = task.spawn(function()
            for _,zone in pairs(FireZones) do
                local zonePlus = ZonePlus.new(zone)
                -- local conn =zonePlus.playerEntered:Connect(function(player:Player)
                --     print("pla",player)
                --     local parentZone = zone.Parent.Name
                --     local str = string.find(parentZone, "Fire")
                --     if str == 1 then -- exist 
                        
                --     end
                -- end) 
                self.Zones[zone] = zonePlus
            end

        
    end)
end

local function GetRoom(zoneInstance,zone) : string
        local zoneIns = zoneInstance.Parent :: Instance
        local zoneNumber = zoneIns.Parent :: Model
        local matchZone = zoneNumber.Parent :: Folder
        local lobby = matchZone.Parent :: Folder
        local world = lobby.Parent :: Folder

        local tierZone = zoneNumber.Name
        local stringCombine = tostring("World".. world.Name .. "_" .. tierZone)
        print("stringCombine",stringCombine)
        return stringCombine
end

module.Teleport = function(self:APIsType, roomName: string)
    if self.waitingMatch[roomName] and #self.waitingMatch[roomName].Players == 2 then
        -- zap handle
        -- Server.
        task.wait(5)
 
    end
end


module.CheckZone = function(self:APIsType,player:Player)
    local zones = self.Zones
    task.spawn(function()
        for zoneInstance,zone in pairs(zones) do
            -- local conn = 
            --     zone.playerEntered:Connect(function(player:Player)
            --         print("touch", player)
            --     end)
            -- table.insert(connections[player],conn)

            connections[player]["TouchZone"] = 
                zone.playerEntered:Connect(function(player:Player)
                    print("touch", player)
                    local room = GetRoom(zoneInstance,zone)
                    if self.waitingMatch[room] then
                        print("count",self.waitingMatch[room])
                        if not next(self.waitingMatch[room].Players) then
                            self.waitingMatch[room].Players[player] = true
                            Server.Open_Select_Map.Fire(player,true)
            
                        elseif #self.waitingMatch[room].Players < 2 then
                            self.waitingMatch[room][player] = true

                            local zoneParent = zoneInstance.Parent :: Instance 
                            -- local Box = zoneParent:FindFirstChild("Box") :: Model
                            -- local PrimaryBox = Box.PrimaryPart :: Part
                            -- TweenService:Create(PrimaryBox,TweenInfo.new(1,Enum.EasingStyle.Linear),{Position = Vector3.new(PrimaryBox.Position.X,16.2,PrimaryBox.Position.Z)}):Play()
                        elseif self.waitingMatch[room].Players and #self.waitingMatch[room].Players == 2 then
                            task.wait(5)
                        end
                    end
                    print("room",self.waitingMatch[room])
                end)
            connections[player]["LeaveZone"] = 
                zone.playerExited:Connect(function(player:Player)
                    print("leave", player)
                    local room = GetRoom(zoneInstance,zone)
                    if self.waitingMatch[room] then
                        if self.waitingMatch[room].Players[player] then
                            self.waitingMatch[room].Players[player] = nil
                        else
                            warn("full not found")
                        end
                    end
                    Server.Open_Select_Map.Fire(player,false)

                    print("room 1",self.waitingMatch[room])
                end)
        end
    end)
end

-- module.WaitingRoom = function(self:APIsType,player:Player)
--     if self.waitingMatch[]
-- end

module.CreateRoom = function(self:APIsType)
    print("room",self.waitingMatch)
    for _,k in pairs(WORLDS:GetChildren()) do
        print("world",k)
        print("world",k.Name)
        local lobby = k:FindFirstChild("Lobby") :: Folder
        print("lobby",lobby)
        local matchZones = lobby:FindFirstChild("MatchZone") :: Folder
        for _,zone in pairs(matchZones:GetChildren()) do
            self.waitingMatch["World".. k.Name .. "_" .. zone.Name ] = {
                Players = {},
                SelectMap = 0
            }
            print("zone",zone)
            print("zone",zone.Name)
        end
    end

    print("room",self.waitingMatch)
end

module.Destroy = function(self:APIsType,player:Player)
    if connections[player] then
        for _, conn in ipairs(connections[player]) do
            if conn then
                conn:Disconnect()
            end
        end
        connections[player] = nil
    end
    print("conn 1",connections)
end 

--yumi

--apis

module.SelectMap = function(self:APIsType,player:Player, world: number, map: number): boolean
    if typeof(world) == "number" and typeof(map) == "number" and world > 0 and map > 0 then
        for roomName,roomData in pairs(module.waitingMatch) do
            -- print("room haha",roomData)
            if roomData.Players[player] then
                self.waitingMatch[tostring(roomName)].SelectMap = map
            end
        end
        print("result",module.waitingMatch)
        return true
    else
        return false
    end
end

return module


-- check vào zone, kiểm tra zone còn lại có người nào join hay không 
-- nếu có 2 người vào thì bắt đầu đếm ngược để teleport 2 thằng này vào một map
-- làm luôn cơ chế mời người chơi ( hiển thị gui )