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

-- native macOS space switching via Ctrl-Left/Right is smoother
--local cm = {'ctrl','cmd'}
---- return a function to change to the prev/next space
--function f_change_s(delta)
    --return function()
        --local space = hs_spaces.activeSpace()
        --local spaces = hs_spaces.query()
        --for k, v in pairs(spaces) do
            --if (space == v and k+delta > 0 and k+delta <= #spaces) then
                --local space_new = spaces[k+delta]
                --hs_spaces.changeToSpace(space_new)
            --end
        --end
    --end
--end
---- change to previous space
--hs.hotkey.bind(cm, 'Left', f_change_s(1))
---- change to next space
--hs.hotkey.bind(cm, 'Right', f_change_s(-1))

