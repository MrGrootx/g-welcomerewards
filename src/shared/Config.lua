Config = {}

--- RECOMENDED TO LEAVE AS TRUE ---
Config.CheckForUpdates = true -- Check for updates on server start
Config.AutoImportSQL = true -- Automatically import on server start

Config.SystemSettings = {
	Language = "en",
	Debug = true,
	theme = "shadcn_dark", -- Theme name from Config.Theme (e.g., "gblue", "custom")
	Currency = "$",
	position = "center", -- supported: "left" | "right" | "center"
}

-- g-notifications package - https://groot-development.tebex.io/package/6838310
Config.Notify = "g-notifications" -- supported Notification's' - "g-notifications" | "ox_lib" | "esx" | "qbcore" | "okok"  | 17mov | standalone

-- QBCore | QBox - pillboxgarage | ESX - SanAndreasAvenue - you can change it
Config.DefaultParking = "pillboxgarage" -- default parking for vehicles


Config.WelcomePackage = {
	OpenMenuType = "location", -- supported types - "location" | "command"
	SlashCommand = "welcome", -- Command to open the shop if OpenMenuType is "command
	Location = { -- Location settings if OpenMenuType is "location"
		EnablePed = true, -- Enable the location ped
		PedModel = "cs_carbuyer", -- Ped model for the location
		PedCoords = vec4(-1040.3978, -2731.0774, 20.2144, 156.7419), -- Coordinates for the ped
		PedScenario = "WORLD_HUMAN_CLIPBOARD", -- optional: scenario name
		TargetDistance = 2.5,
	},
	Blip = {
		Enable = true,
		BlipId = 826,
		BlipColor = 3,
		BlipScale = 0.8,
		BlipDisplay = 4,
		BlipLabel = "Welcome Rewards",
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
		{
			name = "phone",
			Label = "Phone",
			quantity = 1,
			image = "phone.png",
			type = "item",
		},
		{
			name = "radio",
			Label = "Radio",
			quantity = 1,
			image = "radio.png",
			type = "item",
		},
		{
			name = "bandage",
			Label = "Bandage",
			quantity = 5,
			image = "bandage.png",
			type = "item",
		},
		{
			name = "fixkit",
			Label = "Repair Kit",
			quantity = 1,
			image = "advancedkit.png",
			type = "item",
		},
	},
	StarterVehicle = {
		name = "t20", -- vehicle spawn code (use addon spawn name for custom cars)
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
	VehicleSpawn = {
		Enable = true,
		SpawnClearRadius = 3.0,
		SpawnClearHorizontalOnly = true,
		coords = {
			vec4(-1037.0126, -2728.0090, 19.6819, 238.0340),
			vec4(-1031.7378, -2731.0923, 19.6765, 236.0267),
			vec4(-1025.7272, -2734.7009, 19.6703, 237.5941),
		},
	},
}
