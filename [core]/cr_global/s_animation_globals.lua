function applyAnimation(thePlayer, block, name, animtime, loop, updatePosition, forced, taser)
	if animtime==nil then animtime=-1 end
	if loop==nil then loop=true end
	if updatePosition==nil then updatePosition=true end
	if forced==nil then forced=true end
	
	if isElement(thePlayer) and getElementType(thePlayer)=="player" and not getPedOccupiedVehicle(thePlayer) and getElementData(thePlayer, "freeze") ~= 1 then
		if getElementData(thePlayer, "injuriedanimation") or (not forced and not getElementData(thePlayer, "forcedanimation")==1) then
			return false
		end
		--outputDebugString(tostring(getElementData(thePlayer, "tazed")))
		if not taser and getElementData(thePlayer, "tazed") then
			return false
		end
		
		triggerEvent("bindAnimationStopKey", thePlayer)
		toggleAllControls(thePlayer, false, true, false)
		triggerClientEvent(thePlayer, "onClientPlayerWeaponCheck", thePlayer)
		if (forced) then
			setElementData(thePlayer, "forcedanimation", 1, false)
		else
			setElementData(thePlayer, "forcedanimation", 0, false)
		end
		
		local setanim = setPedAnimation(thePlayer, block, name, animtime, loop, updatePosition, false)
		if animtime > 100 then
			setTimer(setPedAnimation, 50, 2, thePlayer, block, name, animtime, loop, updatePosition, false)
		end
		if animtime > 50 then
			setElementData(thePlayer, "animationt", setTimer(removeAnimation, animtime, 1, thePlayer), false)
		end
		return setanim
	else
		return false
	end
end

function onSpawn()
	setPedAnimation(source)
	toggleAllControls(source, true, true, false)
	setElementData(source, "forcedanimation", 0, false)
	triggerClientEvent(source, "onClientPlayerWeaponCheck", source)
end
addEventHandler("onPlayerSpawn", root, onSpawn)

addEvent("onPlayerStopAnimation", true)
function removeAnimation(thePlayer, tazer)
	if isElement(thePlayer) and getElementType(thePlayer)=="player" and getElementData(thePlayer, "freeze") ~= 1 and not getElementData(thePlayer, "injuriedanimation") and not getElementData(thePlayer, "superman:flying") then
		if isTimer(getElementData(thePlayer, "animationt")) then
			killTimer(getElementData(thePlayer, "animationt"))
		end
		if not tazer and getElementData(thePlayer, "tazed") then
			return false
		end
		setElementData(thePlayer, "tazed", false, false)
		local setanim = setPedAnimation(thePlayer)
		setElementData(thePlayer, "forcedanimation", 0, false)
		setElementData(thePlayer, "animationt", 0, false)
		toggleAllControls(thePlayer, true, true, false)
		triggerClientEvent(thePlayer, "onClientPlayerWeaponCheck", thePlayer)
		setPedAnimation(thePlayer)
		setTimer(setPedAnimation, 50, 2, thePlayer)
		setTimer(triggerEvent, 100, 1, "onPlayerStopAnimation", thePlayer)
		return setanim
	else
		return false
	end
end