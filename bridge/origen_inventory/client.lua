---@diagnostic disable: duplicate-set-field
if GetResourceState("origen_inventory") ~= "started" then
	return
end

Wait(100)
G.Inventory = {}
G.Inventory.inventoryPath = "origen_inventory/html/img/"
G.Inventory.Name = "origen_inventory"
