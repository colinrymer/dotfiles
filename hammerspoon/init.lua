hs.alert("(Re)loading Hammerspoon configuration", 1)

require 'caffeine'
require 'volume'

-----------------------------------------------
-- Auto Config Reload
-----------------------------------------------
function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.dotfiles/hammerspoon/", reloadConfig):start()

-----------------------------------------------
-- Set up
-----------------------------------------------
local hyper = {"shift", "cmd", "alt", "ctrl"}
--local hyper = {"alt", "ctrl"}

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
-- application hotkeys
-----------------------------------------------
for key, name in pairs({
  -- a = "",
  -- b = "",
  c = "Google Chrome",
  -- d = "",
  e = "Emacs",
  f = "Finder",
  -- g = "",
  -- h = "",
  -- i = "",
  -- j = "",
  k = "Sketch",
  -- l = Used to lock screen
  m = "Messages",
  -- n = "",
  o = "Emacs",
  p = "Spotify",
  -- q = "",
  -- r = "",
  s = "Slack",
  t = "iTerm2",
  -- u = "",
  v = "Postman",
  -- w = "",
  -- x = "",
  -- y = "",
  -- z = "",
}) do
  hs.hotkey.bind(hyper, key, function()
    local app = hs.application.get(name)

    if app and app:isFrontmost() then
      app:hide()
    else
      hs.application.launchOrFocus(name)
    end
  end)
end

hs.hotkey.bind(hyper, "l", function()
  hs.caffeinate.startScreensaver()
end)

-----------------------------------------------
-- Yubikey Wakeup/Sleep
-- wake up for knock when yubikey inserted and lock when yubikey is removed
-----------------------------------------------
function usbDeviceCallback(data)
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
end

local usbWatcher = nil
usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()

hs.alert.show("Config loaded")


-----------------------------------------------
-- Paste Blocking Defeater
-- route around paste blockers by emitting
-- fake keyboard events to type the contents
-- of the clipboard
-----------------------------------------------
hs.hotkey.bind({"cmd", "alt"}, "v", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
