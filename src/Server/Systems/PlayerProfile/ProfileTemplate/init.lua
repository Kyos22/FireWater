--services
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--modules
----library
--refs

--constants
local CurrentVersion = 1
local Template = {

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

local module = {}

module.Template = Template
module.CurrentVersion = CurrentVersion

return module
