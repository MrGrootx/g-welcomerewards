Utils = {}

function Utils.isPlayerNearLocation(source, coords, distance)
    local ped = GetPlayerPed(source)

    if not ped or ped == 0 then
        return false
    end

    local playerCoords = GetEntityCoords(ped)

    local targetCoords = vector3(
        coords.x or coords[1],
        coords.y or coords[2],
        coords.z or coords[3]
    )

    local dist = #(playerCoords - targetCoords)

    return dist <= (distance or 3.0)
end