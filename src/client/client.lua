local function toggleNuiFrame(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
end

RegisterCommand('show-nui-shadcn22', function()
    toggleNuiFrame(true)
    SendReactMessage('setVisibleApp', true)
    debugPrint('Show NUI frame')
    Localization()
    sendThemeToNui()
end, false)
RegisterCommand('show-nui-shadcn2', function()
    toggleNuiFrame(true)
    SendReactMessage('setVisibleApp2', true)
    debugPrint('Show NUI frame 2')
    sendThemeToNui()
end, false)

RegisterNUICallback('hideFrame', function(_, cb)
    print('Hide NUI frame')
    toggleNuiFrame(false)
    SendReactMessage('setVisibleApp', false)
    cb({})
end)


RegisterCommand('show-nui-shadcn2-false', function()
    toggleNuiFrame(true)
    SendReactMessage('setVisibleApp2', false)
    debugPrint('Show NUI frame 2')
end, false)
RegisterCommand('show-nui-shadcn2-no', function()
    toggleNuiFrame(true)
        SendReactMessage('setVisibleApp3', true)
    debugPrint('Show NUI frame 2')
end, false)

function sendThemeToNui()
    if not Config.SystemSettings or not Config.SystemSettings.theme or not Config.Theme then
        return
    end
    
    local themeName = Config.SystemSettings.theme
    local themeConfig = Config.Theme[themeName]
    
    if not themeConfig then
        return
    end
    
    local themeData = {
        theme = themeName,
        [themeName] = themeConfig
    }
    
    SendReactMessage('justgroot:themeplate:theme', themeData)
end

