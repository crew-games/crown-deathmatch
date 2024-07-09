connection = exports.cr_mysql

addEvent("bank.deposit", true)
addEventHandler("bank.deposit", root, function(amount)
	if client ~= source then
		return
	end

	if amount and tonumber(amount) then
		amount = tonumber(amount)
		if amount > 0 then
			if exports.cr_global:hasMoney(client, amount) then
				exports.cr_global:takeMoney(client, amount)
				setElementData(client, "bankmoney", getElementData(client, "bankmoney") + amount)
				outputChatBox("[!]#FFFFFF Banka hesabınıza $" .. exports.cr_global:formatMoney(amount) .. " para yatırdınız.", client, 0, 255, 0, true)
				dbExec(connection:getConnection(), "UPDATE `characters` SET `bankmoney`=? WHERE `id`=?", getElementData(client, "bankmoney"), getElementData(client, "dbid"))
			else
                triggerClientEvent(client, "atm:error", client, "Yeterli miktarda paranız bulunmuyor.")
			end
		else
            triggerClientEvent(client, "atm:error", client, "Bir şeyler ters gitti!")
		end
	else
        triggerClientEvent(client, "atm:error", client, "Lütfen geçerli bir miktar girin.")
	end
end)

addEvent("bank.withdraw", true)
addEventHandler("bank.withdraw", root, function(amount)
	if client ~= source then
		return
	end
	
	if amount and tonumber(amount) then
		amount = tonumber(amount)
		if amount > 0 then
			if getElementData(client, "bankmoney") >= amount then
				setElementData(client, "bankmoney", getElementData(client, "bankmoney") - amount)
				exports.cr_global:giveMoney(client, amount)
				outputChatBox("[!]#FFFFFF Banka hesabınızdan $" .. exports.cr_global:formatMoney(amount) .. " para çektiniz.", client, 0, 255, 0, true)
				dbExec(connection:getConnection(), "UPDATE `characters` SET `bankmoney`=? WHERE `id`=?", getElementData(client, "bankmoney"), getElementData(client, "dbid"))
			else
                triggerClientEvent(client, "atm:error", client, "Yeterli miktarda paranız bulunmuyor.")
			end
		else
            triggerClientEvent(client, "atm:error", client, "Bir şeyler ters gitti!")
		end
	else
        triggerClientEvent(client, "atm:error", client, "Lütfen geçerli bir miktar girin.")
	end
end)

addEventHandler("onResourceStart", resourceRoot, function()
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				local id = tonumber(row["id"])
				local x = tonumber(row["x"])
				local y = tonumber(row["y"])
				local z = tonumber(row["z"])

				local rotation = tonumber(row["rotation"])
				local dimension = tonumber(row["dimension"])
				local interior = tonumber(row["interior"])
				local deposit = tonumber(row["deposit"])
				local limit = tonumber(row["limit"])
				
				local object = createObject(2942, x, y, z, 0, 0, rotation)
				exports.cr_pool:allocateElement(object)
				setElementDimension(object, dimension)
				setElementInterior(object, interior)
				setElementData(object, "depositable", deposit)
				setElementData(object, "limit", limit)
				setElementData(object, "bank-operation", true)
				
				local px = x + math.sin(math.rad(-rotation)) * 0.8
				local py = y + math.cos(math.rad(-rotation)) * 0.8
				local pz = z
				
				setElementData(object, "dbid", id, true)
			end
		end
	end, connection:getConnection(), "SELECT id, x, y, z, rotation, dimension, interior, deposit, `limit` FROM atms")
end)