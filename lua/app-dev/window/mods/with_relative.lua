local Window = require('app-dev.window.window')

local WindowWithRelatives = Window:new({
    _position_calculators = {},
    _relatives = {},
    _window = nil,
})

function WindowWithRelatives:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local function invalidate_relatives(self)
    for _, relative in ipairs(self._relatives) do
        local calc_position = self._position_calculators[relative.id]
        relative:set_config(calc_position(self._window:get_config()))
    end
end

function WindowWithRelatives:set_config(config)
    self._window:set_config(config)
    invalidate_relatives(self)
end

function WindowWithRelatives:set_width(width)
    self._window:set_width(width)
    invalidate_relatives(self)
end

function WindowWithRelatives:set_height(height)
    self._window:set_height(height)
    invalidate_relatives(self)
end

function WindowWithRelatives:add_relative(relative_window, position_calculator)
    self._position_calculators[relative_window.id] = position_calculator
    table.insert(self._relatives, relative_window)
    invalidate_relatives(self)
end

local function with_relative(window, relative_window, position_calculator)
    local window_with_relatives = WindowWithRelatives:new({
        _position_calculators = { [relative_window.id] = position_calculator },
        _relatives = {relative_window},
        _window = window,
    })
    invalidate_relatives(window_with_relatives)
    return window_with_relatives
end

return with_relative
