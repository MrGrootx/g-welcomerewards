---@diagnostic disable: duplicate-set-field
if GetResourceState("jaksam_inventory") ~= "started" then
    return;
end

Wait(100)
G.Inventory = {};

function G.Inventory.GetReceiptID(src, item)
    if not src or not item then
        return nil
    end

    if item.receiptId then
        return item.receiptId
    end

    if item.metadata and item.metadata.receiptId then
        return item.metadata.receiptId
    end

    return nil
end

function G.Inventory.AddItem(src, item, count, md)
    if not src or not item or not count then
        return false
    end

    if not exports['jaksam_inventory']:canCarryItem(src, item, count) then
        return false
    end

    local metadata = type(md) == "table" and md or {
        receiptId = md
    }
    local success, response = exports['jaksam_inventory']:addItem(src, item, count, metadata)

    return success, response
end

function G.Inventory.HasItem(src, item, count, md)
    if not src or not item then
        return false
    end
    count = count or 1

    local totalAmount = exports['jaksam_inventory']:getTotalItemAmount(src, item)

    return totalAmount and totalAmount >= count
end
