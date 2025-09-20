--services
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
	

		
	-- Inventory = {
	-- 	Weapons = {
	-- 		Owned = {},
	-- 	},
	-- },
}
--type
export type Profile = {

	Version: number,
	Balance: {
		Medals: number,
	},
	
}

local module = {}

module.Template = Template
module.CurrentVersion = CurrentVersion

return module
