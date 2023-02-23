--!strict
--[[
    @file Test.lua
    @description This is a class that is used to test the functionality of some of the classes in the game.
    The main class "Test" is used to store all the tests that are going to be run.
    The method "Add" adds a function to test, this function provides a "self" parameter with all
        the internal test methods, like asserting and the kind.
    @author jkf16m
    @version 0.1
    @date 2023-02-17
]]

-- the class function


local module = {}
local TestService = game:GetService("TestService")

--prints blue text with TestService
function print_blue(text)
    TestService:Message(text)
end
function print_orange(text)
    TestService:Warn(false, text)
end
function print_red(text)
    TestService:Error(text)
end


-- A test example is in the file: "src/shared/__tests/Blox.lua"
type Result = {
    name: string,
    success: boolean,
    message: string,
}
local Result = {}
Result.__index = Result

--[[
    @description This is a class
    that stores the result of a certain assertion.
]]
function Result.new(name:string, success:boolean, message:string) : Result
    local self = {}
    self.name = name
    self.success = success
    self.message = message
    return setmetatable(self, Result)
end

--[[
    @description This class stores all the methods
    that are going to be use to test the functionality.
    The methods are all assertions.
    It also stores the results of those assertions.
]]

export type BooleanAssertion<T> = (self: T, actual:boolean, expected:boolean) -> ()
type TestUtilities = {
    name: string,
    results: {Result},
    Assert: (self: TestUtilities, actual:boolean, expected:boolean) -> (),
    AssertNot: (self: TestUtilities, actual:boolean, expected:boolean) -> (),
    AssertEquals: (self: TestUtilities, actual: any, expected: any) -> (),
    AssertIsTrue: (self: TestUtilities, actual: any) -> (),
    AssertIsFalse: (self: TestUtilities, actual: any) -> (),
    AssertIsNil: (self: TestUtilities, actual: any) -> (),
    AssertIsNotNil: (self: TestUtilities, actual: any) -> (),
    AssertIsType: (self: TestUtilities, actual: any, expected_type: string) -> (),
    AssertIsNotType: (self: TestUtilities, actual: any, expected_type: string) -> (),

}
local TestUtilities = {}
TestUtilities.__index = TestUtilities
function TestUtilities.new(name: string): TestUtilities
    local self:{name: string, results: {}} = {}
    self.results = {}
    self.name = name
    return setmetatable(self, TestUtilities)
end

    -- Asserts that the actual value is equal to the expected value.
    -- the message is predefined by this function.
function TestUtilities:Assert(actual:boolean, expected:boolean)
    local success = actual == expected
    local message = "Expected: " .. tostring(expected) .. " but got: " .. tostring(actual)
    table.insert(self.results, Result.new(self.name, success, message))
end

    -- Asserts that the actual value is not equal to the expected value.
    -- the message is predefined by this function.
function TestUtilities:AssertNot(actual:boolean, expected:boolean)
    local success = actual ~= expected
    local message = "Expected: " .. tostring(expected) .. " but got: " .. tostring(actual)
    table.insert(self.results, Result.new(self.name, success, message))
end

    -- Asserts that the references or values are the same.
function TestUtilities:AssertEquals<T>(actual: T, expected: T)
    local success = actual == expected
    local message = "Expected: " .. tostring(expected) .. " but got: " .. tostring(actual)
    table.insert(self.results, Result.new(self.name, success, message))
end

    -- Asserts that the references or values are not the same.

function TestUtilities:AssertIsTrue(actual)
    local success = actual == true
    local message = "Expected: true but got: " .. tostring(actual)
    table.insert(self.results, Result.new(self.name, success, message))
end

function TestUtilities.AssertIsFalse(self, actual)
    local success = actual == false
    local message = "Expected: false but got: " .. tostring(actual)
    table.insert(self.results, Result.new(self.name, success, message))
end

function TestUtilities.AssertIsNil(self, actual)
    local success = actual == nil
    local message = "Expected: nil but got: " .. tostring(actual)
    table.insert(self.results, Result.new(self.name, success, message))
end

function TestUtilities.AssertIsNotNil(self, actual)
    local success = actual ~= nil
    local message = "Expected: not nil but got: " .. tostring(actual)
    table.insert(self.results, Result.new(self.name, success, message))
end

function TestUtilities.AssertIsType(self, actual, expected_type)
    local success = typeof(actual) == expected_type
    local message = "Expected: " .. expected_type .. " but got: " .. typeof(actual)
    table.insert(self.results, Result.new(self.name, success, message))
end

function TestUtilities.AssertIsNotType(self, actual, expected_type)
    local success = typeof(actual) ~= expected_type
    local message = "Expected: " .. expected_type .. " but got: " .. typeof(actual)
    table.insert(self.results, Result.new(self.name, success, message))
end







type Test = {
    description: string,
    func: (TestUtilities) -> (),
    results: {Result},
}
local Test = {}
Test.__index = Test


function Test.new(description, func): Test
    local self = {}
    self.description = description
    self.func = func
    self.results = {}

    return setmetatable(self, Test)
end


    -- runs the test inside a pcall
function Test:Run(): {Result}
    local success, err = pcall(function()
        local test_utilities = TestUtilities.new(self.description)
        self.func(test_utilities)
        self.results = test_utilities.results
    end)

    if not success then
        local result = Result.new(self.description, false, err)
        self.results = {result}
    end

    return self.results
end




--[[
    @description This class stores all the tests
    that are going to be run.
]]
type TestContext = {
    name: string,
    tests: {Test},
    Add: (self: TestContext, description: string, func: (TestUtilities)->()) -> (),
}
local TestContext = {}
TestContext.__index = TestContext


function TestContext.new(name): TestContext
    local self = {}
    self.name = name
    self.tests = {}

    return setmetatable(self, TestContext)
end




    
-- This adds a test to the TestContext
function TestContext:Add(description: string, func: (TestUtilities)->()) : ()
    local test = Test.new(description, func)
    table.insert(self.tests, test)
end

-- This runs all the tests in the TestContext
function TestContext.RunAllTests(self)
    local results = {}
    for _, test in pairs(self.tests) do
        local test_results = test:Run()
        for _, result in pairs(test_results) do
            table.insert(results, result)
        end
    end

    return results
end






type TestRegister = {
    test_contexts: {TestContext}
}
local TestRegister = {}
TestRegister.__index = TestRegister

function TestRegister.new(): TestRegister
    local self = {}
    self.test_contexts = {}

    return setmetatable(self, TestRegister)
end



function TestRegister.AddTestContext(self, context)
    local test_context = context
    table.insert(self.test_contexts, test_context)
    return test_context
end

--[[
    @description This runs all the tests in all the TestContexts
    and prints the results.
]]
function TestRegister.RunAllTests(self)
    local results = self:_GetAllResults()
    self:_PrintResults(results)
end

--[[
    @description Get all the results from all the tests in all the TestContexts
]]
function TestRegister._GetAllResults(self)
    local results = {}
    for _, test_context in pairs(self.test_contexts) do
        local test_context_results = test_context:RunAllTests()
        for _, result in pairs(test_context_results) do
            table.insert(results, result)
        end
    end

    return results
end

--[[
    @description Prints the results of all the tests.
]]
function TestRegister._PrintResults(self, results)
    local success_count = 0
    local failure_count = 0
    for _, result in pairs(results) do
        if result.success then
            success_count = success_count + 1
        else
            failure_count = failure_count + 1
        end
    end

    print("--------------------")
    print("--------------------")
    print("Test Results:")
    print_blue("Passed: " .. success_count)
    if(failure_count > 0) then
        print_red("Failures: " .. failure_count)
    else
        print_blue("ALL TESTS PASSED!")
    end
    print("--------------------")

    for _, result in pairs(results) do
        if result.success then
            print_blue("Passed: " .. result.name)
        else
            print_red("Failure: " .. result.name)
            print_orange("Message: " .. result.message)
        end
    end
    -- prints line 2 times
    print("--------------------")
    print("--------------------")
end


module.TestContext = TestContext
module.TestRegister = TestRegister

return module