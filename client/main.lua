ESX = nil
local PlayerData = {}
local isInside = false
local isFarming = false
local collecting = false
local selling = false
local display = false
local randomNum = 0
local Zonas = {
	RecolectaBit = {x = 0,	y = 0, z = 0},
    VentaBit =	{x = 0,	y = 0, z = 0}
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('nui:on')
AddEventHandler('nui:on', function(value)
	randomNum = math.random(0, 50)
	SendNUIMessage({
		type = 'ui',
		display = true,
		randomNum = randomNum,
		tiempoFarm = Config.TiempoDeVentaYRecolecta
	})
end)

RegisterNetEvent('nui:off')
AddEventHandler('nui:off', function(value)
	SendNUIMessage({
		type = 'ui',
		display = false
	})
end)

CreateThread(function()
	Citizen.Wait(0)
	ESX.TriggerServerCallback('esx_gonicoins:positions', function(xZonas)
		Zonas.VentaBit.x = xZonas.VentaBit.x
		Zonas.VentaBit.y = xZonas.VentaBit.y
		Zonas.VentaBit.z = xZonas.VentaBit.z
		Zonas.RecolectaBit.x = xZonas.RecolectaBit.x
		Zonas.RecolectaBit.y = xZonas.RecolectaBit.y
		Zonas.RecolectaBit.z = xZonas.RecolectaBit.z
	end)
end)

CreateThread(function() --Marcadores
	while true do
		Citizen.Wait(0)
		DrawMarker(Config.MarkType, Zonas.VentaBit.x, Zonas.VentaBit.y, Zonas.VentaBit.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 80, false, true, 2, nil, nil, false)
		DrawMarker(Config.MarkType, Zonas.RecolectaBit.x, Zonas.RecolectaBit.y, Zonas.RecolectaBit.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 80, false, true, 2, nil, nil, false)
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if GetEntityHealth(PlayerPedId(-1)) <= 0 then
			isInside = false
			isFarming = false
			collecting = false
			selling = false
		end
		if isInside == false and isFarming == false then
			TriggerEvent("nui:off", true)
		end
	end
end)

CreateThread(function() --Comprobación de marcadores
	while true do
		Citizen.Wait(0)	
		isDentro()
	end
end)

CreateThread(function()
	while true do
			Citizen.Wait(Config.TiempoDeVentaYRecolecta*1000)
			if collecting == true and GetEntityHealth(PlayerPedId(-1)) > 0 then
				TriggerServerEvent('esx_gonicoins:collectBitcoin')
			end
			if selling == true and GetEntityHealth(PlayerPedId(-1)) > 0 then
				TriggerServerEvent('esx_gonicoins:sellBitcoin', "bitcoin", Config.NumeroDeBitcoinsVendes)
			end
		--Aqui tiene que ir donde te da la moneda
	end
end)

function isDentro()
	if IsPedInAnyVehicle(PlayerPedId(-1), true) == false then
		if  isFarming == false then
			if GetDistanceBetweenCoords(Zonas.RecolectaBit.x, Zonas.RecolectaBit.y, Zonas.RecolectaBit.z, GetEntityCoords(PlayerPedId(-1)).x, GetEntityCoords(PlayerPedId(-1)).y, GetEntityCoords(PlayerPedId(-1)).z, false) < 1 or GetDistanceBetweenCoords(Zonas.VentaBit.x, Zonas.VentaBit.y, Zonas.VentaBit.z, GetEntityCoords(PlayerPedId(-1)).x, GetEntityCoords(PlayerPedId(-1)).y, GetEntityCoords(PlayerPedId(-1)).z, false) < 1 then
				isInside = true
				if GetDistanceBetweenCoords(Zonas.RecolectaBit.x, Zonas.RecolectaBit.y, Zonas.RecolectaBit.z, GetEntityCoords(PlayerPedId(-1)).x, GetEntityCoords(PlayerPedId(-1)).y, GetEntityCoords(PlayerPedId(-1)).z, false) < 1 then
					ESX.ShowHelpNotification('~b~Presiona ~INPUT_CONTEXT~ para empezar a minar~b~ ~y~Bitcoins~y~')
				else
					ESX.ShowHelpNotification('~b~Presiona ~INPUT_CONTEXT~ para empezar a vender~b~ ~y~Bitcoins~y~')
				end
				if IsControlJustPressed(0, 54) then
					TriggerEvent("nui:on", true)
					if GetDistanceBetweenCoords(Zonas.RecolectaBit.x, Zonas.RecolectaBit.y, Zonas.RecolectaBit.z, GetEntityCoords(PlayerPedId(-1)).x, GetEntityCoords(PlayerPedId(-1)).y, GetEntityCoords(PlayerPedId(-1)).z, false) < 1 then
						ESX.ShowNotification("~b~Has empezado a minar~b~ ~y~Bitcoins~y~", false, true, 50)
					else
						ESX.ShowNotification("~b~Has empezado a vender~b~ ~y~Bitcoins~y~", false, true, 50)
					end
					FreezeEntityPosition(PlayerPedId(-1), true)
					spawnLaptop()
					isFarming = true
				end
			else
				collecting = false
				selling = false
				isInside = false
			end
		elseif isFarming == true then
			if IsControlJustPressed(0, 54) then
				if GetDistanceBetweenCoords(Zonas.RecolectaBit.x, Zonas.RecolectaBit.y, Zonas.RecolectaBit.z, GetEntityCoords(PlayerPedId(-1)).x, GetEntityCoords(PlayerPedId(-1)).y, GetEntityCoords(PlayerPedId(-1)).z, false) < 1 then
					ESX.ShowNotification("~b~Has dejado de minar~b~ ~y~Bitcoins~y~", false, true, 50)
				else
					ESX.ShowNotification("~b~Has dejado de vender~b~ ~y~Bitcoins~y~", false, true, 50)
				end
				DeleteObject(obj)
				TaskStartScenarioInPlace(PlayerPedId(-1), "PROP_HUMAN_SEAT_COMPUTER", 0, false)
				Citizen.Wait(1500)
				ClearPedTasksImmediately(PlayerPedId(-1))
				DeleteObject(obj1)
				PlaySound(l_208, "SELECT", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
				FreezeEntityPosition(PlayerPedId(-1), false)
				isFarming = false
				isInside = false
				collecting = false
				selling = false
				TriggerEvent("nui:off", true)
				Citizen.Wait(2000)
				do return end
			end
			if GetDistanceBetweenCoords(Zonas.RecolectaBit.x, Zonas.RecolectaBit.y, Zonas.RecolectaBit.z, GetEntityCoords(PlayerPedId(-1)).x, GetEntityCoords(PlayerPedId(-1)).y, GetEntityCoords(PlayerPedId(-1)).z, false) < 1 or GetDistanceBetweenCoords(Zonas.VentaBit.x, Zonas.VentaBit.y, Zonas.VentaBit.z, GetEntityCoords(PlayerPedId(-1)).x, GetEntityCoords(PlayerPedId(-1)).y, GetEntityCoords(PlayerPedId(-1)).z, false) < 1 then
				if GetDistanceBetweenCoords(Zonas.RecolectaBit.x, Zonas.RecolectaBit.y, Zonas.RecolectaBit.z, GetEntityCoords(PlayerPedId(-1)).x, GetEntityCoords(PlayerPedId(-1)).y, GetEntityCoords(PlayerPedId(-1)).z, false) < 1 then
					collecting = true
				elseif GetDistanceBetweenCoords(Zonas.VentaBit.x, Zonas.VentaBit.y, Zonas.VentaBit.z, GetEntityCoords(PlayerPedId(-1)).x, GetEntityCoords(PlayerPedId(-1)).y, GetEntityCoords(PlayerPedId(-1)).z, false) < 1 then
					selling = true
				end
			else
				collecting = false
				selling = false
			end
		end
	end
end

function spawnLaptop() --Generar portatil y silla
	local model = GetHashKey("prop_laptop_lester")
	local model1 = GetHashKey("prop_off_chair_03")
	RequestModel(model)
	RequestModel(model1)
	while (not HasModelLoaded(model)) do
		Wait(1)
	end
	obj = CreateObject(model, GetEntityCoords(PlayerPedId(-1)).x, GetEntityCoords(PlayerPedId(-1)).y+0.5, GetEntityCoords(PlayerPedId(-1)).z-0.1, true, false, true)
    SetModelAsNoLongerNeeded(model)
	SetEntityAsMissionEntity(obj)
	obj1 = CreateObject(model1, GetEntityCoords(PlayerPedId(-1)).x, GetEntityCoords(PlayerPedId(-1)).y, GetEntityCoords(PlayerPedId(-1)).z-1, true, false, true)
    SetModelAsNoLongerNeeded(model1)
	SetEntityAsMissionEntity(obj1)
	SetEntityCoords(PlayerPedId(-1), GetEntityCoords(PlayerPedId(-1)).x,GetEntityCoords(PlayerPedId(-1)).y,GetEntityCoords(PlayerPedId(-1)).z-1.5, false, false, false, true)
	SetEntityQuaternion(PlayerPedId(-1), 0, 0, 0, 0)
	PlaySound(l_208, "SELECT", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
	TaskStartScenarioInPlace(PlayerPedId(-1), "PROP_HUMAN_SEAT_COMPUTER", 0, true)
end