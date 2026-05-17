---@diagnostic disable: duplicate-set-field
if GetResourceState("ox_inventory") ~= "started" then
	return;
end;

Wait(100)
G.Inventory = {};
G.Inventory.inventoryPath = "ox_inventory/web/images/";
G.Inventory.Name = "ox_inventory";
 