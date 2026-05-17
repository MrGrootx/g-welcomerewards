function Localization()
	local translations = {
		new_citizen_package = LAN("new_citizen_package"),
		welcome_to_the_city = LAN("welcome_to_the_city"),
		collect_package = LAN("collect_package"),
		starter_package = LAN("starter_package"),
		loading_rewards = LAN("loading_rewards"),
		rewards_ready_to_claim = LAN("rewards_ready_to_claim"),
		speed = LAN("speed"),
		acceleration = LAN("acceleration"),
		braking = LAN("braking"),
		grip = LAN("grip"),
		seats = LAN("seats"),
		claim_vehicle = LAN("claim_vehicle"),
		starter_vehicle = LAN("starter_vehicle"),
	}
	SendNUIMessage({
		action = "justgroot-g-:localizations:g-welcomerewards",
		data = translations,
	})
end
