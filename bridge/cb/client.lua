G = {}
G.Callbacks = {}
G.Callbacks.Client = {}

local _requestId = 0
local _pendingRequests = {}
local _clientCallbacks = {}

--- Trigger a server callback and handle its result.
---@param eventName string
---@param cb function
---@param ... any
function G.Callbacks.Client.Trigger(eventName, cb, ...)
	_pendingRequests[_requestId] = cb

	TriggerServerEvent(
		("%s:triggerServerCallback"):format(GetCurrentResourceName()),
		eventName,
		_requestId,
		GetInvokingResource() or "unknown",
		...
	)

	_requestId = _requestId + 1
end

--- Internal: Called when the server responds to a client callback
RegisterNetEvent(("%s:serverCallback"):format(GetCurrentResourceName()), function(requestId, invoker, ...)
	local callback = _pendingRequests[requestId]
	if not callback then
		return print(
			("[^1ERROR^7] Server callback with ID ^5%s^7 was called by ^5%s^7 but doesn't exist."):format(
				requestId,
				invoker
			)
		)
	end

	callback(...)
	_pendingRequests[requestId] = nil
end)

--- Register a client-side callback
---@param eventName string
---@param handler function
function G.Callbacks.Client.Register(eventName, handler)
	_clientCallbacks[eventName] = handler
end

--- Internal: Called when server triggers a client callback
RegisterNetEvent(
	("%s:triggerClientCallback"):format(GetCurrentResourceName()),
	function(eventName, requestId, invoker, ...)
		local handler = _clientCallbacks[eventName]
		if not handler then
			return print(
				("[^1ERROR^7] Client callback ^5%s^7 not registered (invoked by: ^5%s^7)"):format(eventName, invoker)
			)
		end

		handler(function(...)
			TriggerServerEvent(("%s:clientCallback"):format(GetCurrentResourceName()), requestId, invoker, ...)
		end, ...)
	end
)
