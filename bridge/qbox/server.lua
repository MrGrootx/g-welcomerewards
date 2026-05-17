---@diagnostic disable: duplicate-set-field, undefined-field, missing-fields
if GetResourceState("qbx_core") ~= "started" then
    return
end

QBox = exports.qbx_core
G.Server = {};

local playerVehiclesHasTypeColumn

local function PlayerVehiclesSupportsTypeColumn()
    if playerVehiclesHasTypeColumn == nil then
        local ok, result = pcall(function()
            return MySQL.query.await("SHOW COLUMNS FROM player_vehicles LIKE 'type'")
        end)

        if ok and result and type(result) == "table" and #result > 0 then
            playerVehiclesHasTypeColumn = true
        else
            playerVehiclesHasTypeColumn = false
        end
    end

    return playerVehiclesHasTypeColumn
end

function G.Server.GetCore()
    return QBox
end

function G.Server.GetPlayer(source)
    return QBox:GetPlayer(source)
end

function G.Server.GetPlayers()
    return QBox:GetQBPlayers()
end

function G.Server.GetPlayerSources()
    local sources = {};
    for _, player in ipairs(G.Server.GetPlayers()) do
        table.insert(sources, player.PlayerData.source);
    end
    return sources;
end

function G.Server.GetPlayerName(_source)
    local src = _source or source
    local playerData = G.Server.GetPlayer(src).PlayerData
    if not playerData then
        return
    end
    return playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname
end

function G.Server.GetIdentifier(src)
    local xPlayer = G.Server.GetPlayer(src)
    if xPlayer then
        return xPlayer.PlayerData.citizenid
    end
    return nil
end

function G.Server.PlayerJobinfo(src)
    local xPlayer = G.Server.GetPlayer(src)
    xPlayer = xPlayer or QBox:GetPlayer(src)
    if not xPlayer then
        return nil
    end

    local playerJob = xPlayer.PlayerData.job
    local jobGradeData = (playerJob and playerJob.grade) or {}

    local jobInfo = {
        name = playerJob and playerJob.name or nil,
        label = playerJob and playerJob.label or nil,
        grade = jobGradeData.level or 0,
        gradeLabel = jobGradeData.name,
        isboss = playerJob and (playerJob.isboss or false) or false,
        onduty = playerJob and (playerJob.onduty or false) or false
    }

    local playerGang = xPlayer.PlayerData.gang
    local gangIsValid = playerGang and playerGang.name and playerGang.name ~= "none"
    if gangIsValid then
        local gangGradeData = playerGang.grade or {}
        jobInfo.gang = {
            name = playerGang.name,
            label = playerGang.label,
            grade = gangGradeData.level or 0,
            gradeLabel = gangGradeData.name,
            isboss = playerGang.isboss or false
        }
        jobInfo.isGang = true
    else
        jobInfo.gang = nil
        jobInfo.isGang = false
    end

    if not jobInfo.name and jobInfo.gang then
        jobInfo.name = jobInfo.gang.name
        jobInfo.label = jobInfo.gang.label
        jobInfo.grade = jobInfo.gang.grade
        jobInfo.gradeLabel = jobInfo.gang.gradeLabel
    end

    return jobInfo
end

function G.Server.AddMoney(src, type, amount, cb)

    if not src or not type or not amount then
        if cb then
            cb(false)
        end
        return
    end

    type = string.lower(type)
    local Player = QBox:GetPlayer(src)

    if not Player then
        if cb then
            cb(false)
        end
        return
    end

    local accountTypes = {
        cash = "cash",
        bank = "bank"
    }

    local account = accountTypes[type]
    if not account then
        if cb then
            cb(false)
        end
        return
    end

    amount = tonumber(amount) or 0
    if amount <= 0 then
        if cb then
            cb(false)
        end
        return
    end

    local success = QBox:AddMoney(src, account, amount)

    if not success then
        if cb then
            cb(false)
        end
        return
    end

    if cb then
        cb(true)
    end
end

function G.Server.isOnDuty(src)
    local Player = G.Server.GetPlayer(src)
    if not Player then
        return false
    end
    return Player.PlayerData.job.onduty or false
end

function G.Server.HasMoneyAndRemove(src, type, count)
    local Player = QBox:GetPlayer(src)
    local accountTypes = {
        cash = "cash",
        bank = "bank"
    }
    local account = accountTypes[string.lower(type)]

    count = tonumber(count)
    if not Player or not account or not count or count <= 0 then
        return false
    end

    local playerMoney = Player.Functions.GetMoney(account)
    if playerMoney and playerMoney >= count then
        QBox:RemoveMoney(src, account, count)
        return true
    end

    return false
end

function G.Server.GetPlayerFromIdentifier(identifier)
    local Player = QBox:GetPlayerByCitizenId(identifier)
    if Player then
        return Player.PlayerData.source
    end
    return nil
end

function G.Server.IsPlateTaken(plate)
    local res = MySQL.query.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if res and res[1] then
        return true
    end

    local bossRes = MySQL.query.await('SELECT * FROM g_bossmenu_job_ownable_vehicles WHERE vehPlate = ?', {plate})
    return bossRes and bossRes[1] ~= nil
end

local function RandomInt(length)
    local min = 10 ^ (length - 1)
    local max = (10 ^ length) - 1
    return tostring(math.random(min, max))
end

local function RandomStr(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local randIndex = math.random(1, #chars)
        result = result .. chars:sub(randIndex, randIndex)
    end
    return result
end

function G.Server.GeneratePlate()
    local plate = RandomInt(1) .. RandomStr(2) .. RandomInt(3) .. RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return G.Server.GeneratePlate()
    else
        return plate:upper()
    end
end

function G.Server.AddVehicleToFrameworkGarage(src, data)
    local player = QBox:GetPlayer(src)
    if not player then
        return false
    end

    local citizenid = player.PlayerData.citizenid
    local parking = Config.BossMenuSettings.defaultParking or "default"
    local plate = G.Server.GeneratePlate()
    local modelHash = GetHashKey(data.model)

    local defaultVehicleData = {
        wheels = 1,
        neonEnabled = {false, false, false, false},
        pearlescentColor = 7,
        modHorns = -1,
        modBackWheels = -1,
        modNitrous = -1,
        modRoof = -1,
        extras = {},
        modFrame = -1,
        windowTint = -1,
        tyres = {},
        doors = {},
        color2 = 120,
        modSuspension = -1,
        modCustomTiresR = false,
        neonColor = {255, 0, 255},
        modHydraulics = false,
        modSmokeEnabled = false,
        modVanityPlate = -1,
        modSteeringWheel = -1,
        tyreSmokeColor = {255, 255, 255},
        modTrunk = -1,
        engineHealth = 995,
        modTransmission = -1,
        modRoofLivery = -1,
        modCustomTiresF = false,
        modOrnaments = -1,
        tankHealth = 1000,
        modArmor = -1,
        modDial = -1,
        modSpeakers = -1,
        modGrille = -1,
        modLightbar = -1,
        modSideSkirt = -1,
        modFender = -1,
        oilLevel = 5,
        modAerials = -1,
        modPlateHolder = -1,
        modDoorSpeaker = -1,
        modFrontWheels = -1,
        modFrontBumper = -1,
        color1 = 7,
        modEngine = -1,
        fuelLevel = 64,
        livery = -1,
        paintType2 = 7,
        modAirFilter = -1,
        modStruts = -1,
        dirtLevel = 8,
        modEngineBlock = -1,
        modDashboard = -1,
        interiorColor = 2,
        modBrakes = -1,
        modTank = -1,
        modLivery = -1,
        modArchCover = -1,
        modDoorR = -1,
        modRightFender = -1,
        plate = plate,
        bulletProofTyres = true,
        wheelWidth = 0.0,
        modTrimA = -1,
        dashboardColor = 156,
        modSpoilers = -1,
        modRearBumper = -1,
        model = modelHash,
        modWindows = -1,
        modSeats = -1,
        modSubwoofer = -1,
        modHydrolic = -1,
        modShifterLeavers = -1,
        paintType1 = 7,
        windows = {2, 3, 4, 5},
        wheelColor = 0,
        modExhaust = -1,
        modHood = -1,
        wheelSize = 0.0,
        bodyHealth = 1000,
        driftTyres = false,
        modTrimB = -1,
        modXenon = false,
        plateIndex = 0,
        modTurbo = false,
        xenonColor = 255,
        modAPlate = -1
    }

    local vehicleDataJson = json.encode(defaultVehicleData)

    local query
    local params
    if PlayerVehiclesSupportsTypeColumn() then
        query = [[
           INSERT INTO player_vehicles (`license`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`, `garage`, `type`)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
       ]]
        params = {player.PlayerData.license, citizenid, data.model, modelHash, vehicleDataJson, plate, 1, parking,
                  data.type or "car"}
    else
        query = [[
           INSERT INTO player_vehicles (`license`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`, `garage`)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?)
       ]]
        params = {player.PlayerData.license, citizenid, data.model, modelHash, vehicleDataJson, plate, 1, parking}
    end

    local insertId = MySQL.insert.await(query, params)
    if not insertId then
        print(("[g-bossmenu] Failed to insert vehicle for %s (%s)"):format(citizenid, plate))
        return false
    end

    return plate
end

function G.Server.DeleteVehicleFromFrameworkGarage(plate)
    local affected = MySQL.update.await('DELETE FROM player_vehicles WHERE plate = ?', {plate})
    return affected and affected > 0
end
