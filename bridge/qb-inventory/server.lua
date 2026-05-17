---@diagnostic disable: duplicate-set-field
if GetResourceState("qb-inventory") ~= "started" then
    return
end

G.Inventory = {}

function G.Inventory.GetReceiptID(src, item)
    if not src or not item then return nil end
    return item.info and item.info.receiptId
end

function G.Inventory.AddItem(src, item, count, md)
    if not src or not item or not count then return false end

    local canAdd, reason = exports['qb-inventory']:CanAddItem(src, item, count)
    if not canAdd then return false, reason end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end

    local metadata = type(md) == "table" and md or { receiptId = md }
    local success = Player.Functions.AddItem(item, count, false, metadata)

    return success
end

function G.Inventory.HasItem(src, item, count)
    if not src or not item then return false end
    count = count or 1

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end

    local foundItem = Player.Functions.GetItemByName(item)
    if not foundItem then return false end

    return foundItem.amount >= count
end


