local function toggleNuiFrame(shouldShow)
	SetNuiFocus(shouldShow, shouldShow)
end

RegisterNUICallback("hideFrame", function(_, cb)
	toggleNuiFrame(false)
	SendReactMessage("setVisibleApp", false)
	cb({})
end)

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
		[themeName] = themeConfig,
	}

	SendReactMessage("justgroot:themeplate:theme", themeData)
end

function SystemSettings()
	local data = {
		Currency = Config.SystemSettings.Currency,
		position = Config.SystemSettings.position or "center",
		inventoryImagePath = G.Inventory.inventoryPath,
	}
	SendReactMessage("justgroot:systemsettings:systemsettings", data)
end

function OpenWelcomeUI()
	toggleNuiFrame(true)
	SendReactMessage("setVisibleApp", true)
	SystemSettings()
	Localization()
	sendThemeToNui()
end

if Config.WelcomePackage.OpenMenuType == "command" then
	RegisterCommand(Config.WelcomePackage.SlashCommand, OpenWelcomeUI, false)
end

RegisterNetEvent("justgroot:g-welcome-rewards:closeWelcomeUI:client", function()
	toggleNuiFrame(false)
	SendReactMessage("setVisibleApp", false)
end)

RegisterNUICallback("justgroot:g-welcome-rewards:getWelcomePackages", function(data, cb)
	local items = Config.WelcomePackage.StarterPackages
	cb(items)
end)

RegisterNUICallback("justgroot:g-welcome-rewards:getWelcomeVehicle", function(data, cb)
	local vehicle = Config.WelcomePackage.StarterVehicle
	cb(vehicle)
end)

RegisterNUICallback("justgroot:g-welcome-rewards:claimWelcomePackage", function(_, cb)
	G.Callbacks.Client.Trigger("justgroot:g-welcome-rewards:claimWelcomePackage:server", function(response)
		cb(response)
	end, {})
end)

RegisterNUICallback("justgroot:g-welcome-rewards:claimWelcomeVehicle", function(_, cb)
	G.Callbacks.Client.Trigger("justgroot:g-welcome-rewards:claimWelcomeVehicle:server", function(response)
		cb(response)
	end, {})
end)
