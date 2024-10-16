﻿mysql = exports.cr_mysql

function getRealDoorType(doortype)
	if doortype == 1 or doortype == 2 then
		return doortype
	end
	return nil
end

function refreshCarShop()
	local theResource = getResourceFromName("cr_carshop")
	if theResource then
		local hiddenAdmin = getElementData(client, "hiddenadmin")
		if getResourceState(theResource) == "running" then
			restartResource(theResource)
			outputChatBox("Carshops were restarted.", client, 0, 255, 0)
			if hiddenAdmin == 0 then
				exports.cr_global:sendMessageToAdmins("[ADM] " .. exports.cr_global:getPlayerFullAdminTitle(client) .. " araç mağazalarını yeniledi.")
			else
				exports.cr_global:sendMessageToAdmins("[ADM] Gizli Yetkili araç mağazalarını yeniledi.")
			end
			exports.cr_logs:dbLog(client, 4, client, "RESETCARSHOP")
		elseif getResourceState(theResource) == "loaded" then
			startResource(theResource)
			outputChatBox("Carshops were started", client, 0, 255, 0)
			if hiddenAdmin == 0 then
				exports.cr_global:sendMessageToAdmins("[ADM] " .. exports.cr_global:getPlayerFullAdminTitle(client) .. " araç mağazalarını başlattı.")
			else
				exports.cr_global:sendMessageToAdmins("[ADM] Gizli Yetkili araç mağazalarını başlattı.")
			end
			exports.cr_logs:dbLog(client, 4, client, "RESETCARSHOP")
		elseif getResourceState(theResource) == "failed to load" then
			outputChatBox("Carshop's could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", client, 255, 0, 0)
		end
	end
end
addEvent("vehlib:refreshcarshops", true)
addEventHandler("vehlib:refreshcarshops", root, refreshCarShop)

function sendLibraryToClient(ped)
	if source then 
		client = source
	end
	
	local vehs = {}
	local mQuery1 = nil
	local preparedQ = "SELECT `spawnto`, `id`, `vehmtamodel`, `vehbrand`, `vehmodel`, `vehyear`, `vehprice`, `vehtax`, (SELECT `username` FROM `accounts` WHERE `accounts`.`id`=`vehicles_shop`.`createdby`) AS 'createdby', `createdate`, (SELECT `username` FROM `accounts` WHERE `accounts`.`id`=`vehicles_shop`.`updatedby`) AS 'updatedby', `updatedate`, `notes`, `enabled` FROM `vehicles_shop`"
	if ped and isElement(ped) then
		local shopName = getElementData(ped, "carshop")
		if shopName == "grotti" then
			preparedQ = preparedQ .. " WHERE `spawnto`='1' "
		elseif shopName == "JeffersonCarShop" then
			preparedQ = preparedQ .. " WHERE `spawnto`='2' "
		elseif shopName == "IdlewoodBikeShop" then
			preparedQ = preparedQ .. " WHERE `spawnto`='3' "
		elseif shopName == "SandrosCars" then
			preparedQ = preparedQ .. " WHERE `spawnto`='4' "
		elseif shopName == "IndustrialVehicleShop" then
			preparedQ = preparedQ .. " WHERE `spawnto`='5' "
		elseif shopName == "BoatShop" then
			preparedQ = preparedQ .. " WHERE `spawnto`='6' "
		end
	end
	preparedQ = preparedQ .. " ORDER BY `updatedate` DESC "

	mQuery1 = mysql:query(preparedQ)
	while true do
		local row = mysql:fetch_assoc(mQuery1)
		if not row then break end
		table.insert(vehs, row)
	end
	mysql:free_result(mQuery1)
	triggerClientEvent(client, "vehlib:showLibrary", client, vehs, ped)
end
addEvent("vehlib:sendLibraryToClient", true)
addEventHandler("vehlib:sendLibraryToClient", root, sendLibraryToClient)

function openVehlib(thePlayer)
	if exports.cr_integration:isPlayerVCTMember(thePlayer) or exports.cr_integration:isPlayerLeaderAdmin(thePlayer) then
		triggerEvent("vehlib:sendLibraryToClient", thePlayer)
	end
end
addCommandHandler("vehlib",openVehlib)
addCommandHandler("vehiclelibrary",openVehlib)

function createVehicleRecord(data)
	if not data then
		outputDebugString("VEHICLE MANAGER / VEHICLE LIB / createVehicleRecord / NO DATA RECIEVED FROM CLIENT")
		return false
	end
	
	local enabled = "0"
	if data.enabled then
		enabled = "1"
	end

	data.doortype = getRealDoorType(data.doortype) or 'NULL'
	
	if not data.update then
		local mQuery1 = mysql:query_insert_free("INSERT INTO vehicles_shop SET vehmtamodel='" .. toSQL(data["mtaModel"]) .. "', vehbrand='" .. toSQL(data["brand"]) .. "', vehmodel='" .. toSQL(data["model"]) .. "', vehyear='" .. toSQL(data["year"]) .. "', vehprice='" .. toSQL(data["price"]) .. "', vehtax='" .. toSQL(data["tax"]) .. "', createdby='" .. toSQL(getElementData(client, "account:id")) .. "', notes='" .. toSQL(data["note"]) .. "', enabled='" .. toSQL(enabled) .. "', `spawnto`='" .. toSQL(data["spawnto"]) .. "', `doortype` = " .. data.doortype)
		if not mQuery1 then
			outputDebugString("VEHICLE MANAGER / VEHICLE LIB / createVehicleRecord / DATABASE ERROR")
			outputChatBox("[VEHICLE MANAGER] Failed to create new vehicle #" .. mQuery1 .. " in library.", client, 255,0,0)
			return false
		end
		sendLibraryToClient(client)
		outputChatBox("[VEHICLE MANAGER] New vehicle #" .. mQuery1 .. " created in library.", client, 0,255,0)
		exports.cr_logs:dbLog(client, 6, { client }, " Created new vehicle #" .. mQuery1 .. " in library.")
		exports.cr_global:sendMessageToAdmins("[VEHICLE-MANAGER]: " .. getElementData(client, "account:username") .. " has created new vehicle #" .. mQuery1 .. " in library.")
		return true
	else
		if data.copy then
			local mQuery1 = mysql:query_insert_free("INSERT INTO vehicles_shop SET vehmtamodel='" .. toSQL(data["mtaModel"]) .. "', vehbrand='" .. toSQL(data["brand"]) .. "', vehmodel='" .. toSQL(data["model"]) .. "', vehyear='" .. toSQL(data["year"]) .. "', vehprice='" .. toSQL(data["price"]) .. "', vehtax='" .. toSQL(data["tax"]) .. "', createdby='" .. toSQL(getElementData(client, "account:id")) .. "', notes='" .. toSQL(data["note"]) .. "' , enabled='" .. toSQL(enabled) .. "', `spawnto`='" .. toSQL(data["spawnto"]) .. "', `doortype` = " .. data.doortype)
			if not mQuery1 then
				outputDebugString("VEHICLE MANAGER / VEHICLE LIB / createVehicleRecord / DATABASE ERROR")
				outputChatBox("[VEHICLE MANAGER] Failed to create new vehicle #" .. mQuery1 .. " in library.", client, 255,0,0)
				return false
			end
			sendLibraryToClient(client)
			outputChatBox("[VEHICLE MANAGER] New vehicle #" .. mQuery1 .. " created in library.", client, 0,255,0)
			exports.cr_logs:dbLog(client, 6, { client }, " Created new vehicle #" .. mQuery1 .. " in library.")
			exports.cr_global:sendMessageToAdmins("[VEHICLE-MANAGER]: " .. getElementData(client, "account:username") .. " has created new vehicle #" .. mQuery1 .. " in library.")
			return true
		else
			local mQuery1 = mysql:query_free("UPDATE vehicles_shop SET vehmtamodel='" .. toSQL(data["mtaModel"]) .. "', vehbrand='" .. toSQL(data["brand"]) .. "', vehmodel='" .. toSQL(data["model"]) .. "', vehyear='" .. toSQL(data["year"]) .. "', vehprice='" .. toSQL(data["price"]) .. "', vehtax='" .. toSQL(data["tax"]) .. "', updatedby='" .. toSQL(getElementData(client, "account:id")) .. "', notes='" .. toSQL(data["note"]) .. "', updatedate=NOW(), enabled='" .. toSQL(enabled) .. "', `spawnto`='" .. toSQL(data["spawnto"]) .. "',`doortype` = " .. data.doortype .. " WHERE id='" .. toSQL(data["id"]) .. "' ")
			if not mQuery1 then
				outputDebugString("VEHICLE MANAGER / VEHICLE LIB / UPDATEVEHICLE / DATABASE ERROR")
				outputChatBox("[VEHICLE MANAGER] Update vehicle #" .. data.id .. " from vehicle library failed.", client, 255,0,0)
				return false
			end
			sendLibraryToClient(client)
			outputChatBox("[VEHICLE MANAGER] You have updated vehicle #" .. data.id .. " from vehicle library.", client, 0,255,0)
			exports.cr_logs:dbLog(client, 6, { client }, " Updated vehicle #" .. data.id .. " from library.")
			exports.cr_global:sendMessageToAdmins("[VEHICLE-MANAGER]: " .. getElementData(client, "account:username") .. " has updated vehicle #" .. data.id .. " in library.")
			return true
		end
	end
end
addEvent("vehlib:createVehicle", true)
addEventHandler("vehlib:createVehicle", root, createVehicleRecord)

function getCurrentVehicleRecord(id)
	local row = mysql:query_fetch_assoc("SELECT * FROM vehicles_shop WHERE id = '" .. mysql:escape_string(id) .. "' LIMIT 1") or false
	if row then
		local veh = {}
		veh.id = row.id
		veh.mtaModel = row.vehmtamodel
		veh.brand = row.vehbrand
		veh.model = row.vehmodel
		veh.price = row.vehprice
		veh.tax = row.vehtax
		veh.year = row.vehyear
		veh.enabled = row.enabled
		veh.update = true
		veh.spawnto = row.spawnto
		veh.doortype = getRealDoorType(tonumber(row.doortype))
		triggerClientEvent(client, "vehlib:showEditVehicleRecord", client, veh)
	end
end
addEvent("vehlib:getCurrentVehicleRecord", true)
addEventHandler("vehlib:getCurrentVehicleRecord", root, getCurrentVehicleRecord)

function deleteVehicleFromLibraby(id)
	if not id then
		outputDebugString("VEHICLE MANAGER / VEHICLE LIB / DELETEVEHICLE / NO DATA RECIEVED FROM CLIENT")
		return false
	end
	
	local mQuery1 = mysql:query_free("DELETE FROM vehicles_shop WHERE id='" .. toSQL(id) .. "' ")
	if not mQuery1 then
		outputDebugString("VEHICLE MANAGER / VEHICLE LIB / DELETEVEHICLE / DATABASE ERROR")
		outputChatBox("[VEHICLE MANAGER] Deleted vehicle #" .. id .. " from vehicle library failed.", client, 255,0,0)
		return false
	end
	outputChatBox("[VEHICLE MANAGER] You have deleted vehicle #" .. id .. " from vehicle library.", client, 0,255,0)
	sendLibraryToClient(client)
	return true
end
addEvent("vehlib:deleteVehicle", true)
addEventHandler("vehlib:deleteVehicle", root, deleteVehicleFromLibraby)

function loadCustomVehProperties(vehID, theVehicle)
	if not vehID or not tonumber(vehID) then
		return false
	else
		vehID = tonumber(vehID)
	end
	
	if not theVehicle or not isElement(theVehicle) or not getElementType(theVehicle) == "vehicle" then
		local allVehicles = getElementsByType("vehicle")
		for i, veh in pairs (allVehicles) do
			if tonumber(getElementData(veh, "dbid")) == vehID then
				theVehicle = veh
				break
			end
		end
	end
	
	if not theVehicle then
		return false
	end
	
	local toBeSet = {} 
	local customHandlings, baseHandlings = nil, nil
	local hasCustomInfo = false
	local rowVehCustom = mysql:query_fetch_assoc("SELECT * FROM `vehicles_custom` WHERE `id` = '" .. mysql:escape_string(vehID) .. "' LIMIT 1") or false
	if rowVehCustom then
		toBeSet.brand = rowVehCustom.brand
		toBeSet.model = rowVehCustom.model
		toBeSet.year = rowVehCustom.year
		toBeSet.price = rowVehCustom.price
		toBeSet.tax = rowVehCustom.tax
		toBeSet.duration = rowVehCustom.duration
		toBeSet.doortype = getRealDoorType(tonumber(rowVehCustom.doortype))
		customHandlings = rowVehCustom.handling
		if rowVehCustom.brand and rowVehCustom.brand ~= "" then
			hasCustomInfo = true
            setElementData(theVehicle, "unique", true, true)
		end
	end
	
	local vehicleShopID = getElementData(theVehicle, "vehicle_shop_id") or 0
	if vehicleShopID and vehicleShopID ~= 0 then
		local rowVehShop = mysql:query_fetch_assoc("SELECT * FROM `vehicles_shop` WHERE `id` = '" .. mysql:escape_string(vehicleShopID) .. "' AND `enabled`='1' LIMIT 1") or false
		if rowVehShop then
			if not hasCustomInfo then
				toBeSet.brand = rowVehShop.vehbrand
				toBeSet.model = rowVehShop.vehmodel
				toBeSet.year = rowVehShop.vehyear
				toBeSet.price = rowVehShop.vehprice
				toBeSet.tax = rowVehShop.vehtax
				toBeSet.doortype = getRealDoorType(tonumber(rowVehShop.doortype))
				toBeSet.duration = rowVehShop.duration
			end
			baseHandlings = rowVehShop.handling
		end
	end
	
	setElementData(theVehicle, "vehicle_shop_id", vehicleShopID, true)
	
	if toBeSet.brand then
		setElementData(theVehicle, "brand", toBeSet.brand, true)
		setElementData(theVehicle, "maximemodel", toBeSet.model, true)
		setElementData(theVehicle, "year", toBeSet.year, true)
		setElementData(theVehicle, "carshop:cost", toBeSet.price, true)
		setElementData(theVehicle, "carshop:taxcost", toBeSet.tax, true)
		setElementData(theVehicle, "vDoorType", toBeSet.doortype, true)
	end
	
	--[[local handlings = {
		[1]={"mass", mass},
		[2]={"turnMass", turnMass},
		[3]={"dragCoeff", dragCoeff},
		[4]={"centerOfMass", centerOfMass, true},
		[5]={"percentSubmerged", percentSubmerged},
		[6]={"tractionMultiplier", tractionMultiplier},
		[7]={"tractionLoss", tractionLoss},
		[8]={"tractionBias", tractionBias},
		[9]={"numberOfGears", numberOfGears},
		[10]={"maxVelocity", maxVelocity},
		[11]={"engineAcceleration", engineAcceleration},
		[12]={"engineInertia", engineInertia},
		[13]={"driveType", driveType, false, true},
		[14]={"engineType", engineType, false, true},
		[14]={"engineType", engineType, false, true},
		[15]={"brakeDeceleration", brakeDeceleration},
		[16]={"brakeBias", brakeBias},
		[17]={"ABS", ABS},
		[18]={"steeringLock", steeringLock},
		[19]={"suspensionForceLevel", suspensionForceLevel},
		[20]={"suspensionDamping", suspensionDamping},
		[21]={"suspensionHighSpeedDamping", suspensionHighSpeedDamping},
		[22]={"suspensionUpperLimit", suspensionUpperLimit},
		[23]={"suspensionLowerLimit", suspensionLowerLimit},
		[24]={"suspensionFrontRearBias", suspensionFrontRearBias},
		[25]={"suspensionAntiDiveMultiplier", suspensionAntiDiveMultiplier},
		[26]={"seatOffsetDistance", seatOffsetDistance},
		[27]={"collisionDamageMultiplier", collisionDamageMultiplier},
		[28]={"monetary", monetary},
		[29]={"modelFlags", modelFlags},
		[30]={"handlingFlags", handlingFlags},
		[31]={"headLight", headLight, false, true},
		[32]={"tailLight", tailLight, false, true},
		[33]={"animGroup", animGroup}
	}]]
	
	local hasCustomHandling = false
	if customHandlings and type(customHandlings) == "string" then
		local h = fromJSON(customHandlings)
		if h then
			for i = 1, #handlings do 
				if i ~= 29 then -- I don't know why this isn't working in 1.4. Temporarily disable this stat / Farid
					setVehicleHandling(theVehicle, handlings[i][1], h[i] or h[tostring(i)])
				end
				--outputDebugString(h[tostring(i)])
			end
			hasCustomHandling = true
			--outputDebugString("Loaded custom handlings to veh #" .. getElementData(theVehicle, "dbid"))
		end
	end
	
	if not hasCustomHandling then
		if baseHandlings and type(baseHandlings) == "string" then
			local h = fromJSON(baseHandlings)
			if h then
				for i = 1, #handlings do 
					if i ~= 29 then -- I don't know why this isn't working in 1.4. Temporarily disable this stat / Farid
						setVehicleHandling(theVehicle, handlings[i][1], h[i] or h[tostring(i)])
					end
					--outputDebugString(handlings[i][1] .. " - " ..  h[i])
				end
			end
			--outputDebugString("Loaded base handlings to veh #" .. getElementData(theVehicle, "dbid"))
		end
	end
	
	return true
end
addEvent("vehlib:loadCustomVehProperties", true)
addEventHandler("vehlib:loadCustomVehProperties", root, loadCustomVehProperties)



function toSQL(stuff)
	return mysql:escape_string(stuff)
end

function SmallestID() -- finds the smallest ID in the SQL instead of auto increment
	local result = mysql:query_fetch_assoc("SELECT MIN(e1.id+1) AS nextID FROM vehicles_shop AS e1 LEFT JOIN vehicles_shop AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end

function giveTempVctAccess(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerSeniorAdmin(thePlayer) or exports.cr_integration:isPlayerVehicleConsultant(thePlayer) then
		if not targetPlayer then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] - Give player temporary VCT Admin.", thePlayer, 255, 194, 14)
			outputChatBox("Execute the cmd again to revoke the abilities. Abilities will be automatically gone after player relogs.", thePlayer, 200, 150, 0)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if not targetPlayer then
				outputChatBox("Player not found.",thePlayer, 255,0,0)
				return false
			end
			local logged = getElementData(targetPlayer, "loggedin")
            if (logged==0) then
				outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				return false
			end
			
			if not exports.cr_integration:isPlayerVCTMember(targetPlayer) and not exports.cr_integration:isPlayerSeniorAdmin(thePlayer) then
				outputChatBox("You can grant temporary VCT admin to a VCT member only.", thePlayer, 255, 0 , 0)
				return false
			end
			
			local dbid = getElementData(targetPlayer, "dbid")
			local hasVctAdmin = getElementData(targetPlayer, "hasVctAdmin")
			local thePlayerIdentity = exports.cr_global:getPlayerFullIdentity(thePlayer)
			local targetPlayerIdentity = exports.cr_global:getPlayerFullIdentity(targetPlayer)
			
			if not hasVctAdmin then
				if not (exports.cr_integration:isPlayerSeniorAdmin(thePlayer) or exports.cr_integration:isPlayerVehicleConsultant(thePlayer)) then
					outputChatBox("You can only revoke temporary VCT admin from someone, only Lead Admin and VCT Leader can grant someone this access.", thePlayer, 255, 0 , 0)
					return false
				end
				if setElementData(targetPlayer, "hasVctAdmin", true) then
					outputChatBox("You have given " .. targetPlayerIdentity .. " temporary VCT admin.", thePlayer, 0, 255, 0)
					outputChatBox(thePlayerIdentity .. " has given you temporary VCT admin.", targetPlayer, 0, 255, 0)
					outputChatBox("TIP: VCT Admin grants you full access to perform all tasks in VCT.", targetPlayer, 255, 255, 0)
					exports.cr_global:sendMessageToAdmins("[VCT] " .. thePlayerIdentity .. " has given " ..targetPlayerIdentity.. " temporary VCT admin.")
					exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, commandName)
				end
			else
				if setElementData(targetPlayer, "hasVctAdmin", false) then
					outputChatBox("You have revoked from " .. targetPlayerIdentity .. " temporary VCT admin.", thePlayer, 255, 0, 0)
					outputChatBox(thePlayerIdentity .. " has revoked from you temporary VCT admin.", targetPlayer, 255, 0, 0)
					exports.cr_global:sendMessageToAdmins("[VCT] " .. thePlayerIdentity .. " has revoked from " .. targetPlayerIdentity .. " temporary VCT admin.")
				end
			end
		end
	end
end
addCommandHandler ("givevctadmin", giveTempVctAccess)


function setMyEngineType(thePlayer, commandName, value)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	if not vehicle then
		outputChatBox("You are not in a vehicle", thePlayer, 255, 0, 0)
		return
	end
	local result = setVehicleHandling(vehicle, "engineType", tostring(value))
	outputChatBox("Result = " .. tostring(result), thePlayer)
end
addCommandHandler ("setenginetype", setMyEngineType)

function getMyEngineType(thePlayer, commandName)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	if not vehicle then
		outputChatBox("You are not in a vehicle", thePlayer, 255, 0, 0)
		return
	end
	local handling = getVehicleHandling(vehicle)
	outputChatBox(tostring(handling.engineType), thePlayer)
end
addCommandHandler ("getenginetype", getMyEngineType)