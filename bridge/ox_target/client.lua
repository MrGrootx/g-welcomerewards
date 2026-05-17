---@diagnostic disable: duplicate-set-field
if GetResourceState("ox_target") ~= "started" then
	return
end

local ox_target = exports.ox_target

Target = {}
Target.AddTargetBoxZone = function(_, coords, size, heading, options, debug)
	local x, y, z = coords.x, coords.y, coords.z
	local target = ox_target:addBoxZone({
		coords = vector3(x, y, z),
		rotation = heading,
		size = vector3(size, size, size),
		debug = debug,
		options = options,
	})
	return target
end

Target.RemoveZone = function(id)
	ox_target:removeZone(id)
end

Target.AddLocalEntity = function(entity, options, debug)
	exports.ox_target:addLocalEntity(entity, options)
end

Target.RemoveLocalEntity = function(entity)
	ox_target:removeLocalEntity(entity)
end