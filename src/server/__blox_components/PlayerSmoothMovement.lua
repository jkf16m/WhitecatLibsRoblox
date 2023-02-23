--[[
    SmoothMovement Component

    This component is used to move a player smoothly, with a little bit of acceleration.
]]

local __blox_components = script.Parent
local server = __blox_components.Parent
local blox_register = require(server.BloxRegister)

blox_register:Add("PlayerSmoothMovement", {
    _constraints = {
        ParentType = "Humanoid",
        InstanceType = "Folder"
    },
    _props = {
        Speed = 0
    },
    _connections = function(self)
        return {
            self:GetParent().RootPart:GetPropertyChangedSignal("Velocity"):Connect(function()
                self:Move(self.Direction, self.Speed)
            end)
        }
    end,

    -- Moves the parent player of the "PlayerSmoothMovement" component
    Move = function(self, direction, speed)
        local humanoid = self:GetParent()
        local root_part = humanoid.RootPart
        local velocity = direction * speed
        local acceleration = 0.1

        local new_velocity = root_part.Velocity:Lerp(velocity, acceleration)
        root_part.Velocity = new_velocity
    end
})