---@diagnostic disable: duplicate-set-field
if GetResourceState("origen_inventory") ~= "started" then
    return
end

G.Inventory = {}

function G.Inventory.GetReceiptID(src, item)
    if not src or not item then return nil end
    return item.metadata and item.metadata.receiptId
end

function G.Inventory.AddItem(src, item, count, md)
    if not src or not item or not count then
        return false
    end

    if not exports.origen_inventory:canCarryItem(src, item, 1) then
        return false
    end

    local metadata = type(md) == "table" and md or (md and { receiptId = md } or false)

    local success, response = exports.origen_inventory:addItem(src, item, count, metadata)

    return success, response
end

function G.Inventory.HasItem(src, item, count)
    if not src or not item then return false end
    count = count or 1

    local found = exports.origen_inventory:getItem(src, item, false, true)
    return found and found >= count
end
