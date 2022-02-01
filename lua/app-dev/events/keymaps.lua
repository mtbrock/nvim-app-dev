local events = require('app-dev.events')

local Handler = events.Handler

local KeymapHandler = Handler:new({})

function KeymapHandler:_prepare_context(context)
    context.opts = context.opts or {}
    if context.callback == nil and type(context.rhs) ~= 'string' then
        context.callback = context.rhs
    end
    return context
end

function KeymapHandler:_register_listener(context, cmd_str)
    local rhs = context.rhs
    if context.callback ~= nil then
        rhs = ('<Cmd>%s<CR>'):format(cmd_str)
    end
    local args = {context.buffer_id, context.mode, context.lhs, rhs, context.opts}
    vim.api.nvim_buf_set_keymap(unpack(args))
end

function KeymapHandler:_unregister_listener(context)
    pcall(vim.api.nvim_buf_del_keymap, context.buffer_id, context.mode, context.lhs)
end

function KeymapHandler:handle_event(context)
    context.callback(unpack(context.args))
end

return KeymapHandler
