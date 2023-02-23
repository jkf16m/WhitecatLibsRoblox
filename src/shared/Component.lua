local module = {}

function module.Add(parent, child)
    -- Adds a child to the parent
    child.Parent = parent
end

return module