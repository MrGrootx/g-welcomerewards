---@diagnostic disable: duplicate-set-field
if GetResourceState("codem-inventory") ~= "started" then
    return
end

Wait(100)
G.Inventory = {};
G.Inventory.inventoryPath = "codem-inventory/html/itemimages/"
G.Inventory.Name = "codem-inventory"

