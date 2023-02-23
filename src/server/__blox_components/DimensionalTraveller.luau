--[[
    Dimensional Traveller tool.

    This tool enables a Robloxian to travel between different dimensions.

    Currently only supports to modify the robloxian position W.

    To use this tool, you must have it equipped and then you can use the mouse wheel to change
        the position W of the robloxian.

    When a robloxian changes its PositionW, there are a lot of things that will happen in game:
    1- You will stop rendering the parts that are not in the same W position as you.
    (Every part by default has a SizeW of 0 and PositionW of 0), so you can practically fall through
    the world if there is not any HyperPart in the game, and with this tool, you can't
    see if there is any HyperPart in your neaby W position, so use with caution.
    2- You will start rendering the parts that are in the same W position as you.
    You will be able to see them and touch them.
    
    When travelling through coordinate W(+-1), there is a smooth transition between the two coordinates.
    This transition can be configured with the property "TransitionSpeed" of the tool.

    Take for example, an HyperPart that has three diferent sizes, (three different parts in the folder).
    If the three of them are of different X,Y,Z sizes, the robloxian should be able to see
     a part that is constantly changing size, and seemingly flying when it is small.
]]