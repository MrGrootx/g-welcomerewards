function Localization()
    local translations = {
        order_details = LAN("order_details"),
    }
    SendNUIMessage({
        action = "resource:localizations1",
        data = translations,
    })
end
