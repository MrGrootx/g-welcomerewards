Utils = {}

function Utils.isPlayerNearLocation(source, coords, distance)
	local ped = GetPlayerPed(source)
	if not ped or ped == 0 then
		return false
	end
	local playerCoords = GetEntityCoords(ped)
	local targetCoords = vector3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
	local dist = #(playerCoords - targetCoords)
	return dist <= (distance or 3.0)
end

function Utils.SpawnWelcomeVehicle(source, modelName, plate, timeoutMs)
	if not source or not modelName or modelName == "" then
		return false
	end

	local spawnCfg = Config.WelcomePackage.VehicleSpawn
	if not spawnCfg or spawnCfg.Enable ~= true then
		return false
	end

	local done, success = false, false
	local deadline = GetGameTimer() + (timeoutMs or 300000)

	G.Callbacks.Server.TriggerClient(source, "justgroot:g-welcome-rewards:spawnWelcomeVehicle:client", function(ok)
		success = ok == true

		done = true
	end, modelName, plate or "")

	while not done and GetGameTimer() < deadline do
		Wait(0)
	end

	return done and success
end
