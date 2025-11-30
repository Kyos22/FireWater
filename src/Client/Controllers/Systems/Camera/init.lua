--!strict
--// Service
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
--// Modules
local Yumi = require(ReplicatedStorage.Shared.Core.Yumi)
local camera = workspace.CurrentCamera

--
export type APIsType = {}

local module = {} :: APIsType & Yumi.System

module._Setup = function()

end

-- Config (tùy chỉnh dễ dàng)
local offset = Vector3.new(0, 7, -5)  -- Y+7 cao, Z-5 phía trước player
local cameraAngle = CFrame.Angles(math.rad(-105), 0, 0)  -- Nghiêng mạnh -105°
local lerpSpeed = 12  -- Tốc độ follow mượt (10-20)
local introTime = 2.5  -- Thời gian animation intro (giây)

local isFixedCameraEnabled = false
local connection  -- Loop follow

local function MoveCharacter()
    local character = Player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPos = character.HumanoidRootPart.Position

    if character and character:FindFirstChild("HumanoidRootPart") then
        local targetCFrame = Vector3.new(rootPos.X, 0, rootPos.Z)
        -- humanoid:MoveTo(targetCFrame)
        character:MoveTo(targetCFrame)
    end
end

function startFollowLoop()

    if connection then connection:Disconnect() end
    

    connection = RunService.Heartbeat:Connect(function(dt)
        if not isFixedCameraEnabled then return end
        
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            print("co,e")
            local rootPos = character.HumanoidRootPart.Position
             local pos = CFrame.new(rootPos.X, rootPos.Y + 7, rootPos.Z - 5)
            local dir = pos * CFrame.Angles(math.rad(-105),0, 0)
            
            -- Lerp mượt (alpha = speed * dt để ổn định FPS)
            camera.CFrame = camera.CFrame:Lerp(dir, lerpSpeed * dt)
        end
    end)
end

module._Start = function()
    print("come")
    task.wait(3)
    print("come 1")
    

    local camera = workspace.CurrentCamera

    camera.CameraType = Enum.CameraType.Scriptable



    local character = Player.Character


    local rootPos = character.HumanoidRootPart.Position
    local distance = 10
    camera.CameraType = Enum.CameraType.Scriptable
    local pos = CFrame.new(rootPos.X, rootPos.Y + 7, rootPos.Z - 5)
    local dir = pos * CFrame.Angles(math.rad(-105),0, 0)
    local tweenInfo = TweenInfo.new(
        3, 
        Enum.EasingStyle.Quint,  -- Easing mượt (Quint/Quart/Back)
        Enum.EasingDirection.Out
    )
    local tw = TweenService:Create(camera, tweenInfo, {CFrame = dir})
    tw:Play()
    tw.Completed:Connect(function()
        MoveCharacter()
        isFixedCameraEnabled = true

        startFollowLoop()

    end)


    -- RunService.Heartbeat:Connect(function()
    --     if character.HumanoidRootPart then
    --          local character = Player.Character
    --         local rootPos = character.HumanoidRootPart.Position
    --         camera.CameraType = Enum.CameraType.Scriptable
    --         local pos = CFrame.new(rootPos.X, rootPos.Y + 7, rootPos.Z - 5)
    --         local dir = pos * CFrame.Angles(math.rad(-105),0, 0)
    --         camera.CFrame = dir
    --     end
    -- end)
end

-- module.StartFly = function()

-- end
--// Yumi

--// APIs

return module
