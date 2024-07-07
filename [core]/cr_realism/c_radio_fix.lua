radio = 0
lawVehicles = { [416]=true, [433]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [470]=true, [598]=true, [596]=true, [597]=true, [599]=true, [432]=true, [601]=true }

function saveRadio(station)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if (vehicle) then
		if getVehicleOccupant(vehicle) == localPlayer or getVehicleOccupant(vehicle, 1) == localPlayer then
			if not (lawVehicles[getElementModel(vehicle)]) then
				radio = station
				triggerServerEvent("sendRadioSync", localPlayer, station)
			else
				cancelEvent()
				radio = 0
				setRadioChannel(0)
			end
		else
			cancelEvent()
		end
	end
end
addEventHandler("onClientPlayerRadioSwitch", localPlayer, saveRadio)

function syncRadio(station)
	removeEventHandler("onClientPlayerRadioSwitch", localPlayer, saveRadio)
	setRadioChannel(tonumber(station))
	addEventHandler("onClientPlayerRadioSwitch", localPlayer, saveRadio)
end
addEvent("syncRadio", true)
addEventHandler("syncRadio", root, syncRadio)
