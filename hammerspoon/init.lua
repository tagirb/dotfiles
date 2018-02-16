
-- window management {{{

hs_spaces = require("hs._asm.undocumented.spaces")

-- initialize spaces
local spaces = hs_spaces.query()
local space_count = 3

-- create a necessary number of spaces
if #spaces < space_count then
    for i = 1, space_count - #spaces do
        hs_spaces.createSpace()
    end
end
spaces = hs_spaces.query()

-- TODO: initial app layout
---- launch necessary apps
--hs.application.launchOrFocus('iTerm.app')
--hs.application.launchOrFocus('Chrome.app')
--hs.application.launchOrFocus('Slack.app')
--hs.application.launchOrFocus('Mail.app')

--local app = hs.application.find('iTerm.app')
--for win in app:allWindows() do
    --hs_spaces.moveWindowToSpace(win:id(), 16)
--end

-- define hyper keys
local am = {'alt','cmd'}
local cam = {'ctrl','alt','cmd'}

-- disable animations
hs.window.animationDuration = 0

-- return a function moving the window to a new place on the screen
-- x, y -- left upper corner
-- w, h -- width, height
function f_move(x, y, w, h)
    return function()
        local win = hs.window.focusedWindow()
        if win == nil then
            return
        end
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        -- add max.x so it stays on the same screen, works with my second screen
        f.x = max.x + max.w * x
        f.y = max.h * y
        f.w = max.w * w
        f.h = max.h * h
        win:setFrame(f, 0)
    end
end

-- left half
hs.hotkey.bind(am, 'Left', f_move(0, 0, 0.5, 1))
-- right half
hs.hotkey.bind(am, 'Right', f_move(0.5, 0, 0.5, 1))
-- upper half
hs.hotkey.bind(am, 'Down', f_move(0, 0.5, 1, 0.5))
-- bottom half
hs.hotkey.bind(am, 'Up', f_move(0, 0, 1, 0.5))
-- maximize
hs.hotkey.bind(am, 'F', f_move(0, 0, 1, 1))
-- center
hs.hotkey.bind(am, 'C', f_move(0.25, 0, 0.5, 1))

-- return a function to move the focused window to the prev/next space
function f_move_s(delta)
    return function()
        local win = hs.window.focusedWindow()
        if win == nil then
            return
        end
        local space = hs_spaces.activeSpace()
        local spaces = hs_spaces.query()
        for k, v in pairs(spaces) do
            if (space == v and k+delta > 0 and k+delta <= #spaces) then
                local space_new = spaces[k+delta]
                hs_spaces.moveWindowToSpace(win:id(), space_new)
                hs_spaces.changeToSpace(space_new)
                win:focus()
            end
        end
    end
end

-- previous space
hs.hotkey.bind(cam, 'Left', f_move_s(1))
-- next space
hs.hotkey.bind(cam, 'Right', f_move_s(-1))
-- }}}

-- media keys {{{
function f_keypress(key)
    return function()
        hs.eventtap.event.newSystemKeyEvent(key, true):post()
        hs.timer.usleep(10000)
        hs.eventtap.event.newSystemKeyEvent(key, false):post()
    end
end

-- TODO: make f3/f4 arrange windows
--hs.hotkey.bind('', 'f3', )
--hs.hotkey.bind('', 'f4', )
hs.hotkey.bind('{cmd}', 'f5', f_keypress('BRIGHTNESS_DOWN'))
hs.hotkey.bind('{cmd}', 'f6', f_keypress('BRIGHTNESS_UP'))
hs.hotkey.bind('{cmd}', 'f7', f_keypress('PREVIOUS'))
hs.hotkey.bind('{cmd}', 'f8', f_keypress('PLAY'))
hs.hotkey.bind('{cmd}', 'f9', f_keypress('NEXT'))
hs.hotkey.bind('{cmd}', 'f10', f_keypress('MUTE'))
hs.hotkey.bind('{cmd}', 'f11', f_keypress('SOUND_DOWN'))
hs.hotkey.bind('{cmd}', 'f12', f_keypress('SOUND_UP'))
-- }}}
