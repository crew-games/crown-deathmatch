function invincibleMe (attacker, weapon, bodypart)
	if getElementData(localPlayer, "emitter:fireResistance") and (weapon == 37) then --if the weapon used was the minigun
		cancelEvent() --cancel the event
	end
end
addEventHandler ("onClientPlayerDamage", localPlayer, invincibleMe)