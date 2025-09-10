local toggleEdgeTabsPane = {}
local find = require("find")

-- Get the main Edge application element
local function getEdgeAppElement()
    local edge = hs.application.find("Microsoft Edge")
    if not edge then
        print("[ERROR] Microsoft Edge not found")
        return "Microsoft Edge not found"
    end

    local windows = edge:allWindows()
    if #windows == 0 then
        return "No Microsoft Edge windows found"
    end

    local mainWindow = windows[1]
    if not mainWindow then
        return "No main window found"
    end

    -- Focus the Edge window first
    mainWindow:focus()
    -- hs.timer.usleep(200000) -- Wait 200ms for window to focus

    -- Try to find the collapse pane button through accessibility
    local axApp = hs.axuielement.applicationElement(edge)
    if not axApp then
        return "Could not access Edge accessibility elements"
    end
    return axApp
end

local function setMouseCenterOnEdgeWindow()
    local edgeApp = getEdgeAppElement()
    if not edgeApp then
        return "Could not access Edge application element"
    end

    local mainWindow = edgeApp:attributeValue("AXMainWindow")
    if not mainWindow then
        return "No main window found in Edge"
    end

    local frame = mainWindow:attributeValue("AXFrame")
    if not frame then
        return "No frame found for Edge main window"
    end

    local centerX = frame.x + frame.w / 2
    local centerY = frame.y + frame.h / 2

    hs.mouse.setAbsolutePosition({ x = centerX, y = centerY })
end


function toggleEdgeTabsPane.collapse()
    local axApp = getEdgeAppElement()
    if not axApp then
        return "Could not access Edge accessibility elements"
    end

    local collapseButton = find.byDescriptionAndRole(axApp, "Collapse pane", "AXPopUpButton")

    if collapseButton then
        -- Click the button
        local success = collapseButton:performAction("AXPress")
        if success then
            return "Successfully clicked collapse pane button"
        else
            return "Found collapse button but failed to click"
        end
    else
        -- Fallback: try keyboard shortcut (common Edge shortcut is Ctrl+Shift+E or F9)
        hs.eventtap.keyStroke({ "ctrl", "shift" }, "e")
        return "Collapse button not found, tried keyboard shortcut Ctrl+Shift+E"
    end
end

function toggleEdgeTabsPane.pin()
    print("[DEBUG] Attempting to pin pane in Microsoft Edge")

    local axApp = getEdgeAppElement()
    if not axApp then
        return "Could not access Edge accessibility elements"
    end

    -- Step 1: Find and hover over the Tab Actions Menu button
    print("[DEBUG] Looking for Tab Actions Menu button")
    local tabActionsMenu = find.byDescriptionAndRole(axApp, "Tab Actions Menu", "AXPopUpButton")

    if not tabActionsMenu then
        print("[DEBUG] Tab Actions Menu not found")
        return "Tab Actions Menu not found"
    end

    -- Get the position of the Tab Actions Menu button and hover over it
    local position = tabActionsMenu:attributeValue("AXPosition")
    local size = tabActionsMenu:attributeValue("AXSize")

    if not position or not size then
        print("[DEBUG] Could not get position/size of Tab Actions Menu")
        return "Could not determine Tab Actions Menu position"
    end

    local centerX = position.x + size.w / 2
    local centerY = position.y + size.h / 2

    print("[DEBUG] Hovering over Tab Actions Menu at position: " .. centerX .. ", " .. centerY)

    -- Move mouse to starting position
    hs.mouse.absolutePosition({ x = centerX + 50, y = centerY + 50 })
    hs.timer.usleep(100000) -- Wait 100ms

    -- Create mouse move events to simulate real movement
    local startX = centerX - 50
    local startY = centerY - 50
    local steps = 15



    local moveEvent = hs.eventtap.event.newMouseEvent(
        hs.eventtap.event.types.mouseMoved,
        { x = centerX, y = centerY }
    )
    moveEvent:post()


    -- for i = 1, steps do
    --     local progress = i / steps
    --     local currentX = startX + (50 * progress)
    --     local currentY = startY + (50 * progress)

    --     -- Create and post mouse move event
    --     local moveEvent = hs.eventtap.event.newMouseEvent(
    --         hs.eventtap.event.types.mouseMoved,
    --         { x = currentX, y = currentY }
    --     )
    --     moveEvent:post()

    --     hs.timer.usleep(30000) -- Wait 30ms between moves
    -- end

    -- -- Final hover at exact position
    -- hs.mouse.absolutePosition({ x = centerX, y = centerY })

    -- Wait for hover effect to trigger
    hs.timer.usleep(1000000) -- Wait 1 second

    print("[DEBUG] Eventtap movement completed, checking for menu")

    -- Step 2: First try to find Pin pane button directly without menu
    print("[DEBUG] Looking for Pin pane button directly")
    local pinPaneButton = find.byDescriptionAndRole(axApp, "Pin pane", "AXPopUpButton")

    if not pinPaneButton then
        print("[DEBUG] Pin pane button not found in menu")
        return "Pin pane button not found in the Tab Actions Menu"
    end

    print("[DEBUG] Found Pin pane button, clicking it")
    local success = pinPaneButton:performAction("AXPress")
    if success then
        return "Successfully clicked Pin pane button"
    end
    print("[DEBUG] Failed to click Pin pane button")

    setMouseCenterOnEdgeWindow()
end

function toggleEdgeTabsPane.toggle()
    local axApp = getEdgeAppElement()
    if not axApp then
        return "Could not access Edge accessibility elements"
    end

    local collapseButton = find.byDescriptionAndRole(axApp, "Collapse pane", "AXPopUpButton")
    if collapseButton then
        toggleEdgeTabsPane.collapse()
    else
        toggleEdgeTabsPane.pin()
    end
end

return toggleEdgeTabsPane
