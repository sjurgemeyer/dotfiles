-- recordingInProgress = false
-- hyperWaitTime = 0.5
-- 
-- function startRecording()
--     if recordingInProgress then return end
--     recordingInProgress = true
--     hs.timer.doAfter(hyperWaitTime, function()
--         hs.eventtap.keyStroke({ "cmd", "shift" }, "6", 0)
--         hs.timer.doAfter(0.5, function()
--             hs.eventtap.keyStroke({}, "return", 0)
--         end)
--     end)
-- end
-- 
-- function endRecording()
--     if not recordingInProgress then return end
--     hs.timer.doAfter(hyperWaitTime, function()
--         hs.eventtap.keyStroke({ "cmd", "shift" }, "6", 0)
--         hs.timer.doAfter(1, function()
--             local task = hs.task.new("/bin/zsh", function(exitCode, _, stdErr)
--                 if exitCode == 0 then
--                     print("Creating Audio File")
--                 else
--                     print("Creating Audio File failed: " .. tostring(stdErr))
--                 end
--             end, { "/Users/sjurgemeyer/projects/dotfiles/createAudioFile.sh" })
--             recordingInProgress = false
--             task:start()
--         end)
--     end)
-- end

-- Previous dialog-based flow, kept for reference. Replaced by Teams meeting-watcher auto-trigger.
--[[
checkInterval = 1800  -- Time between dialogs
dialogTimeout = 300  -- Time to wait for response

-- for testing
--checkInterval = 5  -- Time between dialogs
--dialogTimeout = 5  -- Time to wait for response

dialogTimer = nil
checkTimer = nil
recordingWarning = require('hammerspoon.recording-warning').new("Recording in progress: hyper+8 to end  hyper+9 to continue")

function recordScreenWithCleanshot()

    if recordingInProgress then
        print "timer already running"
    else
       recordingInProgress = true
        -- Start recording
        hs.timer.doAfter(hyperWaitTime, function()
            hs.eventtap.keyStroke({ "cmd", "shift" }, "6", 0)
            hs.timer.doAfter(.5, function()
                hs.eventtap.keyStroke({}, "return", 0)
            end)
        end)

        -- Show first dialog after initial interval
        checkTimer = hs.timer.doAfter(checkInterval, showContinueDialog)
    end
end

function showContinueDialog()
    -- Clear any existing timer
    recordingWarning:show()
    stopTimers()

    -- Set up timeout timer
    dialogTimer = hs.timer.doAfter(dialogTimeout, function()
        endRecording()
    end)

    print("Prompting user to end recording")
end

function continueRecording()
    recordingWarning:hide()
    stopTimers()
    if recordingInProgress then
        print("Continue Recording")
        checkTimer = hs.timer.doAfter(checkInterval, showContinueDialog)
    else
        print("Recording already ended")
    end
end

function stopTimers()
    if dialogTimer then
        dialogTimer:stop()
    end
    if checkTimer then
        checkTimer:stop()
    end
end

function endRecording()
    recordingWarning:hide()
    if recordingInProgress then
        print("End recording")
        hs.timer.doAfter(hyperWaitTime, function()
            hs.eventtap.keyStroke({ "cmd", "shift" }, "6", 0)
            stopTimers()
            -- Wait a moment for the recording to finish saving, then run the script
            hs.timer.doAfter(1, function()
                local task = hs.task.new("/bin/zsh", function(exitCode, stdOut, stdErr)
                    if exitCode == 0 then
                        print("Creating Audio File")
                    else
                        print("Creating Audio File failed: " .. tostring(stdErr))
                    end
                end, { "/Users/sjurgemeyer/projects/dotfiles/createAudioFile.sh" })

                recordingInProgress = false

                task:start()
            end)
        end)
    else
        print("No recording in progress")
    end
end


hs.hotkey.bind(hyper, "7", recordScreenWithCleanshot)
-- TODO, make these shortcuts only work in recording mode
hs.hotkey.bind(hyper, "8", endRecording)
hs.hotkey.bind(hyper, "9", continueRecording)
]]
