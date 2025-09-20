--refs

--constants

--type
-- current version
type Profile_Version1 = {
	Version: number,
}
-- new version
type Profile_Version2 = {
	Version: number,
	Balance : {
		Medals: number,
	},
}

local module = {}

module.Resolve = function(dataNeedToResolve: Profile_Version1)
	local data = dataNeedToResolve :: Profile_Version2
	data.Balance = {
		Medals = 0,
	}
	data.Version = 2
end

return module
