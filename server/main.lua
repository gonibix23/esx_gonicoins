ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_gonicoins:collectBitcoin')
AddEventHandler('esx_gonicoins:collectBitcoin', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local cime = math.random(1,3)
	local ran = math.random(1, Config.ProbabilidadDeRomperDisco)
	if xPlayer.getInventoryItem('portatil').count >= 1 then 
		if xPlayer.getInventoryItem('discoduro').count >= 1 then
			if xPlayer.canCarryItem('bitcoin', cime)  then
				xPlayer.addInventoryItem('bitcoin', cime)
				if ran <= 1 then
					xPlayer.removeInventoryItem('discoduro', 1)
					xPlayer.showHelpNotification("~b~Se te ha roto un disco duro~b~", false, true, 5000)
				end
			else
				xPlayer.showHelpNotification("~b~Tienes el inventario lleno~b~", false, true, 5000)
			end
		else
			xPlayer.showHelpNotification("~b~Necesitas discos duros para almacenar los~b~ ~y~Bitcoins~ys~", false, true, 5000)
		end
	else
		xPlayer.showHelpNotification("~b~Necesitas un portatil para minar~b~ ~y~Bitcoins~ys~", false, true, 5000)
	end
end)

RegisterServerEvent('esx_gonicoins:sellBitcoin')
AddEventHandler('esx_gonicoins:sellBitcoin', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(itemName)

	if xPlayer.getInventoryItem('portatil').count >= 1 then 
		if xPlayer.getInventoryItem('discoduro').count >= 1 then
			xPlayer.addAccountMoney('black_money', Config.Precio)
    		xPlayer.removeInventoryItem(xItem.name, amount)
    		if xPlayer.getInventoryItem(itemName).count == 0 then
    		    xPlayer.showHelpNotification("~b~No te quedan~b~ ~y~Bitcoins~y~", false, true, 5000)
			end
		else
			xPlayer.showHelpNotification("~b~Necesitas los discos duros donde has almacenado los~b~ ~y~Bitcoins~ys~", false, true, 5000)
		end
	else
		xPlayer.showHelpNotification("~b~Necesitas un portatil para vender~b~ ~y~Bitcoins~ys~", false, true, 5000)
	end
end)

RegisterServerEvent('esx_gonicoins:posicionRecolecta')
AddEventHandler('esx_gonicoins:posicionRecolecta', function()

end)