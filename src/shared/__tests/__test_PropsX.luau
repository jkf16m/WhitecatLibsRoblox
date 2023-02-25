--!strict
--[[
    Tests for PropsX
]]


local Test = require(script.Parent.Parent.Test)
local PropsX = require(script.Parent.Parent.PropsX)


local C = Test.TestContext.new("PropsX") -- create a new test context

C:Add("Add property to instance", function(self)
    local instance = Instance.new("Folder")

    local props = {
        ["Name"] = "Test",
        ["Value"] = 10,
    }

    PropsX.SetAll(instance, props)
    local values = PropsX.GetAll(instance)

    self:Assert(values["Name"], "Test")
    self:Assert(values["Value"], 10)
end)

return C