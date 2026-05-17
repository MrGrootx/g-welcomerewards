---@diagnostic disable: duplicate-set-field, undefined-field, missing-fields
if GetResourceState("qbx_core") ~= "started" then return end
QBox = exports.qbx_core

G.Client = {
   playerLoaded = false,
   playerData = {},
}



RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function(playerData)
   G.Client.playerData = playerData
   G.Client.playerLoaded = true
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload", function()
   G.Client.playerData = {}
   G.Client.playerLoaded = false
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(job)
   if G.Client.playerData and G.Client.playerData.job then
      G.Client.playerData.job = job
   end
   QBox:GetPlayerData().job = job
end)

RegisterNetEvent("QBCore:Client:OnGangUpdate")
AddEventHandler("QBCore:Client:OnGangUpdate", function(gang)
   if G.Client.playerData and G.Client.playerData.gang then
      G.Client.playerData.gang = gang
   end
end)

function G.Client.getCore()
   return QBox
end

function G.Client.GetPlayerData()
   return G.Client.playerData
end

function G.Client.isPlayerDead()
   return G.Client.playerData.metadata and
       (G.Client.playerData.metadata.isdead or G.Client.playerData.metadata.inlaststand)
end

function G.Client.GetPlayerJob()
   local playerData = QBox:GetPlayerData()

   if not playerData or not playerData.job then
      return nil
   end

   local job = playerData.job

   return {
      name = job.name,
      label = job.label,
      grade_name = job.grade and job.grade.name or nil,
      grade_label = job.grade and job.grade.label or nil,
      grade_salary = job.payment or 0,
      grade = job.grade and job.grade.level or 0,
      isboss = job.isboss or false,
      onduty = job.onduty or false,
   }
end

function G.Client.GetPlayerGang()
   local playerData = QBox:GetPlayerData()
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
      grade_name = gang.grade and gang.grade.name or nil,
      grade_label = gang.grade and gang.grade.label or nil,
      grade = gang.grade and gang.grade.level or 0,
      isboss = gang.isboss or false,
   }
end

function G.Client.GetIdentifier()
   return QBox:GetPlayerData().citizenid
end

function G.Client.GetPlayerName()
   local playerData = QBox:GetPlayerData()
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
