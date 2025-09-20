--!strict
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Packages = ReplicatedStorage:WaitForChild("Packages")

local Promise = require(Packages.Promise)
local Signal = require(Packages.Signal)

export type Preloader = {
	__index: Preloader,
	new: () -> Preloader,
	Load: (self: Preloader) -> Promise.Promise,
	Destroy: (self: Preloader) -> (),

	Items: { Instance },
	Loaded: Signal.Signal<Instance>,
}
local Class: Preloader = {} :: Preloader
Class.__index = Class

function Class.new(): Preloader
	local self: Preloader = setmetatable({} :: any, Class)
	self.Loaded = Signal.new()

	local assets = ReplicatedFirst:FindFirstChild("Preload")
	self.Items = assets and assets:GetChildren() or {}

	return self
end

function Class:Load()
	local promise = Promise.new(function(resolve: (...any) -> (), reject: (...any) -> ())
		local startTime = os.clock()
		for _, item in pairs(self.Items) do
			if item:IsA("GuiObject") then
				ContentProvider:PreloadAsync({ item })
			end
			self.Loaded:Fire(item)

			task.wait()
		end
		local deltaTime = os.clock() - startTime

		local playerGui = Player:WaitForChild("PlayerGui")
		for _, item in pairs(self.Items) do
			item.Parent = StarterGui
			local new = item:Clone()

			new.Parent = playerGui
		end

		warn("Preloading took", deltaTime, "seconds to load", #self.Items, "assets.")

		resolve()
	end)

	return promise
end

function Class:Destroy()
	self.Items = {}
	self.Loaded:DisconnectAll()
end

return Class
