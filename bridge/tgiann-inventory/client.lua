---@diagnostic disable: duplicate-set-field
if GetResourceState("tgiann-inventory") ~= "started" then
	return
end
Wait(100)
G.Inventory = {}
G.Inventory.inventoryPath = "tgiann-inventory/inventory_images/images/"
G.Inventory.Name = "tgiann-inventory"
