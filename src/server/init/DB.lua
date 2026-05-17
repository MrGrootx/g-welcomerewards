---@diagnostic disable: undefined-global
local function tableExists(name)
	local result = MySQL.query.await("SHOW TABLES LIKE ?", { name })
	return result and #result > 0
end

CreateThread(function()
	if not Config.AutoImportSQL then
		return
	end

	if not tableExists("g_welcome_rewards") then
		MySQL.query.await([[
			CREATE TABLE IF NOT EXISTS `g_welcome_rewards` (
				`id` INT NOT NULL AUTO_INCREMENT,
				`identifier` VARCHAR(80) NOT NULL UNIQUE,
				`claimed_items` TINYINT(1) NOT NULL DEFAULT 0,
				`claimed_vehicle` TINYINT(1) NOT NULL DEFAULT 0,
				`claimed_items_at` TIMESTAMP NULL DEFAULT NULL,
				`claimed_vehicle_at` TIMESTAMP NULL DEFAULT NULL,
				PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
		]])
	end
end)
