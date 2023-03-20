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
            TriggerClientEvent('xqskolczatka', source)
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
            TriggerClientEvent('xqspacholek', source)
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
            TriggerClientEvent('xqsbarierka', source)
			xPlayer.removeInventoryItem('barierka', 1)
		else
			TriggerClientEvent('esx:showNotification', source, "Nie masz przy sobie barierki")
    	end
    end)
end

RegisterServerEvent('xqs_kolczatki:dodaj')
AddEventHandler('xqs_kolczatki:dodaj', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
    print(item)
    if item == 'kolczatka' then
	xPlayer.addInventoryItem('kolczatka', 1)
    elseif item == 'pacholek' then
    xPlayer.addInventoryItem('pacholek', 1)
	print('x11')
    elseif item == 'barierka' then
    xPlayer.addInventoryItem('barierka', 1)
    else
    DropPlayer(xPlayer, 'tak to nie byczq')
    end
end)
