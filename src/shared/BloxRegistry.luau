--!strict

--[[
    BloxRegistry
    a registry of components, it is used to store the components definitions.
    It is used by the Blox library to create reusable components in roblox.


    It has the method "Add" which is used to add a new component to the registry.
]]

local BloxRegistry = {}
BloxRegistry.__index = BloxRegistry

local Templor = require(script.Parent.Templor)
local Propsor = require(script.Parent.Propsor)

