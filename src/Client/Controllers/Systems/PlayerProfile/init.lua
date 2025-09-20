--!strict
--service
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--refs
--modules
local Yumi = require(ReplicatedStorage.Shared.Core.Yumi)
local ProfileTemplate = require(ReplicatedStorage.Controllers.Systems.PlayerProfile.ProfileTemplate)
----network
local Client = require(ReplicatedStorage.Shared.Network.Client)
----observer
local PlayerProfileObserver = require(ReplicatedStorage.Controllers.Observers.PlayerProfile)
--variable
local profile: ProfileTemplate.Profile = nil
--
export type APIsType = {
	_Start: (self: APIsType) -> (),
	_Setup: (self: APIsType) -> (),

	GetProfile: () -> ProfileTemplate.Profile?,
	RequestProfileDataAsync: () -> ProfileTemplate.Profile,
}

local module = {} :: APIsType & Yumi.System

function module:_Start()
	Client.Player_Update_Profile.On(function(data)
		profile = data :: ProfileTemplate.Profile
		PlayerProfileObserver.CallEvent(
			PlayerProfileObserver.Event.DataUpdated,
			{
				Data = data :: ProfileTemplate.Profile,
			} :: PlayerProfileObserver.DataUpdatedEventArgs
		)
	end)
end

function module:_Setup() end

--yumi

--apis
module.GetProfile = function(): ProfileTemplate.Profile?
	return profile
end

module.RequestProfileDataAsync = function(): ProfileTemplate.Profile
	local data = Client.Get_Player_Data.Call():Await() :: ProfileTemplate.Profile
	profile = data
	return profile
end

return module
