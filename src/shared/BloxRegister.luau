local CollectionService = game:GetService("CollectionService")
local BloxDefinition = require(script.Parent.Interfaces.BloxDefinition)
local Blox = require(script.Parent.Blox)
local GetBloxCreatedSignal = Instance.new("BindableEvent")
local BloxComponentCreated = Instance.new("BindableEvent")
--[[
    This is the blox register, it should be instanced in a ModuleScript inside either 
    the server or the client, and then it should be used to add the components in it.
]]

type BloxRegister = {
    __components_definitions: {string: BloxDefinition.BloxDefinition<any>},
    __components: {string: any},
    __tags: {string: string},
    __names: {string: string},
    Add: <T>(self: BloxDefinition.BloxDefinition<T>, name: string, definition: BloxDefinition.BloxDefinition<T>) -> ()
}

local BloxRegister = {}
BloxRegister.__index = BloxRegister

function BloxRegister.new(): BloxRegister
    local self = setmetatable({}, BloxRegister)
    self._components_definitions = {}
    self.__components = {}
    self.__tags = {}
    self.__names = {}

    self.CreatedBloxEvent = BloxComponentCreated.Event
    self._get_blox_created_connections = {}
    return self
end


-- returns a new signal for each new tag created
function BloxRegister._GetBloxCreatedSignal(self, tag)
    self._get_blox_created_connections[tag] = self._get_blox_created_connections[tag] or Instance.new("BindableEvent")
    return self._get_blox_created_connections[tag]
end
function BloxRegister.GetBloxCreatedSignal (self, tag)
    return self._GetBloxCreatedSignal(tag).Event
end

--- Adds a new definition to the register
--
-- @param name The name of the component
--
-- @param definition The definition of the component
function BloxRegister._AddDefinition(self, name, definition)
    self._components_definitions[name] = definition
end

--- Creates a new instance of the component, with a template or with the InstanceType
-- if no InstanceType is provided, it will default to a Folder
-- @param definition The definition of the component
-- @param parent The parent of the component
-- @return The instance of the component
function BloxRegister._TryCreateTemplateOrInstance(self, tag, definition, parent)
    local instance = nil
    if definition._template then
        instance = definition._template:Clone()
    else
        instance = Instance.new(definition._constraints.InstanceType or "Folder")
        instance.Name = tag
    end
    CollectionService:AddTag(instance, tag)
    instance.Parent = parent
    return instance
end

    
--Creates a new blox component, adds it to the components table and assigns it as a child to the instance
function BloxRegister.NewBlox(self, name, parent)
    local tag = self._tags[name]
    local definition = self._components_definitions[tag]
    self:_TryCreateTemplateOrInstance(tag, definition, parent)
end

--[[
    Adds a new type of component to the register.
]]
function BloxRegister.Add(self, name, definition)
    local tag_name = "__blox_"..name
    self._tags[name] = tag_name
    self._names[tag_name] = name
    self:_AddDefinition(tag_name, definition)
    self:_OnInstance(tag_name, definition)
end
function BloxRegister.Get(self, instance)
    return self._components[instance]
end

function BloxRegister._CreateBloxComponentAndAddToTable(self, definition, instance)
    local parent = instance.Parent
    local blox = Blox.new(definition, instance, parent)
    self._components[instance] = blox

    return blox
end
    -- handles already created instances with the tag, and also handles newly created instance on runtime
function BloxRegister._OnInstance(self, name, definition)
    -- Gets all the instances with this tag
    local instances = CollectionService:GetTagged(name)

    -- for each instance, it will create a new blox component and add it to the components table
    for _,instance in pairs(instances) do
        self:_CreateBloxComponentAndAddToTable(definition, instance)
    end

    -- this connection is used to automatically connect the newly added instances
    -- to the interface
    CollectionService:GetInstanceAddedSignal(name)
        :Connect(self:_OnInstanceAddedSignalFs(definition,name))
    -- this other connection is for, when an instance is removed, it will automatically
    -- disconnect the connections that were added to the interface
    CollectionService:GetInstanceRemovedSignal(name)
        :Connect(self:_OnInstanceRemovedSignalFs())
end

function BloxRegister._OnInstanceAddedSignalFs(self, definition, name)
    return function(instance)
        local blox = self:_CreateBloxComponentAndAddToTable(definition, instance)
        BloxComponentCreated:Fire(blox)
        self:_GetBloxCreatedSignal(name):Fire(blox)
    end
end

function BloxRegister._OnInstanceRemovedSignalFs(self)
    return function(instance)
        local blox = nil
        repeat task.wait()
            blox = self:Get(instance)
        until blox
        blox:_DisconnectAll()  -- destroys any connection the blox component has
        self._components[instance] = nil     -- removes the blox component from the table, so it can't be accessed in its destroyed state
    end
end

        
return BloxRegister