# nvim-app-dev

## Description
This library consists of a handful of modules that are mainly intended for use by neovim plugin
developers but may also be useful to users as well.

## Modules
### window
This module provides a lua class for constructing window objects. The `Window` class wraps every
`nvim_win_*` function.

**Examples:**
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

-- Create a new unlisted scratch buffer. Default is (listed = true, scratch = false).
local buffer = Buffer.create(false, true)


-- Call any nvim_buf_* function.
buffer:set_lines(0, buffer:line_count(), false, lines)
buffer:set_option('modifiable', false)
```

## Motivation
There are many possible approaches to making lua apps but it can be difficult to choose
the right approach and things can quickly get messy with a mixture of lua and vimscript.
There are many examples of neovim apps that offer many different solutions but most are tailored
to a specific plugin implementation or hack together the UI in a way that is difficult to follow.

The intent of this library is to make developing interactive neovim plugins simpler.
