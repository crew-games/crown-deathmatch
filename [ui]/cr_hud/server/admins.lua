local function sortTable(a, b)
	if b[2] < a[2] then
		return true
	end

	return false
end

function showStaff(thePlayer, commandName)
	if getElementData(thePlayer, "loggedin") == 1 then
		local info = {}
		
		local managers = {}
		local admins = {}
		local supporters = {}
		
		for _, player in ipairs(getElementsByType("player")) do
			if exports.cr_integration:isPlayerManager(player) then
				managers[#managers + 1] = { player, getElementData(player, "admin_level") }
			end
		end
		table.sort(managers, sortTable)
		
		for _, player in ipairs(getElementsByType("player")) do
			if exports.cr_integration:isPlayerTrialAdmin(player) and not exports.cr_integration:isPlayerManager(player) then
				admins[#admins + 1] = { player, getElementData(player, "admin_level") }
			end
		end
		table.sort(admins, sortTable)
		
		for _, player in ipairs(getElementsByType("player")) do
			if exports.cr_integration:isPlayerSupporter(player) and not exports.cr_integration:isPlayerTrialAdmin(player) and not exports.cr_integration:isPlayerManager(player) then
				supporters[#supporters + 1] = { player, getElementData(player, "supporter_level") }
			end
		end
		table.sort(supporters, sortTable)
		
		table.insert(info, {"yönetim ekibi", 255, 255, 255, 255, 1, "title"})
		table.insert(info, {""})
		
		if #managers > 0 then
			for _, value in ipairs(managers) do
				local player = value[1]
				if (getElementData(player, "hiddenadmin") ~= 1) or (exports.cr_integration:isPlayerLeaderAdmin(thePlayer)) or (player == thePlayer) then
					if (getElementData(player, "duty_admin") == 1) then
						table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 87, 255, 111, 200, 1, "default"})
					else
						table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 88, 88, 88, 200, 1, "default"})
					end
				end
			end
		else
			table.insert(info, {" Aktif yönetim yok.", 88, 88, 88, 200, 1, "default"})
		end
		
		table.insert(info, {""})
		table.insert(info, {"yetkili ekibi", 255, 255, 255, 255, 1, "title"})
		table.insert(info, {""})
		
		if #admins > 0 then
			for _, value in ipairs(admins) do
				local player = value[1]
				if (getElementData(player, "hiddenadmin") ~= 1) or (exports.cr_integration:isPlayerLeaderAdmin(thePlayer)) or (player == thePlayer) then
					if (getElementData(player, "duty_admin") == 1) then
						table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 87, 255, 111, 200, 1, "default"})
					else
						table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 88, 88, 88, 200, 1, "default"})
					end
				end
			end
		else
			table.insert(info, {" Aktif yetkili yok.", 88, 88, 88, 200, 1, "default"})
		end
		
		table.insert(info, {""})
		table.insert(info, {"rehber ekibi", 255, 255, 255, 255, 1, "title"})
		table.insert(info, {""})
		
		if #supporters > 0 then
			for _, value in ipairs(supporters) do
				local player = value[1]
				if (getElementData(player, "hiddenadmin") ~= 1) or (exports.cr_integration:isPlayerLeaderAdmin(thePlayer)) or (player == thePlayer) then
					if (getElementData(player, "duty_supporter") == 1) then
						table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 87, 255, 111, 200, 1, "default"})
					else
						table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 88, 88, 88, 200, 1, "default"})
					end
				end
			end
		else
			table.insert(info, {" Aktif rehber yok.", 88, 88, 88, 200, 1, "default"})
		end
		
		table.insert(info, {""})

		exports.cr_hud:sendTopRightNotification(thePlayer, info, 350)
	end
end
addCommandHandler("admin", showStaff, false, false)
addCommandHandler("admins", showStaff, false, false)