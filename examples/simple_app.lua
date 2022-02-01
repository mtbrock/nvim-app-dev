local Keymaps = require('app-dev.events.keymaps')
local Events = require('app-dev.events.events')
local Buffer = require('app-dev.buffer')
local Window = require('app-dev.window')
local center_window = require('app-dev.window.mods.center')

-- Setup buffer and centered floating window.
local content = {}
local buffer = Buffer.create(false, true)
local window = center_window(Window.open(buffer.id, true))
window:set_height_pct(.5)
window:set_width_pct(.5)

-- Initialize event handlers.
local events = Events:new({group_name = 'DemoApp'})
local keymaps = Keymaps:new()

-- Simple render function.
local function render()
    local lines = {
        'Demo App',
        '',
        'Content:',
        '',
    }
    vim.list_extend(lines, content)
    table.insert(lines, '')
    table.insert(lines, 'Press a to add content')
    table.insert(lines, 'Press q to quit')
    buffer:set_lines(0, buffer:line_count(), false, lines)
end

-- Callback for WinEnter event.
local function on_enter()
    table.insert(content, 'Window was entered!')
    render()
end

-- Callback for WinClosed event.
local function on_close()
    events:unsubscribe()
    keymaps:unsubscribe()
end

-- Callback for "a" keymap.
local function a_pressed()
    table.insert(content, 'Added some content.')
    render()
end

-- Setup event listeners.
events:add_listener({
    event_name = 'WinEnter',
    buffer_id = buffer.id,
    callback = on_enter,
})
events:add_listener({
    event_name = 'WinClosed',
    buffer_id = buffer.id,
    callback = on_close,
})

-- Setup keymap listeners.
keymaps:add_listener({
    buffer_id = buffer.id,
    mode = 'n',
    lhs = 'a',
    callback = a_pressed,
})
keymaps:add_listener({
    buffer_id = buffer.id,
    mode = 'n',
    lhs = 'q',
    callback = window.close,
    args = {window, false},
})

-- Do initial render and subscribe to events.
render()
events:subscribe()
keymaps:subscribe()
