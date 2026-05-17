---@diagnostic disable: duplicate-set-field
if GetResourceState("core_inventory") ~= "started" then
	return
end

Wait(100)
G.Inventory = {}
G.Inventory.inventoryPath = "core_inventory/html/img/"
G.Inventory.Name = "core_inventory"
