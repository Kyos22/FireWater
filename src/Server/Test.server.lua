-- local folder = workspace.Terrain:WaitForChild("Folder")
-- local topright = folder.TopRight.Position
-- local bottomleft = folder.BottomLeft.Position
-- local height = folder.Height.Position

-- local Visualize = require(game.ReplicatedStorage.Shared.Core.Utils.Visualize)

-- local readVolume = Vector3.new(104,104,104)

-- local xCount = math.floor(math.abs(topright.X - bottomleft.X)/readVolume.X)+1
-- local yCount = math.floor(math.abs(height.Y - topright.Y)/readVolume.Y)+1
-- local zCount = math.floor(math.abs(topright.Z - bottomleft.Z)/readVolume.Z)+1
-- local origin = bottomleft
-- local signVector = Vector3.new(math.sign(topright.X - bottomleft.X),1,math.sign(topright.Z - bottomleft.Z))

-- local offset = Vector3.new(-2000,0,0)
-- print(`x: {xCount}, y: {yCount}, z: {zCount}`)
-- for x=1,xCount,1 do
--     for z=1,zCount,1 do
--         for y=1,yCount,1 do
--             task.spawn(function()
--                 local min = Vector3.new((x-1)*readVolume.X*signVector.X,(y-1)*readVolume.Y*signVector.Y,(z-1)*readVolume.Z*signVector.Z) 
--                 local max = Vector3.new(x*readVolume.X*signVector.X,y*readVolume.Y*signVector.Y,z*readVolume.Z*signVector.Z)
--                 min += origin
--                 max += origin
--                 local region = Region3.new(min, max):ExpandToGrid(4)
--                 Visualize.Region3(region,100)
--                 Visualize.Position(min, BrickColor.Blue().Color, 100)
--                 Visualize.Position(max, BrickColor.Red().Color, 100)
                
--                 local data  = workspace.Terrain:ReadVoxelChannels(region, 4, {"SolidMaterial", "SolidOccupancy", "LiquidOccupancy"})
--                 print(data)
--                 min += offset
--                 max += offset
--                 region = Region3.new(min, max):ExpandToGrid(4)
--                 workspace.Terrain:WriteVoxelChannels(region, 4, data)
--             end)
            
--             task.wait(0.1)
--         end
--     end
-- end
