-- when a player joins, add the "PlayerKiller" component to their humanoid
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Component = require(ReplicatedStorage.Common.Component)
local Templor = require(ReplicatedStorage.Common.Templor)
local ServerStorage = game:GetService("ServerStorage")
local PLAYER_KILLER = ServerStorage.Components.PlayerKiller




-- For Templor system
local __BLOX_CONFIGURATION = {
    Name = "__blox_components",
    Path = "Workspace"
}

Templor.Rearrange(__BLOX_CONFIGURATION)