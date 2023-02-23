--[[
    Blox component for killing players.
    This component is used to kill players, every player with this blox assigned will have
    the component "PlayerKiller" attached to them.

    @author jkf16m
    @version 0.1

    @example
    local humanoid = -- get a player humanoid
    local player_killer = Blox:Get(humanoid:FindFirstChild("PlayerKiller"))
    player_killer:Kill() -- kills the parent player of the "PlayerKiller" component
]]

--[[
    Gets the blox register from the server module "BloxRegister"
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local __blox_components = script.Parent
local server = __blox_components.Parent
local blox_register = require(server.BloxRegister)

blox_register:Add("PlayerKiller", {
    __constraints = {
        ParentType = "Humanoid",
        InstanceType = "Folder",
    },

    __methods = {
        -- Kills the parent player of the "PlayerKiller" component
        Kill = function(self)
            local humanoid = self.Parent
            humanoid.Health = -1
        end
    }
})

-- when a player joins the game, add the "PlayerKiller" component to their humanoid
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        blox_register.NewBlox(blox_register, "PlayerKiller",humanoid)
    end)
end)

blox_register:GetBloxCreatedSignal("PlayerKiller"):Connect(function(component)
    print(component)
    task.wait(5)

    component:Kill()
end)