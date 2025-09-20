--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

--// References
local Assets = ReplicatedStorage.Assets
local BulletHoleTemplate = Assets.Visual:WaitForChild("BulletHole")

--// Constants
local BULLET_HOLE_LIFETIME = 3

--// System
local module = {}

function module.Position(pos: Vector3, color: Color3, lifeTime: number, collisionGroup: string?)
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.CanTouch = false
	p.Transparency = 0.7
	p.Size = Vector3.new(1, 1, 1)
	p.CFrame = CFrame.new(pos)
	p.CastShadow = false
	p.Name = "PositionVisualizer"
	p.Color = color
	p.CollisionGroup = collisionGroup or "Default"
	p.Parent = workspace.Terrain
	Debris:AddItem(p, lifeTime)
end
function module.Space(
	cframe: CFrame,
	size: Vector3,
	name: string,
	color: Color3,
	lifeTime: number,
	collisionGroup: string?
)
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.CanTouch = false
	p.Transparency = 0.7
	p.Size = size
	p.CFrame = cframe
	p.CastShadow = false
	p.Name = "SpaceVisualizer"
	p.Color = color
	p.CollisionGroup = collisionGroup or "Default"
	p.Parent = workspace.Terrain
	Debris:AddItem(p, lifeTime)
end
function module.Region3(region: Region3, lifeTime: number, collisionGroup: string?)
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.CanTouch = false
	p.Transparency = 0.7
	p.Size = region.Size
	p.CFrame = region.CFrame
	p.CastShadow = false
	p.Name = "Region3Visualizer"
	p.CollisionGroup = collisionGroup or "Default"
	p.Parent = workspace.Terrain
	Debris:AddItem(p, lifeTime)
end
function module.Line(
	startPos: Vector3,
	endPos: Vector3,
	thickNess: number,
	color: Color3,
	lifeTime: number,
	collisionGroup: string?
)
	local center = (startPos + endPos) / 2
	local size = (startPos - endPos).Magnitude
	local part = Instance.new("Part")
	part.CFrame = CFrame.lookAt(center, endPos)
	part.Size = Vector3.new(thickNess, thickNess, size)
	part.Material = Enum.Material.Neon
	part.Color = color
	part.Name = "LineVisualizer"
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CollisionGroup = collisionGroup or "Default"
	part.CastShadow = false
	part.Transparency = 0.7
	part.Parent = workspace.Terrain
	Debris:AddItem(part, lifeTime)
end
function module.BulletHole(
	position: Vector3,
	normal: Vector3,
	isBlood: boolean
)
	local bulletHole = BulletHoleTemplate:Clone()
	bulletHole.CFrame = CFrame.new(position, position + normal) * CFrame.Angles(0, 0, math.rad(math.random(0, 360)))
	
	if isBlood then
		bulletHole.Decal:Destroy()
		bulletHole.BloodEmitter:Emit(5)
	else
		bulletHole.SmokeEmitter:Emit(8)
	end

	bulletHole.Parent = workspace.Visuals
	Debris:AddItem(bulletHole, BULLET_HOLE_LIFETIME)
end

return module
