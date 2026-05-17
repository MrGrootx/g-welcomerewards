---@diagnostic disable: duplicate-set-field, missing-fields
if GetResourceState("es_extended") ~= "started" then
	return
end

ESX = exports.es_extended:getSharedObject()

G.Client = {
	playerLoaded = false,
	playerData = {},
}

local isDead


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer, isNew, skin)
	G.Client.playerData = xPlayer
	G.Client.playerLoaded = true
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	G.Client.playerData.job = job
	ESX.PlayerData = job
end)

AddEventHandler("esx:onPlayerDeath", function(data)
	isDead = true
end)

AddEventHandler("esx:onPlayerSpawn", function(noAnim)
	isDead = nil
end)

RegisterNetEvent("esx:onPlayerLogout")
AddEventHandler("esx:onPlayerLogout", function()
	G.Client.playerLoaded = false
	G.Client.playerData = {}
end)


function G.Client.GetCore()
	return ESX
end

function G.Client.GetPlayerData()
	return G.Client.playerData
end

function G.Client.isPlayerDead()
	return isDead
end

function G.Client.GetPlayerJob()
	local playerData = ESX.GetPlayerData()
	if not playerData or not playerData.job then
		return nil
	end
	return {
		name = playerData.job.name,
		label = playerData.job.label,
		grade_name = playerData.job.grade_name,
		grade_label = playerData.job.grade_label,
		grade_salary = playerData.job.grade_salary,
		grade = playerData.job.grade,
		isboss = playerData.job.grade_name == "boss" or false,
		onduty = (playerData.job and playerData.job.onDuty ~= nil) and playerData.job.onDuty or true,
		isGang = false,
	}
end

function G.Client.GetPlayerGang()
	return nil
end

function G.Client.GetIdentifier()
	return ESX.GetPlayerData().identifier
end

function G.Client.GetPlayerName()
	local playerData = ESX.GetPlayerData()
	if not playerData then
		return "Unknown"
	end

	if playerData.firstName and playerData.lastName then
		return playerData.firstName .. " " .. playerData.lastName
	end

	if playerData.name then
		return playerData.name
	end

	return "Unknown"
end
