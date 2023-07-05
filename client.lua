-- xquertis#8888
-- obiekty policyjne pod item

ESX = nil

local PlayerData              = {}
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	Citizen.Wait(5000)
end)

RegisterNetEvent('xqsplace')
AddEventHandler('xqsplace', function(object)
	if PlayerData.job ~= nil and PlayerData.job.name != 'police' then
			ESX.ShowNotification('Nie jesteś zatrudniony w policji')
		else
			local model     = object
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local forward   = GetEntityForwardVector(playerPed)
			local x, y, z   = table.unpack(coords + forward * 1.0)
		
				ESX.Game.SpawnObject(model, {
					x = x,
					y = y,
					z = z
				}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
		end
end)

RegisterNetEvent('nearprop')
AddEventHandler('nearprop', function(entity)
	local playerPed = PlayerPedId()
	local wiad      = 'Naciśnij ~INPUT_CONTEXT~ aby usunąć ten obiekt'
	

	if PlayerData.job ~= nil and PlayerData.job.name == 'police' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'deleteprop'
		CurrentActionMsg  = wiad
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

RegisterNetEvent('notnearprop')
AddEventHandler('notnearprop', function(entity)
	if CurrentAction == 'deleteprop' then
		CurrentAction = nil
	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work05',
		'p_ld_stinger_s'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, objCoords.x, objCoords.y, objCoords.z, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('nearprop', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity ~= nil then
				TriggerEvent('notnearprop', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, 38) and PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			if CurrentAction == 'deleteprop' then
				if GetEntityModel(CurrentActionData.entity) == GetHashKey('p_ld_stinger_s') then
					TriggerServerEvent('xqs_kolczatki:dodaj', 'kolczatka')
				elseif GetEntityModel(CurrentActionData.entity) == GetHashKey('prop_roadcone02a') then
					TriggerServerEvent('xqs_kolczatki:dodaj', 'pacholek')
				elseif GetEntityModel(CurrentActionData.entity) == GetHashKey('prop_barrier_work05') then
					TriggerServerEvent('xqs_kolczatki:dodaj', 'barierka')
				end
				DeleteEntity(CurrentActionData.entity)
			end
			CurrentAction = nil
		end
	end
end
end)