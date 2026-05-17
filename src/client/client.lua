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
		inventoryImagePath = G.Inventory.inventoryPath,
	}
	SendReactMessage("justgroot:systemsettings:systemsettings", data)
end

function OpenWelcomeUI()
	toggleNuiFrame(true)
	SendReactMessage("setVisibleApp", true)
	SystemSettings()
	-- Localization()
	sendThemeToNui()
end

RegisterCommand("open-welcome-ui", OpenWelcomeUI, false)

RegisterNUICallback("justgroot:g-welcome-rewards:getWelcomePackages", function(data, cb)
	local items = Config.WelcomePackage.StarterPackages
	cb(items)
end)

RegisterNUICallback("justgroot:g-welcome-rewards:getWelcomeVehicle", function(data, cb)
	local vehicle = Config.WelcomePackage.StarterVehicle
	cb(vehicle)
end)
