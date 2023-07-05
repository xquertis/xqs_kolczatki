-- xquertis#8888
-- obiekty policyjne pod item

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if config.Kolczatki then
    ESX.RegisterUsableItem('kolczatka', function(source)
        xPlayer = ESX.GetPlayerFromId(source)
        item = xPlayer.getInventoryItem('kolczatka')
        count = item.count
            if item.count > 0 then
                TriggerClientEvent('xqsplace', source, 'p_ld_stinger_s')
                xPlayer.removeInventoryItem('kolczatka', 1)
            else
                TriggerClientEvent('esx:showNotification', source, "Nie masz przy sobie kolczatki")
            end
    end)
end
if config.Pacholki then
        ESX.RegisterUsableItem('pacholek', function(source)
        xPlayer = ESX.GetPlayerFromId(source)
        item = xPlayer.getInventoryItem('pacholek')
        count = item.count
            if item.count > 0 then
                TriggerClientEvent('xqsplace', source, 'prop_roadcone02a')
                xPlayer.removeInventoryItem('pacholek', 1)
            else
                TriggerClientEvent('esx:showNotification', source, "Nie masz przy sobie pachołków")
            end
    end)
end

if config.Barierki then
    ESX.RegisterUsableItem('barierka', function(source)
        xPlayer = ESX.GetPlayerFromId(source)
        item = xPlayer.getInventoryItem('barierka')
        count = item.count
            if item.count > 0 then
                TriggerClientEvent('xqsplace', source, 'prop_barrier_work05')
                xPlayer.removeInventoryItem('barierka', 1)
            else
                TriggerClientEvent('esx:showNotification', source, "Nie masz przy sobie barierki")
            end
    end)
end

RegisterServerEvent('xqs_kolczatki:dodaj')
AddEventHandler('xqs_kolczatki:dodaj', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source  = source
    if item == 'kolczatka' or item == 'pacholek' or item == 'barierka' then
        xPlayer.addInventoryItem(item, 1)
    else
        DropPlayer(_source, 'tak to nie byczq')
    end
end)
