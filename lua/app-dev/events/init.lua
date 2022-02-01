local Handler = {
    _id = -1,
    module = 'app-dev.events',
    _listeners = {},
}

local _handlers = {
    _index = 0
}

function Handler:new(o)
    o = o or {}
    o._listeners = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local function _register_handler(handler)
    _handlers._index = _handlers._index + 1
    _handlers[_handlers._index] = handler
    handler._id = _handlers._index
end

local function _unregister_handler(handler)
    _handlers[handler._id] = nil
    handler._registered_listeners = {}
end

local function _handle_event(handler_id, listener_id, ...)
    local handler = _handlers[handler_id]
    if handler == nil then
        return
    end
    handler:handle_event(handler._listeners[listener_id], ...)
end

local function _create_event_cmd_str(handler_id, listener_id, ...)
    local args_str = ''
    if ... ~= nil then
        local extra_args = ', ' .. vim.tbl_map(vim.inspect, {{...}})[1]
        extra_args = extra_args:gsub('{ ', ''):gsub(' }', '')
        args_str = args_str .. extra_args
    end

    local require_str = ('lua require("%s")'):format(Handler.module)
    return require_str .. ('._handle_event(%s, %s%s)'):format(handler_id, listener_id, args_str)
end

function Handler:subscribe()
    _register_handler(self)
    for id, context in ipairs(self._listeners) do
        local cmd_str = _create_event_cmd_str(self._id, id)
        self:_register_listener(context, cmd_str)
    end
end

function Handler:unsubscribe()
    for _, context in ipairs(self._listeners) do
        self:_unregister_listener(context)
    end
    _unregister_handler(self)
end

function Handler:_prepare_context(context)
    return context
end

function Handler:_register_listener(context, cmd_str)
end

function Handler:_unregister_listener(context)
end

function Handler:handle_event(context)
end

function Handler:add_listener(context)
    context.args = context.args or {}
    table.insert(self._listeners, self:_prepare_context(context))
end

return {
    Handler = Handler,
    _handle_event = _handle_event,
}
