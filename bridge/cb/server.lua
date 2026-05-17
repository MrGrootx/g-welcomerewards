G = G or {}
G.Callbacks = G.Callbacks or {}
G.Callbacks.Server = {}

local _serverCallbacks = {}
local _clientRequests = {}
local _requestId = 0

--- Register a server-side callback
---@param eventName string
---@param handler fun(source: number, cb: function, ...): void
function G.Callbacks.Server.Register(eventName, handler)
	_serverCallbacks[eventName] = handler
end

--- Internal: Handles client -> server callback invocation
RegisterNetEvent(
	("%s:triggerServerCallback"):format(GetCurrentResourceName()),
	function(eventName, requestId, invoker, ...)
		if not _serverCallbacks[eventName] then
			return print(
				("[^1ERROR^7] Server callback ^5%s^7 not registered (invoked by: ^5%s^7)"):format(eventName, invoker)
			)
		end

		local src = source
		_serverCallbacks[eventName](src, function(...)
			TriggerClientEvent(("%s:serverCallback"):format(GetCurrentResourceName()), src, requestId, invoker, ...)
		end, ...)
	end
)

--- Trigger a callback on the client
---@param player number
---@param eventName string
---@param cb function
---@param ... any
function G.Callbacks.Server.TriggerClient(player, eventName, cb, ...)
	_clientRequests[_requestId] = cb

	TriggerClientEvent(
		("%s:triggerClientCallback"):format(GetCurrentResourceName()),
		player,
		eventName,
		_requestId,
		GetInvokingResource() or "unknown",
		...
	)

	_requestId = _requestId + 1
end

--- Internal: Handles client -> server response to a triggered client callback
RegisterNetEvent(("%s:clientCallback"):format(GetCurrentResourceName()), function(requestId, invoker, ...)
	if not _clientRequests[requestId] then
		return print(
			("[^1ERROR^7] Client callback with ID ^5%s^7 was called by ^5%s^7 but doesn't exist."):format(
				requestId,
				invoker
			)
		)
	end

	_clientRequests[requestId](...)
	_clientRequests[requestId] = nil
end)
