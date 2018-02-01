
--[[ function factory that takes the multipliers of screen width
and height to produce the window's x pos, y pos, width, and height ]]
function baseMove(x, y, w, h)
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        -- add max.x so it stays on the same screen, works with my second screen
        f.x = max.w * x + max.x
        f.y = max.h * y
        f.w = max.w * w
        f.h = max.h * h
        win:setFrame(f, 0)
    end
end

-- disable animations
hs.window.animationDuration(0)
-- feature spectacle/another window sizing apps
hs.hotkey.bind({'alt', 'cmd'}, 'Left', baseMove(0, 0, 0.5, 1))
hs.hotkey.bind({'alt', 'cmd'}, 'Right', baseMove(0.5, 0, 0.5, 1))
hs.hotkey.bind({'alt', 'cmd'}, 'Down', baseMove(0, 0.5, 1, 0.5))
hs.hotkey.bind({'alt', 'cmd'}, 'Up', baseMove(0, 0, 1, 0.5))
--hs.hotkey.bind({'alt', 'cmd'}, '1', baseMove(0, 0, 0.5, 0.5))
--hs.hotkey.bind({'alt', 'cmd'}, '2', baseMove(0.5, 0, 0.5, 0.5))
--hs.hotkey.bind({'alt', 'cmd'}, '3', baseMove(0, 0.5, 0.5, 0.5))
--hs.hotkey.bind({'alt', 'cmd'}, '4', baseMove(0.5, 0.5, 0.5, 0.5))
hs.hotkey.bind({'alt', 'cmd'}, 'F', hs.window.focusedWindow().maximize())
