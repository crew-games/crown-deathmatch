function showStats(thePlayer, commandName, targetPlayerName)
	local showPlayer = thePlayer
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "loggedin") == 1 then
				thePlayer = targetPlayer
			else
				outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", showPlayer, 255, 0, 0, true)
                playSoundFrontEnd(showPlayer, 4)
				return
			end
		else
			return
		end
	end
	
	local isOverlayDisabled = getElementData(showPlayer, "hud:isOverlayDisabled")
	local dbid = tonumber(getElementData(thePlayer, "dbid"))
	
	local vehicles = ""
	local numvehicles = 0
	for key, value in ipairs(exports.cr_pool:getPoolElementsByType("vehicle")) do
		local owner = tonumber(getElementData(value, "owner"))
		if (owner) and (owner == dbid) then
			local id = getElementData(value, "dbid")
			vehicles = vehicles .. id .. ", "
			numvehicles = numvehicles + 1
			setElementData(value, "owner_last_login", exports.cr_datetime:now(), true)
		end
	end

	local properties = ""
	local numproperties = 0
	for key, value in ipairs(getElementsByType("interior")) do
		local interiorStatus = getElementData(value, "status")
		
		if interiorStatus[4] and interiorStatus[4] == dbid and getElementData(value, "name") then
			local id = getElementData(value, "dbid")
			properties = properties .. id .. ", "
			numproperties = numproperties + 1
			setElementData(value, "owner_last_login", exports.cr_datetime:now(), true)
		end
	end

	if (vehicles == "") then vehicles = "Yok  " end
	if (properties == "") then properties = "Yok  " end
	local hoursPlayed = getElementData(thePlayer, "hoursplayed")
	local minutesPlayed = getElementData(thePlayer, "minutesPlayed") or 0
	minutesPlayed2 = 60 - minutesPlayed
	local info = {}
	info = {
		{"kullanıcı bilgileri"},
		{""},
		{" Araçlar (" .. numvehicles .. "/" .. (getElementData(thePlayer, "max_vehicles") or 5) .. "): \n " .. string.sub(vehicles, 1, string.len(vehicles) - 2)},
		{""},
		{""},
		{" Mülkler (" .. numproperties .. "/" .. (getElementData(thePlayer, "max_interiors") or 5) .. "): \n " .. string.sub(properties, 1, string.len(properties) - 2)},
		{""},
		{""},
		{" Bu karakterinizde: " .. hoursPlayed .. " saat " .. minutesPlayed .. " dakika geçirdiniz."},
	}

	table.insert(info, {""})
	
	local money = getElementData(thePlayer, "money") or 0
	local bankMoney = getElementData(thePlayer, "bankmoney") or 0
	local balance = getElementData(thePlayer, "balance") or 0

	table.insert(info, {" Cüzdan: $" .. exports.cr_global:formatMoney(money)})
	table.insert(info, {" Bankadaki Para: $" .. exports.cr_global:formatMoney(bankMoney)})
	table.insert(info, {" Bakiye: " .. exports.cr_global:formatMoney(balance) .. " TL"})
	table.insert(info, {""})
	table.insert(info, {" Taşınan Ağırlık: " .. ("%.2f/%.2f"):format(exports.cr_items:getCarriedWeight(thePlayer), exports.cr_items:getMaxWeight(thePlayer)) .. " kg"})
	
	local charID = getElementData(thePlayer, "dbid")
	if exports.cr_vip:isPlayerVIP(charID) then
		local vip = getElementData(thePlayer, "vip") or 0
		local remainingInfo = exports.cr_vip:getVIPExpireTime(charID) or ""
		
		table.insert(info, {""})
		table.insert(info, {" VIP Seviyeniz: " .. vip})
		table.insert(info, {" Kalan Süre: " .. remainingInfo})
	end
	
	table.insert(info, {""})
	
	if not isOverlayDisabled then
		triggerClientEvent(showPlayer, "hudOverlay:drawOverlayTopRight", showPlayer, info) 
	end
end
addCommandHandler("stats", showStats, false, false)
addCommandHandler("durum", showStats, false, false)
addEvent("showStats", true)
addEventHandler("showStats", root, showStats)