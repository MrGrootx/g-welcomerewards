local function trimStr(value)
	if type(value) ~= "string" then
		return ""
	end
	return value:match("^%s*(.-)%s*$") or ""
end

local function shuffleInPlace(t)
	for i = #t, 2, -1 do
		local j = math.random(i)

		t[i], t[j] = t[j], t[i]
	end
end

local function spawnPointBlocked(center, radius, ignoreEntity, horizontalOnly)
	if radius <= 0.0 then
		return false
	end

	local pool = GetGamePool("CVehicle")
	local r2 = radius * radius
	local xyOnly = horizontalOnly == true

	for i = 1, #pool do
		local veh = pool[i]

		if veh ~= ignoreEntity and veh ~= 0 and DoesEntityExist(veh) then
			local p = GetEntityCoords(veh)

			local dx = p.x - center.x

			local dy = p.y - center.y

			local dz = p.z - center.z

			if xyOnly then
				if dx * dx + dy * dy <= r2 then
					return true
				end
			elseif dx * dx + dy * dy + dz * dz <= r2 then
				return true
			end
		end
	end

	return false
end

local function firstClearSpawnFromList(entries, radius, ignoreEntity, lanKeyOnFail, horizontalOnly)
	if not entries or #entries == 0 then
		return nil
	end

	local work = {}
	for i = 1, #entries do
		work[i] = entries[i]
	end

	shuffleInPlace(work)

	for i = 1, #work do
		local pos = work[i]
		if pos then
			local center = vector3(pos.x, pos.y, pos.z)

			if not spawnPointBlocked(center, radius, ignoreEntity, horizontalOnly) then
				return pos
			end
		end
	end

	if lanKeyOnFail then
		TriggerEvent("justgroot:g-welcome-rewards:notify", LAN(lanKeyOnFail), "error", 7500)
	end

	return nil
end

local function spawnWelcomeVehicle(modelName, plate)
	local spawnCfg = Config.WelcomePackage.VehicleSpawn

	if not spawnCfg or spawnCfg.Enable ~= true then
		return false
	end

	modelName = trimStr(modelName)
	plate = trimStr(plate)

	if modelName == "" then
		return false
	end

	local modelHash = joaat(modelName)
	if modelHash == 0 then
		return false
	end

	if not RRequestModel(modelName, LAN("vehicle_loading")) then
		return false
	end

	local radius = tonumber(spawnCfg.SpawnClearRadius) or 3.0
	local horizontalOnly = spawnCfg.SpawnClearHorizontalOnly ~= false
	local ped = PlayerPedId()
	local ignoreVeh = GetVehiclePedIsIn(ped, false)

	if ignoreVeh == 0 then
		ignoreVeh = nil
	end

	local coords =
		firstClearSpawnFromList(spawnCfg.coords, radius, ignoreVeh, "vehicle_spawn_area_blocked", horizontalOnly)

	if not coords then
		SetModelAsNoLongerNeeded(modelHash)
		return false
	end

	local veh = CreateVehicle(modelHash, coords.x, coords.y, coords.z, coords.w or 0.0, true, false)
	if not veh or veh == 0 or not DoesEntityExist(veh) then
		SetModelAsNoLongerNeeded(modelHash)
		return false
	end
	local netId = NetworkGetNetworkIdFromEntity(veh)

	if netId and netId ~= 0 then
		SetNetworkIdCanMigrate(netId, true)
	end

	SetEntityAsMissionEntity(veh, true, true)
	SetVehicleHasBeenOwnedByPlayer(veh, true)
	SetVehicleOnGroundProperly(veh)
	if plate ~= "" then
		SetVehicleNumberPlateText(veh, plate)
	end
	SetVehicleEngineOn(veh, true, true, false)
	TaskWarpPedIntoVehicle(ped, veh, -1)
	SetModelAsNoLongerNeeded(modelHash)
	return true
end

G.Callbacks.Client.Register("justgroot:g-welcome-rewards:spawnWelcomeVehicle:client", function(cb, modelName, plate)
	cb(spawnWelcomeVehicle(modelName, plate))
end)
