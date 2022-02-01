# nvim-app-dev

## Description
This library consists of a handful of modules that are mainly intended for use by neovim plugin
developers but may also be useful to users as well.

## Modules
### window
This module provides a lua class for constructing window objects. The `Window` class wraps every
`nvim_win_*` function.

```lua
local Window = require('app-dev.window')

-- Create a window object with the ID of the currently active window.
local window = Window:new()

-- Create a window object for a specific window ID.
local window = Window:new({ id = <id> })

-- Open a new window and enter it.
local window = Window.create(buffer_id, true, config) -- config is passed directly to 'nvim_open_win'

-- Open a new floating window with some sane defaults.
local window = Window.create_floating(buffer_id, true, config)


-- Call any nvim_win_* function.
window:set_height(50)
window:set_width(100)

-- There are some extras as well.
window:set_height_pct(0.5)
window:set_width_pct(0.5)
```

### buffer
```lua
local Buffer = require('app-dev.buffer')

-- Create a buffer object with the ID of the currently active buffer.
local buffer = Buffer:new()

-- Create a buffer object for a specific buffer ID.
local buffer = Buffer:new({ id = <id> })

-- Create a new unlisted scratch buffer. Default is (listed = true, scratch = false).
local buffer = Buffer.create(false, true)


-- Call any nvim_buf_* function.
buffer:set_lines(0, buffer:line_count(), false, lines)
buffer:set_option('modifiable', false)
```

### events.events
Register listeners for neovim autocmd events. This allows you to call lua functions when
an event is triggered.

**Events:add_listener(context)** - Add an event listener.

`context` format:
|Property|Type|Description|
|--------|----|-----------|
|**event_name** | string (required) | Neovim event e.g., 'WinEnter', 'BufLeave'.|
|**callback** | function (required) | Function to call when the event is triggered.|
|**buffer** | boolean (optional) | If true, register listener for the currently active buffer.|
|**buffer_id** | integer (optional) | Register listener this buffer ID (ignores `buffer` option).|
|**args** | list (optional) | List of arguments to pass to `callback`.|

**Events:subscribe** - Start listening to events. This creates an
`augroup` that contains an `autocmd` for each listener defined.

**Events:unsubscribe** - Stop listening to events. This clears the `augroup` created in
`subscribe`.

```lua
local Events = require('app-dev.events.events')

-- group_name is required. When you subscribe to events, a new augroup is created for group_name.
local events = Events:new({ group_name })
events:add_listener({
    event_name = 'WinLeave',
    callback = function() events:unsubscribe() end,
    buffer_id = vim.api.nvim_eval('bufnr("%")'),
})
events:subscribe()
```

## Motivation
There are many possible approaches to making lua apps but it can be difficult to choose
the right approach and things can quickly get messy with a mixture of lua and vimscript.
There are many examples of neovim apps that offer many different solutions but most are tailored
to a specific plugin implementation or hack together the UI in a way that is difficult to follow.

The intent of this library is to make developing interactive neovim plugins simpler.
