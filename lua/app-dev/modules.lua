local function reload(module)
    --[[
        "Unload" a loaded module if already loaded.

        Returns the result of `require(module)`.
    ]]
    if package.loaded[module] ~= nil then
        package.loaded[module] = nil
    end
    return require(module)
end

return {
    reload = reload
}
