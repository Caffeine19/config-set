local find = require("utils.find")
local promise = require("utils.promise")
local raycastNotification = require("utils.raycastNotification")
local js = require("utils.js")
local log = require("utils.log")

local async, await = promise.async, promise.await

-- Create a scoped logger for this module
local logger = log.createLogger("PICEDGE")

local picEdge = {}

-- Main function to set Edge icon using Pictogram
function picEdge.setEdgeIcon_async()
    return async(function()
        logger.start("Starting Edge icon setup...")

        -- Step 1: Launch Pictogram app
        logger.launch("Launching Pictogram app...")
        local pictogramApp = hs.application.open("Pictogram")

        if not pictogramApp then
            logger.error("Failed to launch Pictogram app")
            raycastNotification.showHUD("❌ Failed to launch Pictogram")
            return false
        end

        -- Wait for app to fully load
        logger.wait("Waiting for app to load...")
        await(promise.sleep(1.5))

        -- Step 2: Type "Edge" (input should be auto-focused)
        logger.type("Typing 'Edge'...")
        hs.eventtap.keyStrokes("Edge")

        -- Wait for search to process
        await(promise.sleep(0.5))

        -- Step 3: Find and click "Select Custom Icon" button
        logger.search("Looking for 'Select Custom Icon' button...")

        local axApp = hs.axuielement.applicationElement(pictogramApp)
        if not axApp then
            logger.error("Cannot access Pictogram UI elements")
            raycastNotification.showHUD("❌ Cannot access Pictogram UI")
            return false
        end

        local customIconButton = find.byRoleAndTitle(axApp, "AXButton", "Select Custom Icon")

        if not customIconButton then
            logger.error("Custom Icon button not found")
            raycastNotification.showHUD("❌ Custom Icon button not found")
            return false
        end

        -- Click the button
        logger.button("Clicking 'Select Custom Icon' button...")
        local success = customIconButton:performAction("AXPress")

        if not success then
            logger.error("Failed to click Custom Icon button")
            raycastNotification.showHUD("❌ Failed to click button")
            return false
        end

        -- Wait for file dialog to open
        await(promise.sleep(0.5))

        -- Step 4: Press Cmd+F to focus search in file dialog
        logger.search("Opening search in file dialog (Cmd+F)...")
        hs.eventtap.keyStroke({ "cmd" }, "f")

        -- Wait for search field to be ready
        await(promise.sleep(0.3))

        -- Step 5: Type "edge" to search for the icon
        logger.type("Searching for 'edge'...")
        hs.eventtap.keyStrokes("edge")

        -- Wait for search results
        await(promise.sleep(0.8))

        -- Step 6: Find and click MicrosoftEdge.icns image
        logger.image("Looking for MicrosoftEdge.icns image...")

        local edgeIcon = find.byRoleAndTitle(axApp, "AXImage", "MicrosoftEdge.icns")

        if not edgeIcon then
            logger.error("MicrosoftEdge.icns image not found")
            raycastNotification.showHUD("❌ Edge icon not found")
            return false
        end

        -- Click the image
        logger.click("Clicking MicrosoftEdge.icns...")

        -- Debug: Check available actions and properties
        local actions = edgeIcon:actionNames()
        if actions then
            logger.search("Available actions:")
            js.forEach(actions, function(action)
                logger.debug("  -", action)
            end)
        end

        edgeIcon:performAction("AXOpen")

        -- Wait before confirming
        await(promise.sleep(1))

        -- Step 7: Press Return to confirm selection
        logger.success("Confirming selection with Return...")
        hs.eventtap.keyStroke({}, "return")

        -- Wait for action to complete
        await(promise.sleep(0.5))

        -- Step 8: Quit Pictogram app
        logger.quit("Quitting Pictogram app...")
        pictogramApp:kill()

        -- Step 9: Show success notification
        logger.celebrate("Edge icon setup completed successfully!")
        raycastNotification.showHUD("☘️ Edge icon set successfully!")

        return true
    end)
end

-- Export the module
return picEdge
