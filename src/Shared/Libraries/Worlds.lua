export type World = {
    Maps: {
        [number]: {
            Name: string,
        }
    }
}

local Worlds = {
    [1] = {
        Name = "World 1",
        Maps = {
            [1] = {
                Name = "Map 1",
                
            },
            [2] = {
                Name = "Map 2",
                
            },
        }
    }
}

return Worlds