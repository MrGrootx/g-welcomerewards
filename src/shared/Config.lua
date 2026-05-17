Config = {}

--- RECOMENDED TO LEAVE AS TRUE ---
Config.CheckForUpdates = true -- Check for updates on server start
Config.AutoImportSQL = true -- Automatically import on server start

Config.SystemSettings = {
	Language = "en",
	Debug = true,
	theme = "shadcn_dark", -- Theme name from Config.Theme (e.g., "gblue", "custom")
	Currency = "$",
}

Config.WelcomePackage = {
	OpenMenuType = "location", -- supported types - "location" | "command" | "inventory_item"
	SlashCommand = "welcome", -- Command to open the shop if OpenMenuType is "command
	Location = { -- Location settings if OpenMenuType is "location"
		EnablePed = true, -- Enable the location ped
		PedModel = "cs_carbuyer", -- Ped model for the location
		PedCoords = vec4(-1040.3978, -2731.0774, 20.2144, 156.7419), -- Coordinates for the ped
		PedScenario = "WORLD_HUMAN_CLIPBOARD", -- optional: scenario name
		TargetDistance = 2.5,
	},
	StarterPackages = {
		{
			name = "water", -- item spawn code
			Label = "Water",
			quantity = 10,
			image = "water.png",
			type = "item",
		},
		{
			name = "burger",
			Label = "Burger",
			quantity = 10,
			image = "burger.png",
			type = "item",
		},
		{
			name = "money",
			Label = "Money",
			quantity = 1000,
			image = "money.png",
			type = "cash",
		},
		{
			name = "bank",
			Label = "Bank",
			quantity = 1000,
			image = "bank.png",
			type = "bank",
		},
	},
	StarterVehicle = {
		name = "t20", -- vehicle spawn code
		label = "Progen T20",
		class = "Super Class",
		seats = 2,
		stats = {
			speed = 98,
			acceleration = 89,
			braking = 82,
			grip = 91,
		},
		imageUrl = "https://docs.fivem.net/vehicles/t20.webp",
	},
}
