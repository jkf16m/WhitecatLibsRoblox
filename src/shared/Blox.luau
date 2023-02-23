local CollectionService = game:GetService("CollectionService")
--[[
    A component system for roblox-lua.

    A Blox is an object created in the roblox editor with a tag assigned.

    The tag is used to identify the Blox component and define its behaviour.

    For example, a Blox component for "KillPlayer" would be:...
    local register = BloxRegister.new() -- here we create a new register
    -- a register is needed because there can be two different registers, for both server and client.
    -- if the register were shared, then the client wouldn't be able to preserve its own state,
    -- because the server would overwrite it.

    -- the first argument is the name of the tag, inside roblox, the tag will register as "__blox__killplayer"
    -- the second argument is a table containing the configuration for the component.
    -- predefined configurations are:
    -- __new: a function that is called when a component is created.
    -- __constraints: a table containing the constraints for the component
    -- ... and any other methods you want to add to the component.
    -- if the "method" added is actually a connection, the register will automatically connect it
    -- to the registered connections table.
    local KillPlayer = register:add("killplayer",{ -- if you assign the returned registered component
        -- you could use the defined methods with it
        __constraints = {}, -- this is a table containing the constraints for the component
        __new = function(self) -- this is called when the component is created, you can access the parent
            -- of the component with self.parent
            self.player = self.parent

            -- you can access the instance of the own component with self.instance
            -- this is useful in case you want to access some specific properties of the component
            -- let's say for example, a position of the component.
            print(self.instance.Position)

            -- every single defined value here, will be mirrored to the own component "instance"
            -- inside the attributes.
        end,
        kill_player = function(self) -- this is a method that will be added to the component
            self.player:kill()
        end,
        -- add a connection:
        when_player_dies = self.player.Died:connect(function()
            print("player "..self.player.Name.." has died!")
        end)
    })

    KillPlayer:kill_player(player) -- this will kill the player, in case you need this




    Inside roblox studio, the hierarchy should look like this:

    Workspace
        - [name of player]
            - Humanoid
                - KillPlayer

    so now, in other places, you can access the component with the tag "killplayer" and use its methods.

    if you need to access this specific interface, you would use "register:get(instance)"
    it will return the "Blox" interface that is attached to the instance, or nil if it doesn't exist.

    for example, let's say you want to kill the player directly using the KillPlayer methods, but you don't
    directly have the reference to the Blox interface, you would do it like this:

    local player = [your player model]
    local kill_player = register:get(player.Humanoid.KillPlayer)
    kill_player:kill_player()



    The patterns I recommend when creating a register with components:
    - Check if the created register should be server-only, client-only or shared
    - For each created component, there should be a created instance with the assigned tag inside
    the workspace in roblox studio.
    - If you create a folder named __blox_components and put all the components-template inside,
    the register will automatically blacklist those specific components to not execute any code
    or declare any connections.
    - Use the __constraints to define for example, which type the parent should be, or also which
    type the component instance itself should be.
]]

local class = require(script.Parent.Class)
local CollectionService = game:GetService("CollectionService")
local TestService = game:GetService("TestService")
local BloxComponentCreated = Instance.new("BindableEvent")

-- Blox component is being used in the file "src/server/__blox_components/PlayerKiller.server.lua" and
-- "src/server/BloxRegister.lua"



--[[
    This is a blox component, a minimal unit of logic that can be attached to a roblox instance.
    The blox component is used to define the behaviour of a certain roblox instance.

    You can also attach connections and they would be disconnected automatically when the component or
    the parent is destroyed.
]]
local Blox = {}
Blox.__index = Blox

function Blox.new(definition, instance, parent)
    local self = setmetatable({}, Blox)
    self.Constraints = definition._constraints or {}
    self.Connections = definition._connections or {}
    self.Instance = instance
    self.Parent = parent

    self.props = definition._props or {}
    -- extracts the defined properties and adds them to the component
    for k,v in pairs(self.props) do
        self[k] = v
    end

    -- extracts the defined methods and adds them to the component
    for k,v in pairs(self:_GetMethods(definition)) do
        self[k] = v
    end

    -- this method goes first, because it will check if the constraints are met
    if(self:_CheckConstraints()) then
        self:_Initialize() -- now we can initialize any connection
    end

    return self
end

--- Initializes the component
function Blox._Initialize(self)
    self:_ConnectAll() -- connect all the connections
end

function Blox._ConnectAll(self)
    for k,v in pairs(self.Connections) do
        v:Connect()
    end
end

function Blox._DisconnectAll(self)
    -- ends all the connections made by the component, but it won't destroy the instance
    for k,v in pairs(self.Connections) do
        v:Disconnect()
    end
end

function Blox.Destroy(self)
    -- destroys the instance of the component, the destruction would be triggered by the register
    self.instance:Destroy()
end

    
function Blox._CheckConstraints(self)
    for k,v in pairs(self.Constraints) do
        if k == "ParentType" then
            if not self.Instance.Parent:IsA(v) then
                -- with warn
                TestService:Warn(false,"The parent of the component "..self.Instance.Name.." is not a "..v)
                return false
            end
        elseif k == "InstanceType" then
            if not self.Instance:IsA(v) then
                -- with warn
                TestService:Warn(false,"The instance of the component "..self.Instance.Name.." is not a "..v)
                return false
            end
        end
    end
    return true
end

--- Gets the methods from the definition
-- @param definition The definition of the blox component
-- @return A table containing the methods
function Blox._GetMethods(self, definition)
    local methods = {}
    for k,v in pairs(definition) do
        if type(v) == "function" then
            methods[k] = v
        end
    end
    return methods
end


return Blox