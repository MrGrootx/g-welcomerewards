---@diagnostic disable: undefined-field

local spawnedPed = nil
local targetZoneId = nil
local targetZoneName = ("g_welcome_rewards_%s"):format(GetCurrentResourceName())

local function cleanup()
	if spawnedPed and DoesEntityExist(spawnedPed) then
		DeleteEntity(spawnedPed)
	end
	spawnedPed = nil

	if targetZoneId and Target and Target.RemoveZone then
		Target.RemoveZone(targetZoneId)
	end
	targetZoneId = nil
end
local function getCoords(pedCoords)
	local x = pedCoords.x or pedCoords[1]
	local y = pedCoords.y or pedCoords[2]
	local z = pedCoords.z or pedCoords[3]
	local w = pedCoords.w or pedCoords[4] or 0.0

	if not x or not y or not z then
		return nil
	end

	return vector4(x, y, z, w)
end

local function spawnPed(coords, model, scenario)
	local hash = RRequestModel(model, 20000)
	if not hash then
		if Config.SystemSettings.Debug then
			print(("[g-welcome-rewards] failed to load ped model: %s"):format(tostring(model)))
		end
		return
	end

	local ped = CreatePed(4, hash, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
	SetModelAsNoLongerNeeded(hash)

	if not DoesEntityExist(ped) then
		return
	end

	SetEntityHeading(ped, coords.w)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetPedCanBeTargetted(ped, false)
	SetPedFleeAttributes(ped, 0, false)
	SetPedDiesWhenInjured(ped, false)
	SetPedKeepTask(ped, true)

	if scenario and scenario ~= "" then
		TaskStartScenarioInPlace(ped, scenario, 0, true)
	end

	spawnedPed = ped
end

local function addTarget(coords, label, distance)
	if not Target or not Target.AddTargetBoxZone then
		if Config.SystemSettings.Debug then
			print("[g-welcome-rewards] target system is not available")
		end
		return
	end

	local options = {
		{
            name = targetZoneName,
            icon = "fas fa-gift",
            label = label,
            distance = distance,
            onSelect = function()
                OpenWelcomeUI()
            end,
        }
	}

	targetZoneId = Target.AddTargetBoxZone(
		targetZoneName,
		vector3(coords.x, coords.y, coords.z - 0.5),
		1.0,
		coords.w,
		options,
		Config.SystemSettings.Debug
	)
end

CreateThread(function()
	cleanup()
	local welcome = Config.WelcomePackage
	if not welcome or welcome.OpenMenuType ~= "location" then
		return
	end

	local loc = welcome.Location
	if not loc or not loc.PedCoords then
		return
	end

	local coords = getCoords(loc.PedCoords)
	if not coords then
		return
	end

	if loc.EnablePed and loc.PedModel then
		spawnPed(coords, loc.PedModel, loc.PedScenario)
	end

	addTarget(coords, LAN("use_welcome_rewards"), loc.TargetDistance or 2.5)
end)

AddEventHandler("onResourceStop", function(resource)
	if resource ~= GetCurrentResourceName() then
		return
	end
	cleanup()
end)


-- Notifications
local Notification = Config.Notify
Notify = function(message, type, duration)
	if not type then
		type = "success"
	end
	if not duration then
		duration = 5000
	end

	if Notification == "esx" then
		ESX.ShowNotification(message)
	elseif Notification == "okok" then
		exports.okokNotify:Alert(type, message, duration, type, false)
	elseif Notification == "qbcore" then
		if type == "info" then
			type = "primary"
		end
		QBCore.Functions.Notify(message, type, duration)
	elseif Notification == "ox_lib" then
		exports["ox_lib"]:notify({
			title = "Notification",
			description = message,
			type = type,
			duration = duration,
			position = "top-right",
		})
	elseif Notification == "17mov" then
		exports["17mov_Hud"]:ShowNotification(message, type, "Notification", duration)
	elseif Notification == "standalone" then
		AddTextEntry("g_bridge", message)
		BeginTextCommandThefeedPost("g_bridge")
		EndTextCommandThefeedPostTicker(false, true)
	elseif Notification == "g-notifications" then
		exports["g-notifications"]:Notify({
			title = "Notification",
			description = message,
			type = type,
			duration = duration,
			position = "top-right",
		})
	else
		print("Notification type not found")
	end
end

RegisterNetEvent("justgroot:g-welcome-rewards:notify", function(message, type, duration)
	Notify(message, type, duration)
end)
