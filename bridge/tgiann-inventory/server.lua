---@diagnostic disable: duplicate-set-field
if GetResourceState("tgiann-inventory") ~= "started" then
    return
end

G.Inventory = {}

function G.Inventory.GetReceiptID(src, item)
    if not src or not item then
        return nil
    end
    return item.info and item.info.receiptId
end

function G.Inventory.AddItem(src, item, count, md)
    if not src or not item or not count then
        return false
    end

    if not exports["tgiann-inventory"]:CanCarryItem(src, item, count) then
        return false
    end

    local metadata = type(md) == "table" and md or (md and {
        receiptId = md
    } or false)

    local success, response = exports["tgiann-inventory"]:AddItem(src, item, count, nil, metadata, false)

    return success, response
end

function G.Inventory.HasItem(src, items, count, md)
    if not src or not items then
        return false
    end
    count = count or 1

    local hasItem = exports["tgiann-inventory"]:HasItem(src, items, count, md)

    return hasItem or false
end
