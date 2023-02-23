local instance = script.parent
local parent = instance.parent
if(not parent:IsA("Humanoid")) then return end
local humanoid = parent


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventTools = require(ReplicatedStorage.Common.EventTools)


EventTools.Connect("KillPlayer", function()
    local SHOULD_KILL_PLAYER= instance:GetAttribute("ShouldKillPlayer")
    if(SHOULD_KILL_PLAYER) then
        humanoid.Health = 0
    end
end)
