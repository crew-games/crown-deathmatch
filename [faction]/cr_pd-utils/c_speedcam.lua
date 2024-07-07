function createSpeedcam ()
	if getElementData(localPlayer, "speedradar_chat") == false and not speedcamMeter then
	speedFont = guiCreateFont("speedcam/digital-7.ttf", 28)

	speedcamMeter = guiCreateStaticImage(0.74, 0.8, 0.25, 0.13, "speedcam/gps.png", true)
	targetSpeed = guiCreateLabel(0.16, 0.37, 0.21, 0.25, "0", true, speedcamMeter)
	setSpeed = guiCreateLabel(0.41, 0.37, 0.21, 0.25, "", true, speedcamMeter)
	allowedSpeed = guiCreateLabel(0.67, 0.37, 0.21, 0.25, "", true, speedcamMeter)
	vehicleInfo = guiCreateLabel(5, 0.72, 0.8, 0.25, "Bilinmiyor", true, speedcamMeter)
	
	guiSetFont(targetSpeed, speedFont) 
	guiSetFont(setSpeed, speedFont) 
	guiSetFont(allowedSpeed, speedFont)
	guiSetFont(vehicleInfo, "default-bold-small")
	
	guiLabelSetColor (targetSpeed, 255, 168, 8)
	guiLabelSetColor (setSpeed, 242, 54, 42)
	guiLabelSetColor (allowedSpeed, 3, 209, 137)
	
	guiLabelSetHorizontalAlign(vehicleInfo, "center")
	
	triggerEvent("getData", localPlayer)
	addEventHandler("onClientRender", root, getAllData)
	end
end
addEvent("speedcamON", true)
addEventHandler("speedcamON", root, createSpeedcam)

function getAllData ()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	local ownSpeedValue = exports.cr_global:getVehicleVelocity(vehicle, localPlayer)
	local setSpeedValue = getElementData(localPlayer, "speedcamera:setSpeed")
	local setTargetValue = getElementData(localPlayer, "speedcamera:targetSpeed")
	local vehicleBrand = getElementData(localPlayer, "speedcamera:vehicleName")
	local vehicleColor = getElementData(localPlayer, "speedcamera:vehicleColor")
	local vehicleDirection = getElementData(localPlayer, "speedcamera:vehicleDirection")
	local vehicleTopSpeed = getElementData(localPlayer, "speedcamera:targetTopSpeed") 
	
	guiSetText(targetSpeed, setTargetValue)
	guiSetText(allowedSpeed, math.floor(ownSpeedValue))
	guiSetText(setSpeed, vehicleTopSpeed)
	guiSetText(vehicleInfo, "" .. string.gsub(vehicleColor, "^%l", vehicleColor.upper) .. " | " .. vehicleBrand .. " | " .. string.gsub(vehicleDirection, "^%l", vehicleDirection.upper))
	
	if getElementData(localPlayer, "speedradar_chat") == "0" then
		triggerEvent("destroyGUI", localPlayer)
	else
		if speedcamMeter == nil then
		triggerEvent("speedcamON", localPlayer)
		end
	end
end
addEvent("getData", true)

function removeAll ()
    if isElement(speedcamMeter) then 
        destroyElement(speedcamMeter)
        speedcamMeter = nil
        removeEventHandler("onClientRender", root, getAllData)
    end
end
addEvent("destroyGUI", true)
addEventHandler("destroyGUI", localPlayer, removeAll)