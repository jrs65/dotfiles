local hotkey = require "hs.hotkey"
local hints = require "hs.hints"
local grid = require "hs.grid"

local hyper = {'Ctrl', 'Cmd', 'Alt'}

hs.hotkey.bind(hyper, 'j', function()
    local lgrid = grid.setGrid('2x2').setMargins({8, 8})
    lgrid.show() 
end)

hs.hotkey.bind(hyper, 'k', function()
    local lgrid = grid.setGrid('3x2').setMargins({8, 8})
    lgrid.show() 
end)

hs.hotkey.bind(hyper, 'h', function()
    hs.hints.hintChars = {'f', 'j', 'd', 'k', 's', 'l', 'a', ';'}
    hs.hints.windowHints()
end)

