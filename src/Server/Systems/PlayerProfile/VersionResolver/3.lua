local ServerScriptService = game:GetService("ServerScriptService")

local Class = require(ServerScriptService.Systems.Class)
--refs

--constants

--type
-- current version
type Profile_Version3 = {
	Version: number,
	Balance: {
		Medals: number,
	},
}
-- new version
type Profile_Version4 = {
	Version: number,
	Balance: {
		Medals: number,
	},
	Inventory: {
		Classes: {
			Rifleman: {
				Owned: {},
			},
			Engineer : {
				Owned: {},
			},
			Recon : {
				Owned: {},
			},
			Medic : {
				Owned: {},
			},
			MechineGunner : {
				Owned: {},
			},
			RadioMan : {
				Owned: {},
			}, 
			Artillery : {
				Owned: {},
			},
			Commander : {
				Owned: {},
			},
		}
	},
}

local module = {}

module.Resolve = function(dataNeedToResolve: Profile_Version3)
	local data = dataNeedToResolve :: Profile_Version4
	data.Balance = {
		Medals = 0,
	}
	data.Inventory = {
		Classes = {
            Rifleman = {
                Owned = {},
            },
            Engineer = {
                Owned = {},
            },
            Recon = {
                Owned = {},
            },
            Medic = {
                Owned = {},
            } ,
            MechineGunner = {
                Owned = {},
            },
            RadioMan = {
                Owned = {},
            }, 
            Artillery = {
                Owned = {},
            },
            Commander = {
                Owned = {},
            },
        },
	}
	data.Version = 4
end

return module
