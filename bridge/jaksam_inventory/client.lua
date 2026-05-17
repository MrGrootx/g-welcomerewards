---@diagnostic disable: duplicate-set-field
if GetResourceState("jaksam_inventory") ~= "started" then
	return;
end;

Wait(100)
G.Inventory = {};
G.Inventory.inventoryPath = "jaksam_inventory/_images/";
G.Inventory.Name = "jaksam_inventory";
 