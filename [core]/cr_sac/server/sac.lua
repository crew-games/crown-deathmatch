local protectedDatas = {
	["admin_level"] = true,
	["supporter_level"] = true,
	["vct_level"] = true,
	["mapper_level"] = true,
	["scripter_level"] = true,
	["manager"] = true,
	["money"] = true,
	["bankmoney"] = true,
	["vip"] = true,
	["balance"] = true,
	["dbid"] = true,
	["account:character:id"] = true,
	["account:id"] = true,
	["account:username"] = true,
	["account:loggedin"] = true,
	["loggedin"] = true,
	["hiddenadmin"] = true,
	["legitnamechange"] = true,
	["boxHours"] = true,
	["boxCount"] = true,
	["etiket"] = true,
	["etiket2"] = true,
	["etiket3"] = true,
	["donater"] = true,
	["youtuber"] = true,
	["dm_plus"] = true,
	["playerid"] = true,
	["itemID"] = true,
	["itemValue"] = true,
	["faction"] = true,
	["factionrank"] = true,
	["factionleader"] = true,
	["adminjailed"] = true,
	["jailtime"] = true,
	["jailtimer"] = true,
	["jailadmin"] = true,
	["jailreason"] = true,
	["minutesPlayed"] = true,
	["hoursplayed"] = true,
	["level"] = true,
	["kills"] = true,
	["deaths"] = true,
	["rank"] = true,
	["pass_type"] = true,
	["pass_level"] = true,
	["pass_xp"] = true,
	["voiceChannel"] = true,
}
local dataChangeCount = {}
local eventUsingPlayers = {}
local defaultServerEventNames = {
    onAccountDataChange = "onAccountDataChange",
    onConsole = "onConsole",
    onColShapeHit = "onColShapeHit",
    onColShapeLeave = "onColShapeLeave",
    onElementClicked = "onElementClicked",
    onElementColShapeHit = "onElementColShapeHit",
    onElementColShapeLeave = "onElementColShapeLeave",
    onElementDataChange = "onElementDataChange",
    onElementCollectionChange = "onElementDataChange",
    onElementDestroy = "onElementDestroy",
    onElementDimensionChange = "onElementDimensionChange",
    onElementInteriorChange = "onElementInteriorChange",
    onElementModelChange = "onElementModelChange",
    onElementStartSync = "onElementStartSync",
    onElementStopSync = "onElementStopSync",
    onMarkerHit = "onMarkerHit",
    onMarkerLeave = "onMarkerLeave",
    onPedDamage = "onPedDamage",
    onPedVehicleEnter = "onPedVehicleEnter",
    onPedVehicleExit = "onPedVehicleExit",
    onPedWasted = "onPedWasted",
    onPedWeaponSwitch = "onPedWeaponSwitch",
    onPickupHit = "onPickupHit",
    onPickupLeave = "onPickupLeave",
    onPickupSpawn = "onPickupSpawn",
    onPickupUse = "onPickupUse",
    onPlayerACInfo = "onPlayerACInfo",
    onPlayerBan = "onPlayerBan",
    onPlayerChangeNick = "onPlayerChangeNick",
    onPlayerChat = "onPlayerChat",
    onPlayerClick = "onPlayerClick",
    onPlayerCommand = "onPlayerCommand",
    onPlayerConnect = "onPlayerConnect",
    onPlayerContact = "onPlayerContact",
    onPlayerDamage = "onPlayerDamage",
    onPlayerJoin = "onPlayerJoin",
    onPlayerLogin = "onPlayerLogin",
    onPlayerLogout = "onPlayerLogout",
    onPlayerMarkerHit = "onPlayerMarkerHit",
    onPlayerMarkerLeave = "onPlayerMarkerLeave",
    onPlayerModInfo = "onPlayerModInfo",
    onPlayerMute = "onPlayerMute",
    onPlayerNetworkStatus = "onPlayerNetworkStatus",
    onPlayerPickupHit = "onPlayerPickupHit",
    onPlayerPickupLeave = "onPlayerPickupLeave",
    onPlayerPickupUse = "onPlayerPickupUse",
    onPlayerPrivateMessage = "onPlayerPrivateMessage",
    onPlayerQuit = "onPlayerQuit",
    onPlayerScreenShot = "onPlayerScreenShot",
    onPlayerSpawn = "onPlayerSpawn",
    onPlayerStealthKill = "onPlayerStealthKill",
    onPlayerTarget = "onPlayerTarget",
    onPlayerUnmute = "onPlayerUnmute",
    onPlayerVehicleEnter = "onPlayerVehicleEnter",
    onPlayerVehicleExit = "onPlayerVehicleExit",
    onPlayerVoiceStart = "onPlayerVoiceStart",
    onPlayerVoiceStop = "onPlayerVoiceStop",
    onPlayerWasted = "onPlayerWasted",
    onPlayerWeaponFire = "onPlayerWeaponFire",
    onPlayerWeaponSwitch = "onPlayerWeaponSwitch",
    onPlayerResourceStart = "onPlayerResourceStart",
    onResourceLoadStateChange = "onResourceLoadStateChange",
    onResourcePreStart = "onResourcePreStart",
    onResourceStart = "onResourceStart",
    onResourceStop = "onResourceStop",
    onBan = "onBan",
    onChatMessage = "onChatMessage",
    onDebugMessage = "onDebugMessage",
    onSettingChange = "onSettingChange",
    onUnban = "onUnban",
    onTrailerAttach = "onTrailerAttach",
    onTrailerDetach = "onTrailerDetach",
    onVehicleDamage = "onVehicleDamage",
    onVehicleEnter = "onVehicleEnter",
    onVehicleExit = "onVehicleExit",
    onVehicleExplode = "onVehicleExplode",
    onVehicleRespawn = "onVehicleRespawn",
    onVehicleStartEnter = "onVehicleStartEnter",
    onVehicleStartExit = "onVehicleStartExit",
    onWeaponFire = "onWeaponFire",
}

addEventHandler("onElementDataChange", root, function(theKey, oldValue, newValue)
	if protectedDatas[theKey] then
		if getElementType(source) == "player" then
			if client and client == source then
				cancelEvent(true)
				setElementData(client, theKey, oldValue)
				
				sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
				sendMessage("[SAC #1] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncudan geçersiz veri değişikliği algılandığı için sunucudan atıldı.")
				sendMessage(">> IP: " .. getPlayerIP(client))
				sendMessage(">> Serial: " .. getPlayerSerial(client))
				
				kickPlayer(client, "Shine Anti-Cheat", "SAC #1")
			elseif client and client ~= source then
				cancelEvent(true)
				setElementData(source, theKey, oldValue)
				
				sendMessage("[SAC #1.1] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncudan geçersiz veri değişikliği algılandığı için sunucudan atıldı.")
				sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
				sendMessage(">> IP: " .. getPlayerIP(source))
				sendMessage(">> Serial: " .. getPlayerSerial(source))
				
				kickPlayer(client, "Shine Anti-Cheat", "SAC #1.1")
			end
		elseif client and (getElementType(source) == "object") then
			cancelEvent(true)
			setElementData(source, theKey, oldValue)
			
			sendMessage("[SAC #1.2] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncudan objeye geçersiz veri değişikliği algılandığı için sunucudan atıldı.")
			sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
			sendMessage(">> IP: " .. getPlayerIP(client))
			sendMessage(">> Serial: " .. getPlayerSerial(client))
			
			kickPlayer(client, "Shine Anti-Cheat", "SAC #1.2")
		end
	end
	
	if (type(tonumber(theKey)) == "number") and (tonumber(theKey) >= 1 and tonumber(theKey) <= 100000) and client then
		cancelEvent(true)
		
		sendMessage("[SAC #1.3] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncudan geçersiz veri değişikliği algılandığı için sunucudan atıldı.")
		sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
		sendMessage(">> IP: " .. getPlayerIP(client))
		sendMessage(">> Serial: " .. getPlayerSerial(client))
		
		kickPlayer(client, "Shine Anti-Cheat", "SAC #1.3")
	end
	
	if client then
		if not dataChangeCount[client] then
            dataChangeCount[client] = {
                count = 1,
                timer = setTimer(function(client)
                    dataChangeCount[client] = nil
                end, 1000, 1, client)
            }
        else
            dataChangeCount[client].count = dataChangeCount[client].count + 1

            if dataChangeCount[client].count >= 400 then
				sendMessage("[SAC #1.4] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncudan geçersiz veri değişikliği algılandığı için sunucudan atıldı.")
				sendMessage(">> IP: " .. getPlayerIP(client))
				sendMessage(">> Serial: " .. getPlayerSerial(client))
				
				kickPlayer(client, "Shine Anti-Cheat", "SAC #1.4")

                dataChangeCount[client].count = 0
                if isTimer(dataChangeCount[client].timer) then
                    killTimer(dataChangeCount[client].timer)
                end
            end
        end
	end
end)

setTimer(function()
	for _, player in ipairs(getElementsByType("player")) do
		if isPedWearingJetpack(player) then
			sendMessage("[SAC #2] " .. getPlayerName(player):gsub("_", " ") .. " isimli oyuncu \"Jetpack\" kullandığı için sunucudan yasaklandı.")
			sendMessage(">> IP: " .. getPlayerIP(player))
			sendMessage(">> Serial: " .. getPlayerSerial(player))
	
			banPlayerAccount(player)
			banPlayer(player, true, false, true, "Shine Anti-Cheat", "SAC #2")
		end
	end
end, 1000, 0)

addEvent("sac.sendPlayer", true)
addEventHandler("sac.sendPlayer", root, function(sacCode, isBan, reason, ...)
	if client ~= source then return end
	if sacCode and reason then
		local args = { ... }
		
		sendMessage("[SAC #" .. sacCode .. "] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu \"" .. reason .. "\" sebebiyle sunucudan " .. (isBan and "yasaklandı" or "atıldı") .. ".")
		sendMessage(">> IP: " .. getPlayerIP(source))
		sendMessage(">> Serial: " .. getPlayerSerial(source))
		
		if sacCode == 3 then
			sendMessage(">> Kelime: `" .. tostring(args[1]) .. "`")
		elseif sacCode == 4 then
			sendMessage(">> Script: " .. tostring(args[1]))
		elseif sacCode == 5 then
			sendMessage(">> Kod:\n```" .. tostring(args[1]) .. "```")
			sendMessage(">> Kelime: `" .. tostring(args[2]) .. "`")
		elseif (sacCode == 6) or (sacCode == 9) then
			sendMessage(">> Mesaj: `" .. tostring(args[1]) .. "`")
		elseif (sacCode == 7) or (sacCode == 7.1) then
			sendMessage(">> Event: " .. tostring(args[1]))
			sendMessage(">> Limit: " .. tostring(args[2]))
			sendMessage(">> Script: " .. tostring(args[3]))
		elseif (sacCode == 8) or (sacCode == 8.1) then
			sendMessage(">> Eski Serial: " .. tostring(args[1]))
		elseif sacCode == 12 then
			sendMessage(">> Data: " .. tostring(args[1]))
			sendMessage(">> Script: " .. tostring(args[2]))
		elseif sacCode == 12 then
			sendMessage(">> Data: " .. tostring(args[1]))
			sendMessage(">> Script: " .. tostring(args[2]))
		end
		
		if isBan then
			banPlayerAccount(source)
			banPlayer(source, true, false, true, "Shine Anti-Cheat", "SAC #" .. sacCode)
		else
			kickPlayer(source, "Shine Anti-Cheat", "SAC #" .. sacCode)
		end
	end
end)

addDebugHook("preEvent", function(sourceResource, eventName, eventSource, eventClient, luaFilename, luaLineNumber, ...)
	local thePlayer = eventSource or eventClient
	if thePlayer and getElementType(thePlayer) == "player" then
		if defaultServerEventNames[eventName] then
			return
		end
		
		if not eventUsingPlayers[thePlayer] then
			eventUsingPlayers[thePlayer] = 0
		end
		
		eventUsingPlayers[thePlayer] = eventUsingPlayers[thePlayer] + 1
		
		if eventUsingPlayers[thePlayer] >= 400 then
			sendMessage("[SAC #10] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu \"Event Spam\" sebebiyle sunucudan atıldı.")
			sendMessage(">> IP: " .. getPlayerIP(thePlayer))
			sendMessage(">> Serial: " .. getPlayerSerial(thePlayer))
			sendMessage(">> Event: " .. tostring(eventName))
			sendMessage(">> Limit: " .. tostring(eventUsingPlayers[thePlayer]))
	
			kickPlayer(thePlayer, "Shine Anti-Cheat", "SAC #10")
		end
	end
end)

setTimer(function()
	for player, count in pairs(eventUsingPlayers) do
		if eventUsingPlayers[player] > 0 then
			eventUsingPlayers[player] = eventUsingPlayers[player] - 1
		end
	end
end, 150, 0)

addEventHandler("onPlayerQuit", root, function()
	if eventUsingPlayers[source] then
		eventUsingPlayers[source] = nil
	end
end)

addEventHandler("onDebugMessage", root, function(msg)
    if msg:find("but event is not added serverside") then
        local playerName = msg:match("Client %((.-)%) triggered")
        local eventName = msg:match("serverside event (.+), but event is not added serverside")
        local thePlayer = getPlayerFromName(playerName)
		
        if thePlayer then
            sendMessage("[SAC #11] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu \"Non-Event\" sebebiyle sunucudan atıldı.")
            sendMessage(">> IP: " .. getPlayerIP(thePlayer))
            sendMessage(">> Serial: " .. getPlayerSerial(thePlayer))
            sendMessage(">> Event: " .. eventName)
			
			kickPlayer(thePlayer, "Shine Anti-Cheat", "SAC #11")
        end
    end
end)

function banPlayerAccount(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		local accountID = getElementData(thePlayer, "account:id") or 0
		if accountID > 0 then
			dbExec(exports.cr_mysql:getConnection(), "UPDATE accounts SET banned = 1 WHERE id = ?", accountID)
		end
	end
end

function sendMessage(message)
    exports.cr_global:sendMessageToAdmins(message:gsub("`", ""), true)
    exports.cr_discord:sendMessage("sac-log", message)
end