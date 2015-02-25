ext.grid = {}

ext.grid.MARGINX = 5
ext.grid.MARGINY = 5
ext.grid.GRIDWIDTH = 3

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function ext.grid.get(win)
  local winframe = win:frame()
  local screenrect = win:screen():frame_without_dock_or_menu()
  local thirdscreenwidth = screenrect.w / ext.grid.GRIDWIDTH
  local halfscreenheight = screenrect.h / 2
  return {
    x = round((winframe.x - screenrect.x) / thirdscreenwidth),
    y = round((winframe.y - screenrect.y) / halfscreenheight),
    w = math.max(1, round(winframe.w / thirdscreenwidth)),
    h = math.max(1, round(winframe.h / halfscreenheight)),
  }
end

function ext.grid.set(win, grid, screen)
  local screenrect = screen:frame_without_dock_or_menu()
  local thirdscreenwidth = screenrect.w / ext.grid.GRIDWIDTH
  local halfscreenheight = screenrect.h / 2
  local newframe = {
    x = (grid.x * thirdscreenwidth) + screenrect.x,
    y = (grid.y * halfscreenheight) + screenrect.y,
    w = grid.w * thirdscreenwidth,
    h = grid.h * halfscreenheight,
  }
  win:setframe(newframe)
end

function ext.grid.snap(win)
  if win:isstandard() then
    ext.grid.set(win, ext.grid.get(win), win:screen())
  end
end

function ext.grid.adjustwidth(by)
  ext.grid.GRIDWIDTH = math.max(1, ext.grid.GRIDWIDTH + by)
  hydra.alert("grid is now " .. tostring(ext.grid.GRIDWIDTH) .. " tiles wide", 1)
  fnutils.map(window.visiblewindows(), ext.grid.snap)
end

function ext.grid.adjust_focused_window(fn)
  local win = window.focusedwindow()
  local f = ext.grid.get(win)
  fn(f)
  ext.grid.set(win, f, win:screen())
end

function ext.grid.maximize_window()
  local win = window.focusedwindow()
  local f = {x = 0, y = 0, w = ext.grid.GRIDWIDTH, h = 2}
  ext.grid.set(win, f, win:screen())
end

function ext.grid.center_window()
  local win = window.focusedwindow()
  local f = {x = 0.75, y = 0.25, w = 1.5, h = 1.5}
  ext.grid.set(win, f, win:screen())
end

function ext.grid.pushwindow_nextscreen()
  local win = window.focusedwindow()
  ext.grid.set(win, ext.grid.get(win), win:screen():next())
end

function ext.grid.pushwindow_prevscreen()
  local win = window.focusedwindow()
  ext.grid.set(win, ext.grid.get(win), win:screen():previous())
end

function ext.grid.pushwindow_left()
  ext.grid.adjust_focused_window(function(f) f.x = math.max(f.x - 1, 0) end)
end

function ext.grid.pushwindow_right()
  ext.grid.adjust_focused_window(function(f) f.x = math.min(f.x + 1, ext.grid.GRIDWIDTH - f.w) end)
end

function ext.grid.resizewindow_wider()
  ext.grid.adjust_focused_window(function(f) f.w = math.min(f.w + 1, ext.grid.GRIDWIDTH - f.x) end)
end

function ext.grid.resizewindow_thinner()
  ext.grid.adjust_focused_window(function(f) f.w = math.max(f.w - 1, 1) end)
end

function ext.grid.pushwindow_down()
  ext.grid.adjust_focused_window(function(f) f.y = 1; f.h = 1 end)
end

function ext.grid.pushwindow_up()
  ext.grid.adjust_focused_window(function(f) f.y = 0; f.h = 1 end)
end

function ext.grid.resizewindow_taller()
  ext.grid.adjust_focused_window(function(f) f.y = 0; f.h = 2 end)
end

function ext.grid.left_half()
  local win = window.focusedwindow()
  local f = {x = 0, y = 0, w = ext.grid.GRIDWIDTH / 2, h = 2}
  ext.grid.set(win, f, win:screen())
end

function ext.grid.right_half()
  local half_grid_width = ext.grid.GRIDWIDTH / 2
  local win = window.focusedwindow()
  local f = {x = half_grid_width, y = 0, w = half_grid_width, h = 2}
  ext.grid.set(win, f, win:screen())
end

function ext.grid.top_half()
  local win = window.focusedwindow()
  local f = {x = 0, y = 0, w = ext.grid.GRIDWIDTH, h = 1}
  ext.grid.set(win, f, win:screen())
end

function ext.grid.bottom_half()
  local win = window.focusedwindow()
  local f = {x = 0, y = 1, w = ext.grid.GRIDWIDTH, h = 1}
  ext.grid.set(win, f, win:screen())
end

