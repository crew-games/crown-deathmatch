local mysql = exports.cr_mysql

function startScene(thePlayer, commandName)
	if getElementData(thePlayer, "account:username") == "Farid" then
		dbQuery(function(qh)
			local result, rows, error = dbPoll(qh, -1)
			if rows > 0 and result then
				for _, player in ipairs(getElementsByType("player")) do
					if getElementData(player, "loggedin") == 1 then
						triggerClientEvent(player, "season.startScene", player, result)
					end
				end
			end
		end, mysql:getConnection(), "SELECT id, charactername, kills, deaths, skin FROM characters ORDER BY kills DESC LIMIT 3")
	end
end
--addCommandHandler("startscene", startScene, false, false)

function resetSeason(thePlayer, commandName)
	if getElementData(thePlayer, "account:username") == "Farid" then
		for _, player in ipairs(getElementsByType("player")) do
			if (getElementData(player, "loggedin") == 1) then
				setElementData(player, "kills", 0)
				setElementData(player, "deaths", 0)
				setElementData(player, "pass_type", 1)
				setElementData(player, "pass_level", 1)
				setElementData(player, "pass_xp", 0)
				exports.cr_rank:checkPlayerRank(player, false)
			end
		end
		
		for _, team in ipairs(getElementsByType("team")) do
			setElementData(team, "turf_kills", 0)
		end
		
		dbExec(mysql:getConnection(), "UPDATE characters SET x = ?, y = ?, z = ?, interior_id = 0, dimension_id = 0, kills = 0, deaths = 0, pass_type = 1, pass_level = 1, pass_xp = 0", 2034.1220703125 + math.random(3, 6), -1415.0302734375 + math.random(3, 6), 16.9921875)
		dbExec(mysql:getConnection(), "UPDATE factions SET turf_kills = 0")
	end
end
--addCommandHandler("resetseason", resetSeason, false, false)

function giveSeasonPrize(thePlayer, commandName)
	if getElementData(thePlayer, "account:username") == "Farid" then
		dbQuery(function(qh)
			local result, rows, error = dbPoll(qh, -1)
			if rows > 0 and result then
				for _, data in ipairs(result) do
					local player = getPlayerFromName(data.charactername)
					if player then
						exports.cr_global:giveMoney(player, 10000000)
					else
						dbExec(mysql:getConnection(), "UPDATE characters SET money = money + ? WHERE id = ?", 10000000, data.id)
					end
				end
			end
		end, mysql:getConnection(), "SELECT id, charactername FROM characters ORDER BY kills DESC LIMIT 100")
	end
end
--addCommandHandler("giveseasonprize", giveSeasonPrize, false, false)

addEvent("season.finishScene", true)
addEventHandler("season.finishScene", root, function()
	if client ~= source then return end
	
	fadeCamera(client, true)
	setElementPosition(client, 2034.1220703125 + math.random(3, 6), -1415.0302734375 + math.random(3, 6), 16.9921875)
	setElementInterior(client, 0)
	setElementDimension(client, 0)
	
	outputChatBox("[!]#FFFFFF Sezon 7'ye hoşgeldiniz!", client, 0, 255, 0, true)
	outputChatBox("[!]#FFFFFF Bol şanslar dileriz ve iyi eğlenceler!", client, 0, 255, 0, true)
	triggerClientEvent(client, "playSuccessfulSound", client)
end)

addCommandHandler("fariddev", function(thePlayer, commandName)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		dbQuery(function(qh, client)
			local result, rows, error = dbPoll(qh, -1)
			if rows > 0 and result then
				triggerClientEvent(client, "season.startScene", client, result)
			end
		end, {thePlayer}, mysql:getConnection(), "SELECT id, charactername, kills, deaths, skin FROM characters ORDER BY kills DESC LIMIT 3")
	end
end, false, false)