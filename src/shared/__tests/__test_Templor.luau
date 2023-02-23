--!strict
local Test = require(script.Parent.Parent.Test)
local Templor = require(script.Parent.Parent.Templor)

local C = Test.TestContext.new("Templor") -- create a new test context

C:Add("Create a template with Templor",
function(self)

end)

return C