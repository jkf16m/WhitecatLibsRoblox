
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Test = require(ReplicatedStorage.Common.Test)

local test_register = Test.TestRegister.new()

-- first, get all test contexts from the ReplicatedStorage.Common.__tests folder
local test_contexts = {}
for _, test_context in pairs(ReplicatedStorage.Common.__tests:GetChildren()) do
    if test_context:IsA("ModuleScript") then
        table.insert(test_contexts, require(test_context))
    end
end

-- add all the test contexts to the TestRegister
for _, test_context in pairs(test_contexts) do
    test_register:AddTestContext(test_context)
end

-- run all the tests
test_register:RunAllTests()


game.Players.PlayerAdded:Connect(function(player)
    player:Kick("All tests ran successfully!")
end)