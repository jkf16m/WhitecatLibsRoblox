--[[
    Blox library
    a library used to create reusable components in roblox.

    These components have a main template folder named "__blox_components", it can be
    stored either in the Workspace or in ServerStorage. (using the library Templor).

    Blox will keep a register of all components definitions, so you can bind a certain tag to a roblox object
    to give it some functionality.

    The main reason why this library exists, is to make it easier to create reusable components in roblox,
    packages already fill that purpose, but you can't edit their attributes or manage multiple scripts at once.

    If you want to create a component in roblox, without breaking functionality, you have the option of:

    1. You create a roblox object with a script inside, and you indicate through value objects or a folder outside
    the object, and the script references that "sibling", so now you can edit the script values without
    interfering with the packaging of the component.
    For this approach, I recommend using naming conventions like "ComponentName" and "__Attr_ComponentName" (which
    is a folder) and inside that folder there can be value objects, or simply put attributes in __Attr_ComponentName.

    2. Create a component with blox, it can have whichever values you want, it will use two main libraries to
    manage its "templates" and "attributes". Templor and Propsor.
    Templor manages the templates of the component, so you can easily clone or create new components.
    Propsor manages the attributes of the component, so you can easily change the values of the component.

    The code of the component can be stored either in the ServerScriptService (it can be everywhere you want).
    Or also StarterPlayer/StarterPlayerScripts, depending on what kind of component you want to create (or both).



    Blox components can be either server side, client side or both.
    To manage this, you have to create two different Registries with the Blox library first.
    You go to the ServerScriptService and then you create a new module script with whatever name you want.
        "BloxServer" will suffice.
    Then you can use that module script to return the registry object, and start adding components to it with
    the method "Add".

    You can do the same process for a "BloxClient" registry module script.
]]

--!strict
-- import BloxRegistry from src\shared\BloxRegistry.luau
local BloxRegistry = require(script.Parent.BloxRegistry)

-- main functions of the library, it is used to create a new registry of components.
-- there is no need for a class
type Blox = {
    CreateRegistry: () -> BloxRegistry -- this returns a new registry of components.
}
local Blox: Blox = {}

function Blox.CreateRegistry()
    return BloxRegistry.new()
end

return Blox