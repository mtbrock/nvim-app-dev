local Keymaps = {
    _id = -1,
    module = 'app-dev.keymaps',
    group_name = '',
    _listeners = {},
    _keymaps = {}
}

local _handlers = {
    _index = 0
}

local function _register_handler(handler)
    _handlers._index = _handlers._index + 1
    _handlers[_handlers.index] = handler
    handler._id = _handlers._index
end

local function _unregister_handler(handler)
    _handlers[handler._id] = nil
end

local function _handle_event(handler_id, listener_id, ...)
    local handler = _handlers[handler_id]
    if handler == nil then
        return
    end
    handler()
end

local function _create_event_cmd_str(handler_id, ...)
    local args_str = ''
    if ... ~= nil then
        local extra_args = ', ' .. vim.tbl_map(vim.inspect, {{...}})[1]
        extra_args = extra_args:gsub('{ ', ''):gsub(' }', '')
        args_str = args_str .. extra_args
    end

    local require_str = ('<Cmd>lua require("%s")'):format(Keymaps.module)
    return require_str .. ('._handle_event(%s%s)<CR>'):format(handler_id, args_str)
end

function Keymaps:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Keymaps:buf_keymap(buffer_id, mode, lhs, rhs, opts, context)
    local callback = nil
    if type(rhs) ~= 'string' then
        callback = rhs
    end
    table.insert(self._keymaps, {
        buffer_id = buffer_id,
        callback = callback,
        opts = opts or {},
        mode = mode,
        lhs = lhs,
        rhs = rhs,
        context = context,
    })
end

function Keymaps:subscribe()
    _register_handler(self)
    for _, keymap in pairs(self._keymaps) do
        local keymap_str = keymap.rhs
        if keymap.callback ~= nil then
            keymap_str = _create_event_cmd_str(self._id)
        end
        local args = {keymap.buffer_id, keymap.mode, keymap.lhs, keymap_str, keymap.opts}
        vim.api.nvim_buf_set_keymap(unpack(args))
    end
end

function Keymaps:unsubscribe()
    for _, keymap in pairs(self._keymaps) do
        pcall(vim.api.nvim_buf_del_keymap, keymap.buffer_id, keymap.mode, keymap.lhs)
    end
    self._delete_augroup(self.group_name)
    _unregister_handler(self)
end

function Keymaps:handle_event(id)
    local keymap = self._keymaps[id]
    keymap.callback(keymap.context)
end

return Keymaps
