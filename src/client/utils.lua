function SendReactMessage(action, data)
	SendNUIMessage({
		action = action,
		data = data,
	})
end

local currentResourceName = GetCurrentResourceName()

local debugIsEnabled = GetConvarInt(("%s-debugMode"):format(currentResourceName), 0) == 1

function debugPrint(...)
	if not debugIsEnabled then
		return
	end
	local args <const> = { ... }

	local appendStr = ""
	for _, v in ipairs(args) do
		appendStr = appendStr .. " " .. tostring(v)
	end
	local msgTemplate = "^3[%s]^0%s"
	local finalMsg = msgTemplate:format(currentResourceName, appendStr)
	print(finalMsg)
end

-- some functions are from ox_lib

function CCreateBlip(x, y, z, idtype, idcolor, text, scale, set_route)
	if idtype ~= 0 then
		local blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip, idtype)
		SetBlipAsShortRange(blip, true)
		SetBlipColour(blip, idcolor)
		SetBlipScale(blip, scale or 0.8)
		if text and text ~= "" then
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(text)
			EndTextCommandSetBlipName(blip)
		else
			print("Warning: Blip name is empty or nil!")
		end
		if set_route then
			SetBlipRoute(blip, true)
		end
		return blip
	end
end

local function showLoadingSpinner(text)
	if BusyspinnerIsOn() then
		BusyspinnerOff()
	end

	BeginTextCommandBusyspinnerOn("STRING")
	AddTextComponentSubstringPlayerName(text or "Loading...")
	EndTextCommandBusyspinnerOn(4)
end

local function hideLoadingSpinner()
	if BusyspinnerIsOn() then
		BusyspinnerOff()
	end
end

--- Loads a vehicle model (GTA or addon/custom) and shows the native loading spinner while streaming.
function RRequestModel(model, loadingText)
	if type(model) ~= "number" then
		model = joaat(model)
	end

	if model == 0 then
		return false
	end

	if HasModelLoaded(model) then
		return model
	end

	RequestModel(model)
	showLoadingSpinner(loadingText)

	while not HasModelLoaded(model) do
		Wait(100)
	end

	hideLoadingSpinner()
	return model
end

function SStreamingRequest(request, hasLoaded, assetType, asset, timeout, ...)
	if hasLoaded(asset) then
		return asset
	end

	request(asset, ...)

	return waitFor(
		function()
			if hasLoaded(asset) then
				return asset
			end
		end,
		("failed to load %s '%s' - this may be caused by\n- too many loaded assets\n- oversized, invalid, or corrupted assets"):format(
			assetType,
			asset
		),
		timeout or 30000
	)
end

function waitFor(cb, errMessage, timeout)
	local value = cb()

	if value ~= nil then
		return value
	end

	if timeout or timeout == nil then
		if type(timeout) ~= "number" then
			timeout = 1000
		end
	end

	local start = timeout and GetGameTimer()

	while value == nil do
		Wait(0)

		local elapsed = timeout and GetGameTimer() - start

		if elapsed and elapsed > timeout then
			return error(("%s (waited %.1fms)"):format(errMessage or "failed to resolve callback", elapsed), 2)
		end

		value = cb()
	end

	return value
end
