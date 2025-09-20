--refs

--constants

--type
-- current version
type Profile_Version2 = {
	Version: number,
	Balance : {
		Medals: number,
	},
}
-- new version
type Profile_Version3 = {
	Version: number,
	Balance: {
		Medals: number,
	},
    Inventory: {
        Weapons: {
            Owned: {},
        },
    },
}

local module = {}

module.Resolve = function(dataNeedToResolve: Profile_Version2)
	local data = dataNeedToResolve :: Profile_Version3
	data.Balance = {
		Medals = 0,
	}
    data.Inventory = {
        Weapons = {
            Owned = {},
        },
    }
	data.Version = 3
end

return module
