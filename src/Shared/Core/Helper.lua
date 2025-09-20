--// Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--// Constants
local RUN_CONTEXT = if RunService:IsServer() then "Server" else "Client"

--// Module
local Helper = {}

local rng = Random.new()

function Helper:GetRunContext()
    return RUN_CONTEXT
end

function Helper:ApplySpread(direction: Vector3, spread: number, rng: Random): Vector3
    -- Convert degree to radians
    local spreadRadians = math.rad(spread)
    
    local phi = rng:NextNumber() * math.pi * 2
    local cosTheta = 1 - rng:NextNumber() * (1 - math.cos(spreadRadians))
    local sinTheta = math.sqrt(1 - cosTheta * cosTheta)
    
    local x = sinTheta * math.cos(phi)
    local y = sinTheta * math.sin(phi)
    local z = cosTheta
    
    local forward = direction.Unit
    
    local up = math.abs(forward.Y) < 0.9 and Vector3.new(0, 1, 0) or Vector3.new(1, 0, 0)
    local right = forward:Cross(up).Unit
    up = right:Cross(forward).Unit

    local spreadDirection = x * right + y * up + z * forward

    return spreadDirection.Unit
end

function Helper:PlaySoundAtPosition(position: Vector3, soundId: string)
    local attachment = Instance.new("Attachment")
    attachment.Position = position
    attachment.Parent = workspace.Terrain

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://"..soundId
    sound.Volume = 1
    sound.PlaybackSpeed = rng:NextNumber(0.9, 1.1)
    sound.PlayOnRemove = true
    sound.Parent = attachment

    attachment:Destroy()
end

function Helper:FormatMMSS(seconds: number)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", minutes, secs)
end

function Helper:VerifyPlayer(part: BasePart)
    local character = part.Parent
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
        local player = Players:GetPlayerFromCharacter(character)
		return player or humanoid
	end
	return nil
end

return Helper