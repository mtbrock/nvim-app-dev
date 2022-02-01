local Buffer = require('app-dev.buffer')

DEFAULT_OPTIONS = {
    buftype = 'nofile',
    swapfile = false,
    bufhidden = 'wipe',
    filetype = 'nvimplugins',
}

DEFAULT_COMMANDS = {
    'setlocal nowrap',
}

local Window = {
    id = nil,
    on_size_change = function() end
}

function Window:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Window.get_default_float_config(...)
    local border = {'┏', '━', '┓', '┃', '┛', '━', '┗', '┃'}
    local float_config = {
        anchor = 'NW',
        relative = 'editor',
        style = 'minimal',
        width = math.floor(.85 * vim.o.columns),
        height = math.floor(.85 * vim.o.lines),
        col = 0,
        row = 0,
        border = border,
    }
    for _, config in ipairs({...}) do
        float_config = vim.tbl_extend('keep', config, float_config)
    end
    return float_config
end

function Window.open(buffer_id, enter, config)
    config = Window.get_default_float_config(config)
    return Window:new({
        id = vim.api.nvim_open_win(buffer_id, enter, config)
    })
end

function Window:conf(key)
    return self:get_config()[key]
end

function Window:get_parent_size()
    local relative = self:conf'relative'
    if relative == 'win' then
        local parent_window_id = self:conf'win'
        return {
            width = vim.api.nvim_win_get_width(parent_window_id),
            height = vim.api.nvim_win_get_height(parent_window_id)
        }
    end
    return { width = vim.o.columns, height = vim.o.lines }
end

function Window:float(config)
    -- Basically set_config with default options.
    self:set_config(self:get_default_float_config(config, {
        width = self:get_width(),
        height = self:get_height(),
    }))
    return self
end

function Window:set_height(height)
    vim.api.nvim_win_set_height(self.id, height)
end

function Window:set_height_pct(height_pct)
    local parent_size = self:get_parent_size()
    self:set_height(math.floor(height_pct * parent_size.height))
end

function Window:set_width(width)
    return vim.api.nvim_win_set_width(self.id, width)
end

function Window:set_width_pct(width_pct)
    local parent_size = self:get_parent_size()
    self:set_width(math.floor(width_pct * parent_size.width))
end

function Window:change_dimensions(config)
    local current = self:get_config()
    self:set_config({
        width = config.width or current.width,
        height = config.height or current.height,
        col = config.col or current.col,
        row = config.row or current.row,
    })
    self:_invalidate()
end

function Window:_invalidate()
    self:set_height(self:get_height())
    self:set_width(self:get_width())
end

function Window:set_cursor(row, column)
    column = column or 0
    if row < 0 then
        row = vim.o.lines + (row + 1)
    end
    vim.api.nvim_win_set_cursor(self.id, {row, column})
end

function Window:close(...)
    return vim.api.nvim_win_close(self.id, ...)
end

function Window:del_var(...)
    return vim.api.nvim_win_del_var(self.id, ...)
end

function Window:get_buf(...)
    return vim.api.nvim_win_get_buf(self.id, ...)
end

function Window:get_buffer_id(...)
    return self:get_buf(...)
end

function Window:get_buffer()
    return Buffer:new({ id = self:get_buffer_id()})
end

function Window:get_config()
    local config = vim.api.nvim_win_get_config(self.id)
    if type(config.row) == 'table' then
        config.row = config.row[false]
    end
    if type(config.col) == 'table' then
        config.col = config.col[false]
    end
    return config
end

function Window:get_cursor(...)
    return vim.api.nvim_win_get_cursor(self.id, ...)
end

function Window:get_height(...)
    return vim.api.nvim_win_get_height(self.id, ...)
end

function Window:get_number(...)
    return vim.api.nvim_win_get_number(self.id, ...)
end

function Window:get_option(...)
    return vim.api.nvim_win_get_option(self.id, ...)
end

function Window:get_position(...)
    return vim.api.nvim_win_get_position(self.id, ...)
end

function Window:get_tabpage(...)
    return vim.api.nvim_win_get_tabpage(self.id, ...)
end

function Window:get_var(...)
    return vim.api.nvim_win_get_var(self.id, ...)
end

function Window:get_width(...)
    return vim.api.nvim_win_get_width(self.id, ...)
end

function Window:hide(...)
    return vim.api.nvim_win_hide(self.id, ...)
end

function Window:is_valid(...)
    return vim.api.nvim_win_is_valid(self.id, ...)
end

function Window:set_buf(...)
    return vim.api.nvim_win_set_buf(self.id, ...)
end

function Window:set_config(config, keep)
    if keep == nil then keep = true end
    if keep then
        config = vim.tbl_extend('keep', config, self:get_config())
    end
    return vim.api.nvim_win_set_config(self.id, config)
end

function Window:set_option(...)
    return vim.api.nvim_win_set_option(self.id, ...)
end

function Window:set_var(...)
    return vim.api.nvim_win_set_var(self.id, ...)
end

return Window
