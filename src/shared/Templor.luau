--!strict
--A Template system, to create objects from a template, and then modify them.

--Templor configuration object:
-- It configures how the templor system will rearrange the folders of the project when it starts.
-- In this case, The templates can be declared in both ServerStorage and Workspace.
-- After the game starts, Templor will rearrange the folders, so that the templates are only in ServerStorage.
-- And then you can create the templates from the ServerStorage, using the Register,
-- you can simply call New(template_name) to Clone a template and return it. 
type TemplorConfiguration = {
    Name: string,
    Path: string | {string}
}
local __EXAMPLE_CONFIGURATION = {
    Name = "__example_configuration",
    -- This can be either a string, or a table of strings.
    Path = "Workspace"
    
}

-- and then with the Templor object you simply call
-- you call Templor.Rearrange(configuration)

-- Utility functions
function TableInsertOrError(tabl, value, error_string): ()
    if(value == nil) then error(error_string) end
    table.insert(tabl, value)
end



local ServerStorage = game:GetService("ServerStorage")

--[[
    Get children from of ServerStorage/{path}
]]
function GetChildrenFromPath(path:string,name:string): {Instance}
    local children:{Instance} = {}
    local parent = game:GetService(path):FindFirstChild(name)
    if(parent == nil) then
        error("Invalid path")
    end
    for _, child in pairs(parent:GetChildren()) do
        TableInsertOrError(children, child, "Invalid child")
    end
    return children
end

function GetChildrenFromPaths(paths: {string}, name: string): {Instance}
    local children: {Instance} = {}
    for _, path in pairs(paths) do
        local children_from_path = GetChildrenFromPath(path, name)
        for _, child in pairs(children_from_path) do
            TableInsertOrError(children, child, "Invalid child")
        end
    end
    return children
end

--[[
    1. Check if paths is either a string or string table
    2. If it is a string,
    2.1 then GetChildrenFromPath
    2.2 if it is a string table, then GetChildrenFromPaths
]]
function TryGetChildrenFromPaths(paths: string | {string}, name: string) : {Instance}
    local children:{Instance} = {}
    if(typeof(paths) == "string") then
        children = GetChildrenFromPath(paths, name)
    elseif(typeof(paths) == "table") then
        children = GetChildrenFromPaths(paths, name)
    else
        error("Invalid path type")
    end
    return children
end

--[[
    Moves the children to the ServerStorage/{Name} folder
]]
function MoveChildrenToServerStorage(children: {Instance}, Name: string): ()
    local parent: Instance = ServerStorage:FindFirstChild(Name)
    if(parent == nil) then
        parent = Instance.new("Folder")
        parent.Name = Name
        parent.Parent = ServerStorage
    end
    for _, child in pairs(children) do
        child.Parent = parent
    end
end

function DeleteRemainingFolder(paths: string | {string}, name: string): ()
    if(typeof(paths) == "string") then
        local parent = game:GetService(paths):FindFirstChild(name)
        if(parent ~= nil) then
            parent:Destroy()
        end
    elseif(typeof(paths) == "table") then
        for _, path in pairs(paths) do
            local parent = game:GetService(path):FindFirstChild(name)
            if(parent ~= nil) then
                parent:Destroy()
            end
        end
    else
        error("Invalid path type")
    end
end

local Templor = {}

-- BindableEvent that fires when the rearrangement is done.
Templor.Rearranged = Instance.new("BindableEvent")

--[[
    Rearranges the objects in the game, according to the configuration.
    The configuration must have a Name
    the configuration can have a TemplatePath, which is the path to the templates, they can be
    either a string, or a table of strings.


    The steps to follow would be:

    1. Get the Name.

    2. Get the path or paths of the templates

    3. Get the children from each path

    4. Move the children to the ServerStorage with the folder of {Name} (In case it doesn't exists, create it as a Folder)

    5. Delete the remaining folder from the paths.

]]
function Templor.Rearrange(configuration: TemplorConfiguration): ()
    -- configuration
    local c = configuration
    -- step 1
    local Name = c.Name
    
    -- step 2
    local Path = c.Path

    -- step 3
    local children = TryGetChildrenFromPaths(Path, Name)

    -- step 4
    MoveChildrenToServerStorage(children, Name)

    -- step 5
    DeleteRemainingFolder(Path, Name)


    -- extra step
    -- fires a binding event, so when you need to fire something related to the rearrangement, it is done
    -- after the rearrangement is done.
    Templor.Rearranged:Fire()

end

return Templor