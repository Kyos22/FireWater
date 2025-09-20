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
	Unlock: {
		Worlds: {
			[number]: {
				MapsUnlock: {
					[number]: boolean,
				}
			}
		}
	},
	CurrentWorld : number,
	
}

local CurrentVersion = 2
local Template: Profile = {

	Version = CurrentVersion,
	Balance = {
		Medals = 0,
	},
	Unlock = {
		Worlds = {
			[1] = {
				MapsUnlock = {
					[1] = true,
				}
			},
		}
		
	},
	CurrentWorld = 1,
	
}

local module = {}

module.Template = Template
module.CurrentVersion = CurrentVersion

return module
