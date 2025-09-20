--services
-- local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--modules
----library
--refs

--constants

--type
export type Profile = {

	Version: number,
	Balance: {
		Medals: number,
	},
	
	
}

local CurrentVersion = 2
local Template: Profile = {

	Version = CurrentVersion,
	Balance = {
		Medals = 0,
	},
	
}

local module = {}

module.Template = Template
module.CurrentVersion = CurrentVersion

return module
