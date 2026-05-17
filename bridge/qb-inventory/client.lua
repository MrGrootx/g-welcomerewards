---@diagnostic disable: duplicate-set-field
if GetResourceState("qb-inventory") ~= "started" then
	return
end
Wait(100)
G.Inventory = {}
G.Inventory.inventoryPath = "qb-inventory/html/images/"
G.Inventory.Name = "qb-inventory"
 
