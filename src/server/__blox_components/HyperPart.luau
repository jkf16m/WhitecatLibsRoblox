Blox:Add({
    __constraints = {
        InstanceType = "Part",
        Child = {
            __SizeW = {
                InstanceType = "Folder",
                Children = {
                    Parts = {
                        InstanceType = "blox:HyperPartChild"
                    }
                }
            }
        }
    },
    __props ={
        SizeW = 0,
        PositionW = 0,
        RotationW = 0,
        
        -- An hyperpart with a SizeW of 0 would only render its collision in the SizeW == PositionW
        -- An hyperpart with SizeW = 1 would render its collision in the PositionW+(SizeW/2) and
        -- PositionW-(SizeW/2)
        -- A robloxian can only have SizeW = 0, but he can change his PositionW

        -- This current implementation can only change the SizeW and PositionW of the hyperpart, but
        -- not the RotationW

        -- This current implementation supports an array of parts, to represent different states of
        -- the Hyperpart.

        -- For example, an Hyperpart with variable Dimensions, would look like a Cube in SizeW = 0,
        -- but it would be like a rectangle in SizeW = 1

        -- This behaviour is enabled by default, you must put parts in the folder __SizeW,
        -- and the parts must have the property "SizeWRange" with the range of SizeW that the part
        -- can cover
    }
})