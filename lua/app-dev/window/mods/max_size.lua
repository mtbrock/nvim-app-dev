local Window = require('app-dev.window.window')

-- Max percentage the width or height can take up.
local MAX_PCT = 0.85

local CenteredWindow = Window:new({
    _window = nil,
    _max_pct = MAX_PCT,
})

function CenteredWindow:set_height(height)
    local max_height = math.floor(self._window:get_parent_size().height * self._max_pct)
    self._window:set_height(math.min(height, max_height))
end

function CenteredWindow:set_width(width)
    local max_width = math.floor(self._window:get_parent_size().width * self._max_pct)
    self._window:set_width(math.min(width, max_width))
end
