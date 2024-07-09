local mysql = exports.cr_mysql

function vipVer(thePlayer, commandName, targetPlayer, rank, days)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		if (not targetPlayer or not tonumber(rank) or not tonumber(days) or (tonumber(rank) < 0 or tonumber(rank) > 4)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Karakter Adı / ID] [1-4] [Gün]", thePlayer, 255, 194, 14)
		else
			rank = math.floor(tonumber(rank))
			days = math.floor(tonumber(days))
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") == 1 then
					local charID = getElementData(targetPlayer, "dbid")
					local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
					if not isPlayerVIP(charID) then
						local id = SmallestID()
						
						dbExec(mysql:getConnection(), "INSERT INTO `vips` (`id`, `char_id`, `vip_type`, `vip_end_tick`) VALUES (?, ?, ?, ?)", id, charID, rank, endTick)
					
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " adlı oyuncuya " .. days .. " günlük VIP [" .. rank .. "] verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " adlı yetkili size " .. days .. " günlük VIP [" .. rank .. "] verdi.", targetPlayer, 0, 255, 0, true)
						exports.cr_discord:sendMessage("vip-log", exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " adlı yetkili " .. targetPlayerName .. " adlı oyuncuya " .. days .. " günlük VIP [" .. rank .. "] verdi.")
					
						loadVIP(charID)
					else
						if rank ~= getElementData(thePlayer, "vip") then 
							outputChatBox("[!]#FFFFFF Bu oyuncuya vermeye çalıştığınız VIP [" .. rank .. "] seviyesine sahip değil.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							return
						end
						
						dbExec(mysql:getConnection(), "UPDATE `vips` SET vip_end_tick = vip_end_tick + ? WHERE char_id = ? and vip_type = ? LIMIT 1", endTick, charID, rank)
						
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " adlı oyuncunun VIP süresine " .. days .. " gün eklendi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " adlı yetkili VIP [" .. rank .. "] sürenizi " .. days .. " gün uzattı.", targetPlayer, 0, 255, 0, true)
						exports.cr_discord:sendMessage("vip-log", exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " adlı yetkili " .. targetPlayerName .. " adlı oyuncunun VIP [" .. rank .. "] süresini " .. days .. " gün uzattı.")
						
						loadVIP(charID)
					end
				else
                    outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
			end
		end
	else 
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("vipver", vipVer, false, false)

function vipAl(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		if (not targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") == 1 then
					local charID = getElementData(targetPlayer, "dbid")
					if isPlayerVIP(charID) then
						local success = removeVIP(charID)
						if success then
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " adlı oyuncunun VIP üyeliğini aldınız.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " adlı yetkili VIP üyeliğinizi aldı.", thePlayer, 255, 0, 0, true)
							exports.cr_discord:sendMessage("vip-log", exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " adlı yetkili " .. targetPlayerName .. " adlı oyuncunun VIP üyeliğini aldı.")
						end
					else
						outputChatBox("[!]#FFFFFF Bu oyuncunun VIP üyeliği yok.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
                    outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
			end
		end
	else 
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("vipal", vipAl, false, false)

function vipSure(thePlayer, commandName, targetPlayer)
	if targetPlayer then
		local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			local id = getElementData(targetPlayer, "dbid")
			
			if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
				if vips[id] then
					local vipType = vips[id].type
					local remaining = vips[id].endTick
					local remainingInfo = exports.cr_datetime:secondsToTimeDesc(remaining / 1000)
		
					return outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " adlı oyuncunun kalan VIP [" .. vipType .. "] süresi: " .. remainingInfo, thePlayer, 0, 0, 255, true)
				end
				
				outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " adlı oyuncunun VIP üyeliği yok.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			else
				outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end
	end

	local charID = getElementData(thePlayer, "dbid")
	if not charID then return false end

	if vips[charID] then
		local vipType = vips[charID].type
		local remaining = vips[charID].endTick
		local remainingInfo = exports.cr_datetime:secondsToTimeDesc(remaining / 1000)

		outputChatBox("[!]#FFFFFF Kalan VIP [" .. vipType .. "] süresi: " .. remainingInfo, thePlayer, 0, 0, 255, true)
	else
		outputChatBox("[!]#FFFFFF VIP üyeliğiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("vipsure", vipSure, false, false)