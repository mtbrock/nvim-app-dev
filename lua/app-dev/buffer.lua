local Buffer = {
    id = -1,
}

function Buffer:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Buffer.create(listed, scratch)
    if listed == nil then listed = true end
    scratch = scratch or false
    return Buffer:new({
        id = vim.api.nvim_create_buf(listed, scratch)
    })
end

function Buffer:add_highlight(...)
    return vim.api.nvim_buf_add_highlight(self.id, ...)
end

function Buffer:attach(...)
    return vim.api.nvim_buf_attach(self.id, ...)
end

function Buffer:call(...)
    return vim.api.nvim_buf_call(self.id, ...)
end

function Buffer:clear_highlight(...)
    return vim.api.nvim_buf_clear_highlight(self.id, ...)
end

function Buffer:clear_namespace(...)
    return vim.api.nvim_buf_clear_namespace(self.id, ...)
end

function Buffer:del_extmark(...)
    return vim.api.nvim_buf_del_extmark(self.id, ...)
end

function Buffer:del_keymap(...)
    return vim.api.nvim_buf_del_keymap(self.id, ...)
end

function Buffer:del_var(...)
    return vim.api.nvim_buf_del_var(self.id, ...)
end

function Buffer:delete(...)
    return vim.api.nvim_buf_delete(self.id, ...)
end

function Buffer:get_changedtick(...)
    return vim.api.nvim_buf_get_changedtick(self.id, ...)
end

function Buffer:get_commands(...)
    return vim.api.nvim_buf_get_commands(self.id, ...)
end

function Buffer:get_extmark_by_id(...)
    return vim.api.nvim_buf_get_extmark_by_id(self.id, ...)
end

function Buffer:get_extmarks(...)
    return vim.api.nvim_buf_get_extmarks(self.id, ...)
end

function Buffer:get_keymap(...)
    return vim.api.nvim_buf_get_keymap(self.id, ...)
end

function Buffer:get_lines(...)
    return vim.api.nvim_buf_get_lines(self.id, ...)
end

function Buffer:get_mark(...)
    return vim.api.nvim_buf_get_mark(self.id, ...)
end

function Buffer:get_name(...)
    return vim.api.nvim_buf_get_name(self.id, ...)
end

function Buffer:get_number(...)
    return vim.api.nvim_buf_get_number(self.id, ...)
end

function Buffer:get_offset(...)
    return vim.api.nvim_buf_get_offset(self.id, ...)
end

function Buffer:get_option(...)
    return vim.api.nvim_buf_get_option(self.id, ...)
end

function Buffer:get_var(...)
    return vim.api.nvim_buf_get_var(self.id, ...)
end

function Buffer:is_loaded(...)
    return vim.api.nvim_buf_is_loaded(self.id, ...)
end

function Buffer:is_valid(...)
    return vim.api.nvim_buf_is_valid(self.id, ...)
end

function Buffer:line_count(...)
    return vim.api.nvim_buf_line_count(self.id, ...)
end

function Buffer:set_extmark(...)
    return vim.api.nvim_buf_set_extmark(self.id, ...)
end

function Buffer:set_keymap(...)
    return vim.api.nvim_buf_set_keymap(self.id, ...)
end

function Buffer:set_lines(start, ...)
    start = start or 0
    local end_, strict, lines = ...
    end_ = end_ or -1
    strict = strict or false
    lines = lines or {}
    if ... == nil then
        lines = start
        start = 0
    end
    return vim.api.nvim_buf_set_lines(self.id, start, end_, strict, lines)
end

function Buffer:set_name(...)
    return vim.api.nvim_buf_set_name(self.id, ...)
end

function Buffer:set_option(...)
    return vim.api.nvim_buf_set_option(self.id, ...)
end

function Buffer:set_options(options)
    for key, value in pairs(options) do
        vim.api.nvim_buf_set_option(self.id, key, value)
    end
end

function Buffer:set_text(...)
    return vim.api.nvim_buf_set_text(self.id, ...)
end

function Buffer:set_var(...)
    return vim.api.nvim_buf_set_var(self.id, ...)
end

function Buffer:set_virtual_text(...)
    return vim.api.nvim_buf_set_virtual_text(self.id, ...)
end

return Buffer
