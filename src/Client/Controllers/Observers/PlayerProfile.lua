--!strict
--services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--modules
local Yumi = require(ReplicatedStorage.Shared.Core.Yumi)
local SignalModule = require(ReplicatedStorage.Packages.Signal)
local ProfileTemplate = require(ReplicatedStorage.Controllers.Systems.PlayerProfile.ProfileTemplate)
--type
type Signal = typeof(SignalModule.new())
--constants
local Event = {
	DataUpdated = "DataUpdated",
}
--type
export type DataUpdatedEventArgs = {
	Data: ProfileTemplate.Profile,
}
--variable
local eventCache: {
	[string]: Signal,
} = {}

--
export type Type = {
	Event: typeof(Event),
} & Yumi.Observer
local module: Type = {
	_Setup = function() end,

	Event = Event,
	ListenEvent = function()
		return nil
	end,
	CallEvent = function() end,

	_Extensions = {},
}

do --init
	table.freeze(Event)
	for _, event in pairs(Event) do
		eventCache[event] = SignalModule.new()
	end
end

--yumi
module._Setup = function() end
module.ListenEvent = function(event: string, callback: any)
	if not eventCache[event] or not callback then
		return nil
	end
	if typeof(callback) ~= "function" then
		return nil
	end
	local conn = eventCache[event]:Connect(callback)
	return conn
end
module.CallEvent = function(event: string, args: any, isDefered: boolean?)
	if not eventCache[event] then
		return nil
	end
	if isDefered then
		eventCache[event]:FireDeferred(args)
	else
		eventCache[event]:Fire(args)
	end
end
return module
