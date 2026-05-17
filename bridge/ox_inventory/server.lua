---@diagnostic disable: duplicate-set-field
if GetResourceState("ox_inventory") ~= "started" then
    return;
end;

Wait(100)
G.Inventory = {};

function G.Inventory.GetReceiptID(src, item)
    if not src or not item then return nil end
    return item.metadata and item.metadata.receiptId
end

function G.Inventory.AddItem(src, item, count, md)
    if not src or not item or not count then
        return false
    end

    if not exports.ox_inventory:CanCarryItem(src, item, count) then
        return false
    end


    local metadata = type(md) == "table" and md or { receiptId = md }
    local success, response = exports.ox_inventory:AddItem(src, item, count, metadata)

    return success, response
end

function G.Inventory.HasItem(src, item, count, md)
    if not src or not item then return false end
    count = count or 1
    local found = exports.ox_inventory:Search(src, 'count', item, md)
    return found and found >= count
end
