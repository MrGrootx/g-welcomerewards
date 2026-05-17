---@diagnostic disable: duplicate-set-field
if GetResourceState("qb-target") ~= "started" then
	return
end

Target = {}
Target.AddTargetBoxZone = function(name, coords, size, heading, options, debug)
	if GetResourceState("qb-target") ~= "started" or type(options) ~= "table" then
		return
	end
	for k, v in pairs(options) do
		options[k].action = v.onSelect
	end

	exports["qb-target"]:AddBoxZone(name, coords, size, size, {
		name = name,
		debugPoly = debug,
		heading = heading,
		minZ = coords.z - (size * 0.5),
		maxZ = coords.z + (size * 0.5),
	}, {
		options = options,
		distance = 1.5,
	})
end

Target.RemoveZone = function(id)
	exports["qb-target"]:RemoveZone(id)
end

Target.AddLocalEntity = function(entity, options, debug)
	for k, v in pairs(options) do
		options[k].action = v.onSelect
	end
	exports['qb-target']:AddTargetEntity(entity, {
		options = options,
		distance = 2.0,
	})
end

Target.RemoveLocalEntity = function(entity)
	exports['qb-target']:RemoveTargetEntity(entity)
end