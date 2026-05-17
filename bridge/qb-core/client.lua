---@diagnostic disable: duplicate-set-field, missing-fields
if GetResourceState("qb-core") ~= "started" then
   return
end

QBCore = exports["qb-core"]:GetCoreObject()

G.Client = {
   playerLoaded = false,
   playerData = {},
}



RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function(playerData)
   G.Client.playerData = playerData
   G.Client.playerLoaded = true
end)


RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(job)
   if G.Client.playerData and G.Client.playerData.job then
      G.Client.playerData.job = job
   end
   QBCore.Functions.GetPlayerData().job = job
end)

RegisterNetEvent("QBCore:Client:OnGangUpdate")
AddEventHandler("QBCore:Client:OnGangUpdate", function(gang)
   if G.Client.playerData and G.Client.playerData.gang then
      G.Client.playerData.gang = gang
   end
end)

RegisterNetEvent("QBCore:Player:SetPlayerData", function(PlayerData)
   G.Client.playerData = PlayerData
end)

function G.Client.getCore()
   return QBCore
end

function G.Client.GetPlayerData()
   return G.Client.playerData
end

function G.Client.isPlayerDead()
   if not G.Client.playerLoaded then
      return
   end
   G.Client.playerData = QBCore.Functions.GetPlayerData()
   return G.Client.playerData.metadata.isdead or G.Client.playerData.metadata.inlaststand
end

function G.Client.GetPlayerJob()
   local playerData = QBCore.Functions.GetPlayerData()
   if not playerData or not playerData.job then
      return nil
   end

   local job = playerData.job

   return {
      name = job.name,
      label = job.label,
      grade_name = job.grade.name,
      grade_label = job.grade.label,
      grade_salary = job.payment or 0,
      grade = job.grade.level,
      isboss = job.isboss or false,
      onduty = job.onduty or false,
   }
end

function G.Client.GetPlayerGang()
   local playerData = QBCore.Functions.GetPlayerData()
   if not playerData or not playerData.gang then
      return nil
   end

   local gang = playerData.gang
   if gang.name == "none" then
      return nil
   end

   return {
      name = gang.name,
      label = gang.label,
      grade_name = gang.grade.name,
      grade_label = gang.grade.label,
      grade = gang.grade.level,
      isboss = gang.isboss or false,
   }
end

function G.Client.GetIdentifier()
   return QBCore.Functions.GetPlayerData().citizenid
end

function G.Client.GetPlayerName()
   local playerData = QBCore.Functions.GetPlayerData()
   if not playerData then
      return "Unknown"
   end

   if playerData.charinfo then
      if playerData.charinfo.firstname and playerData.charinfo.lastname then
         return playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname
      end
   end

   if playerData.name then
      return playerData.name
   end

   return "Unknown"
end
