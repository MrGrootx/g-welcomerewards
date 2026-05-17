---@diagnostic disable: duplicate-set-field
if GetResourceState("codem-inventory") ~= "started" then
    return
end

Wait(100)
G.Inventory = {};

function G.Inventory.GetReceiptID(src, item)
    if not src or not item then
        return nil
    end
    return item.metadata and item.metadata.receiptId or item.info and item.info.receiptId
end

function G.Inventory.AddItem(src, item, count, md)
    if not src or not item or not count then
        return false
    end

    local metadata = nil
    if md then
        if type(md) == "table" then
            metadata = md
        else
            metadata = {
                receiptId = md
            }
        end
    end

    local success = exports['codem-inventory']:AddItem(src, item, count, nil, metadata)

    return success == true, nil
end

function G.Inventory.HasItem(src, item, count, md)
    if not src or not item then
        return false
    end
    count = count or 1

    local has = exports['codem-inventory']:HasItem(src, item, count)

    return has == true
end
