local module = {}

local ObjectPooling = require(script.Parent.ObjectPooling)

local soundPoolDict = {} :: {[string]: ObjectPooling.Type}
function module.PlaySoundAtPosition(sound: Sound, position: Vector3): (Sound,BasePart)
	local soundPart = Instance.new("Part")
	soundPart.Name = "SoundPart"
	soundPart.Size = Vector3.new(1,1,1)
	soundPart.Position = position
	soundPart.CanCollide = false
	soundPart.CanTouch = false
	soundPart.Anchored = true
	soundPart.Transparency = 1
	soundPart.Position = position
	soundPart.Parent = workspace.Terrain
	if not soundPoolDict[sound.SoundId] then
		soundPoolDict[sound.SoundId] = ObjectPooling.new(sound,5)
	end
	local pool = soundPoolDict[sound.SoundId]
	local soundClone: Sound = pool:Get()
	soundClone.TimePosition = sound.TimePosition
	soundClone.Looped = sound.Looped
	soundClone.SoundGroup = sound.SoundGroup
	soundClone.Volume = sound.Volume
	soundClone.PlaybackSpeed = sound.PlaybackSpeed
	soundClone.PlayOnRemove = sound.PlayOnRemove
	soundClone.RollOffMaxDistance = sound.RollOffMaxDistance
	soundClone.RollOffMinDistance = sound.RollOffMinDistance
	soundClone.Parent = soundPart

	soundClone:Play()
	if not soundClone.Looped then
		task.spawn(function()
			if not soundClone.IsLoaded then
				soundClone.Loaded:Wait()
			end
			task.wait(soundClone.TimeLength)
			soundClone.Parent = nil
			soundPart:Destroy()
			pool:Return(soundClone)
		end)
	end
	return soundClone,soundPart
end

return module