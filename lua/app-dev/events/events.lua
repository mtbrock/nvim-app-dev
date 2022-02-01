local events = require('app-dev.events')

local Handler = events.Handler

local EventHandler = Handler:new({
    group_name = '',
    _commands = {},
})

function EventHandler:new(o)
    o = o or {}
    o._commands = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function EventHandler:_register_listener(context, cmd_str)
    local opts_str = ''
    if context.buffer_id ~= nil then
        opts_str = opts_str .. ('<buffer=%s>'):format(context.buffer_id)
    elseif context.buffer == true then
        opts_str = opts_str .. '<buffer>'
    end
    local command = ("%s %s exec '%s'"):format(context.event_name, opts_str, cmd_str)
    table.insert(self._commands, command)
end

function EventHandler:subscribe()
    Handler.subscribe(self)
    if #self._commands > 0 then
        self._create_augroup(self.group_name, self._commands)
    end
end

function EventHandler:unsubscribe()
    Handler.unsubscribe(self)
    self._delete_augroup(self.group_name)
end

function EventHandler:handle_event(context)
    context.callback(unpack(context.args))
end

function EventHandler._delete_augroup(group_name)
    vim.api.nvim_command(([[ :augroup %s | :autocmd! | augroup END ]]):format(group_name))
end

function EventHandler._create_augroup(group_name, commands)
    local exec_lines = {(':augroup %s'):format(group_name), ':autocmd!'}
    for _, command in ipairs(commands) do
        table.insert(exec_lines, (':autocmd %s'):format(command))
    end
    table.insert(exec_lines, ':augroup END')
    for _, command_str in ipairs(exec_lines) do
        vim.api.nvim_command(command_str)
    end
end

return EventHandler
