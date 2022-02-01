local function req(module) return require('app-dev.window.mods.' + module) end
return {
    center = req('center'),
}
