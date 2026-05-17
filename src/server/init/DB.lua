---@diagnostic disable: undefined-global
local function tableExists(name)
	local result = MySQL.query.await("SHOW TABLES LIKE ?", { name })
	return result and #result > 0
end

CreateThread(function()
	if not Config.AutoImportSQL then
		return
	end

end)