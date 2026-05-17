WelcomeService = {}
local claimCache = {}

local function getIdentifier(source)
	return G.Server.GetIdentifier(source)
end
local function isClaimedFlag(value)
	return value == true or value == 1 or value == "1"
end
function WelcomeService.getPlayerClaimData(source)
	local identifier = getIdentifier(source)
	if not identifier then
		return nil
	end

	if claimCache[identifier] then
		return claimCache[identifier]
	end

	local data = MySQL.single.await(
		[[
        SELECT *
        FROM g_welcome_rewards
        WHERE identifier = ?
    ]],
		{
			identifier,
		}
	)

	if not data then
		MySQL.insert.await(
			[[
            INSERT INTO g_welcome_rewards (identifier)
            VALUES (?)
        ]],
			{
				identifier,
			}
		)

		data = {
			identifier = identifier,
			claimed_items = 0,
			claimed_vehicle = 0,
		}
	end

	claimCache[identifier] = data

	return data
end

function WelcomeService.hasClaimedItems(source)
	local data = WelcomeService.getPlayerClaimData(source)

	if not data then
		return false
	end

	return isClaimedFlag(data.claimed_items)
end

function WelcomeService.hasClaimedVehicle(source)
	local data = WelcomeService.getPlayerClaimData(source)

	if not data then
		return false
	end

	return isClaimedFlag(data.claimed_vehicle)
end

function WelcomeService.setClaimedItems(source)
	local identifier = getIdentifier(source)
	if not identifier then
		return false
	end

	MySQL.update.await(
		[[
        UPDATE g_welcome_rewards
        SET claimed_items = 1,
            claimed_items_at = NOW()
        WHERE identifier = ?
    ]],
		{
			identifier,
		}
	)

	if claimCache[identifier] then
		claimCache[identifier].claimed_items = 1
	end

	return true
end

function WelcomeService.setClaimedVehicle(source)
	local identifier = getIdentifier(source)
	if not identifier then
		return false
	end

	MySQL.update.await(
		[[
        UPDATE g_welcome_rewards
        SET claimed_vehicle = 1,
            claimed_vehicle_at = NOW()
        WHERE identifier = ?
    ]],
		{
			identifier,
		}
	)

	if claimCache[identifier] then
		claimCache[identifier].claimed_vehicle = 1
	end

	return true
end


function WelcomeService.clearCache(source)
    local identifier = getIdentifier(source)
    if not identifier then
        return
    end

    claimCache[identifier] = nil
end

