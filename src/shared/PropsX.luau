--!strict
--[[
    PropsX

    A library used to manage the attributes of a component.
    With this library, you assign a value to a certain instance, then propsor will automatically
    create a child folder named __props and inside the folder thete are value objects
    with the assigned values.

]]


-- UTILITY FUNCTIONS
--[[
    Functions used only by PropsX, they are not exported to the user.
    ]]

--[[
    It checks if the received instance has a folder named "__props", if it doesn't have it,
    it will create it and return it.
    ]]
function __TryCreatePropsFolder(instance: Instance): Instance
    local propsFolder = instance:FindFirstChild("__props")
    if not propsFolder then
        propsFolder = Instance.new("Folder")
        propsFolder.Name = "__props"
        propsFolder.Parent = instance
    end
    return propsFolder
end


--[[
    Table of value object definitions, it is used to know which data type is equivalent to value object type
    ]]
__ValueObjectDefinitions = {
    ["string"] = "StringValue",
    ["number"] = "NumberValue",
    ["boolean"] = "BoolValue",
    ["Vector3"] = "Vector3Value",
    ["CFrame"] = "CFrameValue",
    ["Color3"] = "Color3Value",
    ["BrickColor"] = "BrickColorValue",
    ["EnumItem"] = "EnumItemValue",
    ["UDim"] = "UDimValue",
    ["UDim2"] = "UDim2Value",
    ["Ray"] = "RayValue",
    ["Faces"] = "FacesValue",
    ["Axes"] = "AxesValue",
    ["PhysicalProperties"] = "PhysicalPropertiesValue",
    ["Rect"] = "RectValue",
    ["Region3"] = "Region3Value",
    ["Region3int16"] = "Region3int16Value",
    ["NumberSequence"] = "NumberSequenceValue",
    ["ColorSequence"] = "ColorSequenceValue",
    ["NumberRange"] = "NumberRangeValue",
    ["Vector2"] = "Vector2Value",
    ["Vector2int16"] = "Vector2int16Value",
    ["Vector3int16"] = "Vector3int16Value",
    ["Instance"] = "ObjectValue",
    ["Content"] = "ContentValue",
}

--[[
    It creates a new value object depending on the type of the value.
    It uses the table of definitions __ValueObjectDefinitions to know which value object to create.
    ]]
function __CreateValueObject(key: string, value: any): Instance
    local valueType = typeof(value)
    local valueObjectDefinition = __ValueObjectDefinitions[valueType]
    if valueObjectDefinition then
        local valueObject = Instance.new(valueObjectDefinition)
        valueObject.Name = key
        valueObject.Value = value
        return valueObject
    else
        error("The type of the value is not supported")
    end
end

-- END UTILITY FUNCTIONS


local PropsX = {}
type PropsX = {
    SetAll: (Instance, table) -> nil,           -- Sets all the values of an instance
    GetAll: (Instance) -> table,                -- Gets all the values of an instance
    Get: (Instance, string) -> table,           -- Gets a specific value from an instance
    Set: (Instance, string, any) -> nil,        -- Sets a specific value from an instance
}


--[[ Sets all the values of an instance

    Invoke "__TryCreatePropsFolder" to try to create the __props folder.

    Then it will iterate through the table of values, and it will create a new value object
    depending on the type of the value. For that it uses the function "__CreateValueObject".
]]
function PropsX.SetAll(instance: Instance, values: table)
    local propsFolder = __TryCreatePropsFolder(instance)
    for key, value in pairs(values) do
        local valueObject = __CreateValueObject(key, value)
        valueObject.Parent = propsFolder
    end
end

--[[ Gets all the values of an instance

    It will iterate through the __props folder and it will get the value of each value object.
    Then it will return a table with the values.
]]
function PropsX.GetAll(instance: Instance): table
    local propsFolder = instance:FindFirstChild("__props")
    if not propsFolder then
        return {}
    end
    local values = {}
    for _, valueObject in pairs(propsFolder:GetChildren()) do
        values[valueObject.Name] = valueObject.Value
    end
    return values
end

--[[ Gets a specific value from an instance

    It will get the value object from the __props folder and it will return the value.
]]
function PropsX.Get(instance: Instance, key: string): any
    local propsFolder = instance:FindFirstChild("__props")
    if not propsFolder then
        return nil
    end
    local valueObject = propsFolder:FindFirstChild(key)
    if not valueObject then
        return nil
    end
    return valueObject.Value
end

--[[ Sets a specific value from an instance

    It will get the value object from the __props folder and it will set the value.
]]
function PropsX.Set(instance: Instance, key: string, value: any)
    local propsFolder = __TryCreatePropsFolder(instance)
    local valueObject = propsFolder:FindFirstChild(key)
    if not valueObject then
        valueObject = __CreateValueObject(key, value)
        valueObject.Parent = propsFolder
    else
        valueObject.Value = value
    end
end


return PropsX