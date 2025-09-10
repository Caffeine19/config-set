local picEdge = {}
local raycastNotification = require("raycastNotification")
local utils = require("utils")
local find = require("find")

-- Main function to set Edge icon using Pictogram
function picEdge.setEdgeIcon()
    print("🚀 [PICEDGE] Starting Edge icon setup...")

    -- Step 1: Launch Pictogram app
    print("📱 [PICEDGE] Launching Pictogram app...")
    local pictogramApp = hs.application.open("Pictogram")

    if not pictogramApp then
        print("❌ [PICEDGE] Failed to launch Pictogram app")
        raycastNotification.showHUD("❌ Failed to launch Pictogram")
        return false
    end

    -- Wait for app to fully load
    print("⏰ [PICEDGE] Waiting for app to load...")
    hs.timer.usleep(1500000) -- Wait 1.5 seconds

    -- Step 2: Type "Edge" (input should be auto-focused)
    print("⌨️ [PICEDGE] Typing 'Edge'...")
    hs.eventtap.keyStrokes("Edge")

    -- Wait for search to process
    hs.timer.usleep(500000) -- Wait 0.5 seconds

    -- Step 3: Find and click "Select Custom Icon" button
    print("🔍 [PICEDGE] Looking for 'Select Custom Icon' button...")

    local axApp = hs.axuielement.applicationElement(pictogramApp)
    if not axApp then
        print("❌ [PICEDGE] Cannot access Pictogram UI elements")
        raycastNotification.showHUD("❌ Cannot access Pictogram UI")
        return false
    end

    local customIconButton = find.byRoleAndTitle(axApp, "AXButton", "Select Custom Icon")

    if not customIconButton then
        print("❌ [PICEDGE] Custom Icon button not found")
        raycastNotification.showHUD("❌ Custom Icon button not found")
        return false
    end

    -- Click the button
    print("🔘 [PICEDGE] Clicking 'Select Custom Icon' button...")
    local success = customIconButton:performAction("AXPress")

    if not success then
        print("❌ [PICEDGE] Failed to click Custom Icon button")
        raycastNotification.showHUD("❌ Failed to click button")
        return false
    end

    -- Wait for file dialog to open
    hs.timer.usleep(1000000) -- Wait 1 second

    -- Step 4: Press Cmd+F to focus search in file dialog
    print("🔍 [PICEDGE] Opening search in file dialog (Cmd+F)...")
    hs.eventtap.keyStroke({ "cmd" }, "f")

    -- Wait for search field to be ready
    hs.timer.usleep(300000) -- Wait 0.3 seconds

    -- Step 5: Type "edge" to search for the icon
    print("⌨️ [PICEDGE] Searching for 'edge'...")
    hs.eventtap.keyStrokes("edge")

    -- Wait for search results
    hs.timer.usleep(800000) -- Wait 0.8 seconds

    -- Step 6: Find and click MicrosoftEdge.icns image
    print("🖼️ [PICEDGE] Looking for MicrosoftEdge.icns image...")

    local edgeIcon = find.byRoleAndTitle(axApp, "AXImage", "MicrosoftEdge.icns")

    if not edgeIcon then
        print("❌ [PICEDGE] MicrosoftEdge.icns image not found")
        raycastNotification.showHUD("❌ Edge icon not found")
        return false
    end

    -- Click the image
    print("🖱️ [PICEDGE] Clicking MicrosoftEdge.icns...")
    
    -- Debug: Check available actions and properties
    local actions = edgeIcon:actionNames()
    if actions then
        print("🔍 [PICEDGE] Available actions:")
        utils.forEach(actions, function(action)
            print("  - " .. action)
        end)
    end
    
    edgeIcon:performAction("AXOpen")

    -- Wait before confirming
    hs.timer.usleep(3000000) -- Wait 0.3 seconds

    -- Step 7: Press Return to confirm selection
    print("✅ [PICEDGE] Confirming selection with Return...")
    hs.eventtap.keyStroke({}, "return")

    -- Wait for action to complete
    hs.timer.usleep(1000000) -- Wait 1 second

    -- Step 8: Quit Pictogram app
    print("🚪 [PICEDGE] Quitting Pictogram app...")
    pictogramApp:kill()

    -- Step 9: Show success notification
    print("🎉 [PICEDGE] Edge icon setup completed successfully!")
    raycastNotification.showHUD("☘️ Edge icon set successfully!")

    return true
end

-- Export the module
return picEdge
