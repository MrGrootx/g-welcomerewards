Config = {}

Config.SystemSettings = {
	Language = "en",
	Debug = true,
	theme = "shadcn_dark", -- Theme name from Config.Theme (e.g., "gblue", "custom")
}

-- TextUI settings
Config.Key = 38 -- 38 = [E] https://docs.fivem.net/docs/game-references/controls/#controls
Config.KeyName = "[E] "
Config.TextUI = "ox_lib" -- supported Notifications TextUi's -  "ox_lib" | "okok" | "esx" | "qbcore"

Config.WelcomePackage = {
	StarterPackages = {
		{
			name = "water",
			Label = "Water",
			quantity = 10,
			image = "water.png",
			type = "item",
		},
		{
			name = "bread",
			Label = "Bread",
			quantity = 10,
			image = "bread.png",
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
}
