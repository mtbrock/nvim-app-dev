local Window = require('app-dev.window.window')

-- Max percentage the width or height can take up.
local MAX_PCT = 0.85

local CenteredWindow = Window:new({
    _max_pct = MAX_PCT,
    _window = nil
})

local function get_center_left(width, parent_width)
    return math.floor((parent_width - width) / 2)
end

local function get_center_top(height, parent_height)
    return math.floor(((parent_height - height) / 2) - 1)
end

local function _center_width(window)
    window:set_config({ col = get_center_left(window:get_width(), window:get_parent_size().width) })
end

local function _center_height(window)
    window:set_config({ row = get_center_top(window:get_height(), window:get_parent_size().height) })
end

local function center(window, max_pct)
    _center_width(window)
    _center_height(window)
    return CenteredWindow:new({
        _max_pct = max_pct,
        _window = window,
        id = window.id,
    })
end

function CenteredWindow:set_width(width)
    local max_width = math.floor(self._window:get_parent_size().width * self._max_pct)
    self._window:set_width(math.min(width, max_width))
    _center_width(self._window)
end

function CenteredWindow:set_height(height)
    local max_height = math.floor(self._window:get_parent_size().height * self._max_pct)
    self._window:set_height(math.min(height, max_height))
    _center_height(self._window)
end

return center
