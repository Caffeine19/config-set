local js = require("utils.js")

-- Utility functions for finding accessibility elements
local find = {}


-- Generic function to recursively search for elements by multiple criteria
-- @param element: The root element to search from
-- @param criteria: Table with search criteria (role, title, description, etc.)
function find.element(element, criteria)
    if not element then return nil end

    local role = element:attributeValue("AXRole")
    local title = element:attributeValue("AXTitle") or element:attributeValue("AXLabel")
    local description = element:attributeValue("AXDescription")

    -- Debug output
    if (role and title) or (role and description) then
        print("[FIND] Checking: Role=" .. (role or "nil") ..
            ", Title=" .. (title or "nil") ..
            ", Description=" .. (description or "nil"))
    end

    -- Check if this element matches our criteria
    local matches = true

    -- Check role if specified
    if criteria.role and role ~= criteria.role then
        matches = false
    end

    -- Check title if specified (supports partial matching)
    if criteria.title and title then
        if criteria.exactTitle then
            if title ~= criteria.title then
                matches = false
            end
        else
            if not string.find(title, criteria.title) then
                matches = false
            end
        end
    elseif criteria.title then
        matches = false
    end

    -- Check description if specified (exact match)
    if criteria.description and description ~= criteria.description then
        matches = false
    end

    if matches then
        local foundText = title or description or "unknown"
        print("[FIND] Found target element: " .. foundText)
        return element
    end

    -- Search in children
    local children = element:attributeValue("AXChildren") or {}
    for _, child in ipairs(children) do
        local result = find.element(child, criteria)
        if result then
            return result
        end
    end

    return nil
end

-- Convenience function for finding by role and title (picEdge.lua pattern)
-- @param element: The root element to search from
-- @param targetRole: The AX role to search for
-- @param targetTitle: The title/label to search for (partial match)
function find.byRoleAndTitle(element, targetRole, targetTitle)
    return find.element(element, {
        role = targetRole,
        title = targetTitle,
        exactTitle = false
    })
end

-- Convenience function for finding by description and role (toggleEdgeTabsPane.lua pattern)
-- @param element: The root element to search from
-- @param targetDescription: The exact description to search for
-- @param targetRole: The AX role to search for
function find.byDescriptionAndRole(element, targetDescription, targetRole)
    return find.element(element, {
        role = targetRole,
        description = targetDescription
    })
end

-- Find all elements matching criteria (returns array)
-- @param element: The root element to search from
-- @param criteria: Table with search criteria
function find.allElements(element, criteria)
    if not element then return {} end

    local results = {}

    local role = element:attributeValue("AXRole")
    local title = element:attributeValue("AXTitle") or element:attributeValue("AXLabel")
    local description = element:attributeValue("AXDescription")

    -- Check if this element matches our criteria
    local matches = true

    if criteria.role and role ~= criteria.role then
        matches = false
    end

    if criteria.title and title then
        if criteria.exactTitle then
            if title ~= criteria.title then
                matches = false
            end
        else
            if not string.find(title, criteria.title) then
                matches = false
            end
        end
    elseif criteria.title then
        matches = false
    end

    if criteria.description and description ~= criteria.description then
        matches = false
    end

    if matches then
        table.insert(results, element)
    end

    -- Search in children
    local children = element:attributeValue("AXChildren") or {}
    js.forEach(children, function(child)
        local childResults = find.allElements(child, criteria)
        js.forEach(childResults, function(result)
            table.insert(results, result)
        end)
    end)

    return results
end

return find
