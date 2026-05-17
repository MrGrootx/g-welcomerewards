local activeClaims = {}
local DropPlayerConfig = function(source)
	if SVConfig.DropSuspiciousPlayer then
		DropPlayer(
			source,
			"Exploit attempt detected. You really thought triggering a protected server event manually would work? The welcome rewards are for new citizens, not menu warriors running around with a Lua executor downloaded from a Discord server named “FREE OP CHEATS 2026”. The server declined your request and respectfully escorted you to the main menu. 🫡"
		)
	end
end

G.Callbacks.Server.Register("justgroot:g-welcome-rewards:claimWelcomePackage:server", function(source, cb)
	local welcome = Config.WelcomePackage

	if activeClaims[source] then
		return cb(false)
	end

	activeClaims[source] = true

	if welcome.OpenMenuType == "location" then
		local isNear = Utils.isPlayerNearLocation(source, welcome.Location.PedCoords, 5.0)

		if not isNear then
			activeClaims[source] = nil
			DropPlayerConfig(source)
			return cb(false)
		end
	end

	local Player = G.Server.GetPlayer(source)

	if not Player then
		activeClaims[source] = nil
		return cb(false)
	end

	local hasClaimed = WelcomeService.hasClaimedItems(source)

	if hasClaimed then
		activeClaims[source] = nil

		TriggerClientEvent(
			"justgroot:g-welcome-rewards:notify",
			source,
			"You have already claimed your welcome package",
			"error",
			5000
		)

		return cb(false)
	end

	WelcomeService.setClaimedItems(source)

	local rewards = welcome.StarterPackages

	for _, item in ipairs(rewards) do
		local qty = tonumber(item.quantity) or 0

		if qty <= 0 then
			goto continue
		end

		if item.type == "item" then
			local success = G.Inventory.AddItem(source, item.name, qty)

			if not success then
				TriggerClientEvent(
					"justgroot:g-welcome-rewards:notify",
					source,
					("Failed to receive item: %s"):format(item.Label or item.name),
					"error",
					5000
				)
			end
		elseif item.type == "cash" or item.type == "bank" then
			G.Server.AddMoney(source, item.type, qty)
		end

		::continue::
	end

	activeClaims[source] = nil
	cb(true)
end)

AddEventHandler("playerDropped", function(src)
	local source = src
	WelcomeService.clearCache(source)
	activeClaims[source] = nil
end)
