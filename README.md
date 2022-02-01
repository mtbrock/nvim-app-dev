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
local window = Window.open(buffer_id, true, config) -- config is passed directly to 'nvim_open_win'

-- Open a new floating window with some sane defaults.
local window = Window.open_floating(buffer_id, true, config)


-- Call any nvim_win_* function.
window:set_height(50)
window:set_width(100)

-- There are some extras as well.
window:set_height_pct(0.5)
window:set_width_pct(0.5)
```

### window.mods
`Window` wrappers that allow you apply various decorations or modifications to a window, typically a floating window.
These modules are slightly experimental and some are works-in-progress.

**center** - Center a floating window vertically and horizontally.
```lua
local Window = require('app-dev.window')
local center_window = require('app-dev.window.mods.center')
local window = center_window(Window.open_floating(buffer_id, true, config))
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
Register lua function callbacks for neovim autocmd events.

**Events:add_listener(context)** - Add an event listener.

`context` format:
|Property|Type|Description|
|--------|----|-----------|
|**event_name** | string (required) | Neovim event e.g., 'WinEnter', 'BufLeave'.|
|**callback** | function (required) | Function to call when the event is triggered.|
|**buffer** | boolean (optional) | If true, register listener for the currently active buffer.|
|**buffer_id** | integer (optional) | Register listener this buffer ID (ignores `buffer` option).|
|**args** | list (optional) | List of arguments to pass to `callback`.|

**Events:subscribe** - Start listening to events. Behind the scenes this creates an
`augroup` that contains an `autocmd` for each listener defined.

**Events:unsubscribe** - Stop listening to events. This clears the `augroup` created in
`subscribe`.

```lua
local Events = require('app-dev.events.events')

-- group_name is required.
local events = Events:new({ group_name })
events:add_listener({
    event_name = 'WinLeave',
    callback = function() events:unsubscribe() end,
    buffer_id = vim.api.nvim_eval('bufnr("%")'),
})
events:subscribe()
```

### events.keymaps
Register lua function callbacks (or standard map strings) for key maps.

**Keymaps:add_listener(context)** - Add a keymap listener.

`context` format:
|Property|Type|Description|
|--------|----|-----------|
|**buffer_id** | integer (required) | Register listener this buffer ID.|
|**lhs** | string (required) | Keys to map. See `:help map`|
|**rhs** | function / string (optional) | Standard {rhs} string or a function used as callback. See `:help map`.|
|**callback** | function (required) | Function to call when the event is triggered (ignores `rhs` option).|
|**mode** | string (optional) | Map mode. Default is 'n'. See `:help map`.|
|**args** | list (optional) | List of arguments to pass to `callback`.|

**Keymaps:subscribe** - Start listening to key events. This creates buffer local key maps.

**Keymaps:unsubscribe** - Stop listening to key events. This removes maps created by `subscribe`.

```lua
local Keymaps = require('app-dev.events.keymaps')
keymaps:add_listener({
    buffer_id = vim.api.nvim_eval('bufnr("%")'),
    lhs = 'q'
    callback = function() print('Pressed "q"') end,
})
keymaps:subscribe()
```

## Motivation
There are many possible approaches to making lua apps but it can be difficult to choose
the right approach and things can quickly get messy with a mixture of lua and vimscript.
There are many examples of neovim apps that offer many different solutions but most are tailored
to a specific plugin implementation or hack together the UI in a way that is difficult to follow.
This library intends to provide a simple way to implement various common UI funcionalities and
establish a standard for creating a UI in neovim with lua.
