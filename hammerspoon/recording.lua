require('hammerspoon.window-functions')
checkInterval = 1800  -- Time between dialogs
dialogTimeout = 300  -- Time to wait for response

-- for testing
-- checkInterval = 10  -- Time between dialogs
-- dialogTimeout = 10  -- Time to wait for response

hyperWaitTime = 0.5
dialogTimer = nil
checkTimer = nil


function recordScreenWithCleanshot()
    
    -- Start recording
    hs.timer.doAfter(hyperWaitTime, function()
        hs.eventtap.keyStroke({"cmd", "shift"}, "6", 0)
        hs.timer.doAfter(.5, function()
            hs.eventtap.keyStroke({}, "return", 0)
        end)
    end)

    local function showContinueDialog()
        -- Clear any existing timer
        if dialogTimer then
            dialogTimer:stop()
        end

        -- Set up timeout timer
        dialogTimer = hs.timer.doAfter(dialogTimeout, function()
            endRecording()
        end)

        local max = getMaxFrame()
        -- Show the dialog
        print ("showing dialog")
        hs.dialog.alert(max.w-200, max.h-200, function(result)
            -- If no dialogTimer exists, then we already called endRecording
            if dialogTimer:running() then
                dialogTimer:stop()
                if result == "Continue" then
                  -- Schedule next dialog
                    hs.timer.doAfter(checkInterval, showContinueDialog)
                else
                  endRecording()
                end
            end

        end, "Recording in Progress", "Do you want to continue recording?", "Continue", "Stop")
    end

    -- Show first dialog after initial interval
    checkTimer = hs.timer.doAfter(checkInterval, showContinueDialog)
end


function endRecording()
    hs.timer.doAfter(hyperWaitTime, function()
        hs.eventtap.keyStroke({"cmd", "shift"}, "6", 0)
        if dialogTimer then
            dialogTimer:stop()
        end
        if checkTimer then
            checkTimer:stop()
        end
        
        -- Wait a moment for the recording to finish saving, then run the script
        hs.timer.doAfter(1, function()
            local task = hs.task.new("/bin/zsh", function(exitCode, stdOut, stdErr)
                if exitCode == 0 then
                    print("Async script finished")
                else
                    print("Async script failed: " .. tostring(stdErr))
                end
            end, {"/Users/sjurgemeyer/projects/dotfiles/createAudioFile.sh"})
            
            task:start()
        end)
    end)
end
-- Bind to a hotkey (optional)
hs.hotkey.bind(hyper, "7", recordScreenWithCleanshot)
hs.hotkey.bind(hyper, "8", endRecording)

