---@diagnostic disable: duplicate-set-field
if GetResourceState("es_extended") ~= "started" then
    return;
end
ESX = exports.es_extended:getSharedObject();
G.Server = {};
function G.Server.GetCore()
    return ESX;
end

function G.Server.GetPlayer(src)
    return ESX.GetPlayerFromId(src);
end

function G.Server.GetPlayers()
    return ESX.GetExtendedPlayers();
end

-- AddEventHandler('esx:setJob', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     ESX.PlayerData = xPlayer.getJob();
-- end)

function G.Server.GetPlayerSources()
    local sources = {};
    for _, player in ipairs(G.Server.GetPlayers()) do
        table.insert(sources, player.source);
    end
    return sources;
end

function G.Server.GetPlayerName(src)
    local xPlayer = G.Server.GetPlayer(src);
    if xPlayer then
        return xPlayer.variables.firstName .. " " .. xPlayer.variables.lastName;
    end
    return nil;
end

function G.Server.GetIdentifier(src)
    local xPlayer = G.Server.GetPlayer(src);
    if xPlayer then
        return xPlayer.identifier;
    end
    return nil;
end

function G.Server.PlayerJobinfo(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return nil;
    end
    local j = xPlayer.getJob();
    if not j then
        return nil;
    end
    return {
        name = j.name,
        label = j.label,
        grade = j.grade,
        gradeLabel = j.grade_label,
        isGang = false
    };
end

function G.Server.AddMoney(src, type, amount, cb)
    if not src or not type or not amount then
        if cb then
            cb(false)
        end
        return
    end
    type = string.lower(type)
    local xPlayer = G.Server.GetPlayer(src)

    if not xPlayer then
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

    if account == "cash" then
        xPlayer.addMoney(amount)
    else
        xPlayer.addAccountMoney(account, amount)
    end

    if cb then
        cb(true)
    end
end

function G.Server.isOnDuty(src)
    local xPlayer = G.Server.GetPlayer(src);
    if not xPlayer then
        return false;
    end
    local job = xPlayer.getJob();
    return job and job.onDuty == true;
end

function G.Server.HasMoneyAndRemove(src, type, count)
    local xPlayer = G.Server.GetPlayer(src)
    local accountTypes = {
        cash = "money",
        bank = "bank"
    }
    local account = accountTypes[type]

    count = tonumber(count)
    if not xPlayer or not account or not count or count <= 0 then
        return false
    end

    if account == "money" then
        if xPlayer.getMoney() >= count then
            xPlayer.removeMoney(count)
            return true
        end
    else
        local acc = xPlayer.getAccount(account)
        local playerMoney = acc and acc.money or 0
        if playerMoney >= count then
            xPlayer.removeAccountMoney(account, count)
            return true
        end
    end

    return false
end

function G.Server.GetPlayerFromIdentifier(identifier)
    return ESX.GetPlayerFromIdentifier(identifier).playerId;
end

-- from esx_vehicleshop script
local Nums = {}
local Chars = {}

for i = 48, 57 do
    table.insert(Nums, string.char(i))
end
for i = 65, 90 do
    table.insert(Chars, string.char(i))
end
for i = 97, 122 do
    table.insert(Chars, string.char(i))
end
function G.Server.IsPalteTaken(plate)
    local res = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    })
    if res[1] then
        return true
    end

    local bossRes = MySQL.Sync.fetchAll('SELECT * FROM g_bossmenu_job_ownable_vehicles WHERE vehPlate = @plate', {
        ['@plate'] = plate
    })
    return bossRes[1] ~= nil
end

function G.Server.GeneratePlate()
    local generatedPlate = ""

    for _ = 1, 3 do
        generatedPlate = generatedPlate .. Chars[math.random(1, #Chars)]
    end
    generatedPlate = generatedPlate .. ' '
    for _ = 1, 3 do
        generatedPlate = generatedPlate .. Nums[math.random(1, #Nums)]
    end
    generatedPlate = string.upper(generatedPlate)

    if G.Server.IsPalteTaken(generatedPlate) then
        return G.Server.GeneratePlate()
    end
    return generatedPlate
end

function G.Server.AddVehicleToFrameworkGarage(src, data)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return false
    end

    local identifier = xPlayer.identifier
    local parking = Config.SystemSettings.defaultParking
    local plate = data.plate
    if type(plate) ~= "string" or plate == "" then
        plate = G.Server.GeneratePlate()
    end

    local query = [[
        INSERT INTO owned_vehicles (`owner`, `plate`, `vehicle`, `type`, `stored`, `parking`)
        VALUES (?, ?, ?, ?, ?, ?)
    ]]

    local params = {identifier, plate, json.encode({
        model = GetHashKey(data.model),
        plate = plate
    }), data.type, 1, parking}

    local insertId = MySQL.insert.await(query, params)
    if not insertId then
        print(("[g-bossmenu] Failed to insert owned vehicle for %s"):format(identifier))
        return false
    end

    return plate
end

function G.Server.DeleteVehicleFromFrameworkGarage(plate)
    local affected = MySQL.update.await('DELETE FROM owned_vehicles WHERE plate = ?', {plate})
    return affected and affected > 0
end
