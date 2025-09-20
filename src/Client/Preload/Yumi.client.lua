--!strict
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Preloader = require(script.Parent:WaitForChild("Preloader"))

ReplicatedFirst:RemoveDefaultLoadingScreen()

-- Getting assets
local preloader = Preloader.new()

-- Preload the content and time it
local startTime = os.clock()

preloader:Load():Then(function()
	warn("⭕| Preloader loaded!")
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
	local deltaTime = os.clock() - startTime
	warn("Game loaded took", deltaTime, "seconds to load", #preloader.Items, "assets.")

	local Yumi = require(ReplicatedStorage.Shared.Core.Yumi)
	local ControllerFolder = ReplicatedStorage.Controllers
	Yumi:Add("Systems", ControllerFolder.Systems)
	Yumi:Add("Observers", ControllerFolder.Observers)

	Yumi:Start()
		:Then(function()
			warn("⭕| Yumi Client loaded!")
		end)
		:Catch(warn)
		:Await()
end)
