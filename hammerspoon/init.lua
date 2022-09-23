hs.notify.show("Config", "(Re)loading", "")

-----------------------------------------------
-- Auto Config Reload
-----------------------------------------------
hs.pathwatcher.new(os.getenv("HOME") .. "/.dotfiles/hammerspoon/", hs.reload):start()

-----------------------------------------------
-- Set up
-----------------------------------------------
local hyper = {"shift", "cmd", "alt", "ctrl"}

-----------------------------------------------
-- vim-like window movement
-- cmd+alt+m for fullscreen
-----------------------------------------------
for key, dir in pairs({
  h = "left",
  j = "down",
  k = "up",
  l = "right",
  m = "max",
  c="center"
}) do
  hs.hotkey.bind({"cmd", "alt"}, key, function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = (dir == "right") and (max.x + (max.w / 2)) or (dir == "center" and max.x + (max.w / 8)) or max.x
    f.y = (dir == "down") and (max.y + (max.h / 2)) or (dir == "center" and max.y + (max.h / 8)) or max.y
    f.w = (dir == "left" or dir == "right") and (max.w / 2) or (dir == "center" and (max.w / 1.25)) or max.w
    f.h = (dir == "up" or dir == "down") and (max.h / 2)  or (dir == "center" and (max.h / 1.25)) or max.h
    win:setFrame(f)
  end)
end

-----------------------------------------------
-- vim-like window movement across screens
-----------------------------------------------
for key, dir in pairs({
  h = "left",
  j = "down",
  k = "up",
  l = "right"
}) do
  hs.hotkey.bind({"cmd", "alt", "shift"}, key, function()
    local win = hs.window.focusedWindow()

    if (dir == "left") then
      win:moveOneScreenWest(false, true, 0)
    elseif (dir == "down") then
      win:moveOneScreenSouth(false, true, 0)
    elseif (dir == "up") then
      win:moveOneScreenNorth(false, true, 0)
    elseif (dir == "right") then
      win:moveOneScreenEast(false, true, 0)
    end
  end)
end


-----------------------------------------------
-- application hotkeys
-----------------------------------------------
for key, name in pairs({
  a = {"Active Trader Pro"},
  -- b = {""},
  c = {"Google Chrome"},
  d = {"Discord"},
  e = {"Emacs"},
  f = {"Finder"},
  -- g = {""},
  -- h = {""},
  -- i = {""},
  -- j = {""},
  -- k = {""},
  -- l = Used to lock screen
  m = {"Messages"},
  n = {"Notes"},
  -- o = {""},
  p = {"Spotify"},
  -- q = {""},
  -- r = {""},
  s = {"Slack"},
  t = {"iTerm"},
  u = {"PrusaSlicer"},
  v = {"Visual Studio Code"},
  -- w = {""},
  -- x = {""},,
  -- y = {""},
  z = {"zoom.us"},
}) do
  hs.hotkey.bind(hyper, key, function()
    local app = hs.application.get(name[1])

    if app and app:isFrontmost() then
      app:hide()
    else
      if not hs.application.launchOrFocus(name[1]) then
        hs.application.launchOrFocus(name[2])
      end
    end
  end)
end

hs.hotkey.bind(hyper, "l", function()
  hs.caffeinate.startScreensaver()
end)

hs.hotkey.bind("ctrl", "`", function()
  local app = hs.application.get("iTerm2")

    if app and app:isFrontmost() then
      app:hide()
    else
      if not hs.application.launchOrFocus("iTerm") then
        hs.application.launchOrFocus("iTerm2")
      end
    end
end)

-----------------------------------------------
-- Yubikey Wakeup/Sleep
-- wake up for knock when yubikey inserted and lock when yubikey is removed
-----------------------------------------------
local usbWatcher = nil
usbWatcher = hs.usb.watcher.new(function(data)
    hs.notify.show("USB", "You just connected", data["productName"])
    -- Replace "Yubikey" with the name of the usb device you want to use.
    if string.match(data["productName"], "Yubikey") then
        if (data["eventType"] == "added") then
            hs.notify.show("Yubikey", "You just connected", data["productName"])
            os.execute("caffeinate -u -t 5")
        elseif (data["eventType"] == "removed") then
            -- this locks to screensaver
            os.execute("pmset displaysleepnow")
       end
   end
end)
usbWatcher:start()

-----------------------------------------------
-- Paste Blocking Defeater
-- route around paste blockers by emitting
-- fake keyboard events to type the contents
-- of the clipboard
-----------------------------------------------
hs.hotkey.bind({"cmd", "alt"}, "v", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-----------------------------------------------
-- Caffeine
-----------------------------------------------
caffeine = hs.menubar.new()

function updateCaffeineDisplay(state)
  hs.settings.set("hs-caffeine-state", state)

  if state then
    caffeine:setIcon("caffeine-active.png")
  else
    caffeine:setIcon("caffeine-inactive.png")
  end
end

if caffeine then
  local initialState = hs.settings.get("hs-caffeine-state")

  hs.caffeinate.set("displayIdle", initialState)

  caffeine:setClickCallback(function()
    updateCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
  end)

  updateCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-----------------------------------------------
-- Mute on wifi network change
-----------------------------------------------
local wifiWatcher = nil
local lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
  newSSID = hs.wifi.currentNetwork()

  if newSSID ~= lastSSID then
    hs.audiodevice.defaultOutputDevice():setVolume(0)
  end

  lastSSID = newSSID
end

function removeVolume()
  wifiWatcher:delete()
  wifiWatcher = nil
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

-----------------------------------------------
-- End of Config
-----------------------------------------------
hs.notify.show("Config", "Loaded", "")
