local find = require("utils.find")
local promise = require("utils.promise")
local raycastNotification = require("utils.raycastNotification")
local js = require("utils.js")

local async, await = promise.async, promise.await

local picEdge = {}

-- Main function to set Edge icon using Pictogram
function picEdge.setEdgeIcon_async()
    return async(function()
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
        await(promise.sleep(1.5))

        -- Step 2: Type "Edge" (input should be auto-focused)
        print("⌨️ [PICEDGE] Typing 'Edge'...")
        hs.eventtap.keyStrokes("Edge")

        -- Wait for search to process
        await(promise.sleep(0.5))

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
        await(promise.sleep(0.5))

        -- Step 4: Press Cmd+F to focus search in file dialog
        print("🔍 [PICEDGE] Opening search in file dialog (Cmd+F)...")
        hs.eventtap.keyStroke({ "cmd" }, "f")

        -- Wait for search field to be ready
        await(promise.sleep(0.3))

        -- Step 5: Type "edge" to search for the icon
        print("⌨️ [PICEDGE] Searching for 'edge'...")
        hs.eventtap.keyStrokes("edge")

        -- Wait for search results
        await(promise.sleep(0.8))

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
            js.forEach(actions, function(action)
                print("  - " .. action)
            end)
        end

        edgeIcon:performAction("AXOpen")

        -- Wait before confirming
        await(promise.sleep(1))

        -- Step 7: Press Return to confirm selection
        print("✅ [PICEDGE] Confirming selection with Return...")
        hs.eventtap.keyStroke({}, "return")

        -- Wait for action to complete
        await(promise.sleep(0.5))

        -- Step 8: Quit Pictogram app
        print("🚪 [PICEDGE] Quitting Pictogram app...")
        pictogramApp:kill()

        -- Step 9: Show success notification
        print("🎉 [PICEDGE] Edge icon setup completed successfully!")
        raycastNotification.showHUD("☘️ Edge icon set successfully!")

        return true
    end)
end

-- Export the module
return picEdge
