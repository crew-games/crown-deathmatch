Interaction.Interactions = {}

function addInteraction(type, model, name, image, executeFunction)
	if not Interaction.Interactions[type][model] then
		Interaction.Interactions[type][model] = {} 
	end
 
	table.insert(Interaction.Interactions[type][model], {name, image, executeFunction})
end

function getInteractions(element, durum)
	local interactions = {}
	local type = getElementType(element)
	local model = getElementModel(element)
	
	if type == "ped" then
		table.insert(interactions, {"Konuş", "icons/detector.png", 
			function(player, target)
				triggerEvent("shop.talkPed", localPlayer, element)
			end
		})
	elseif type == "vehicle" then
		if getElementData(element, "carshop") then
			table.insert(interactions, {"Satın Al ($" .. exports.cr_global:formatMoney(getElementData(element, "carshop:cost")) .. ")", "icons/trunk.png", 
				function(player, target)
					triggerServerEvent("carshop:buyCar", element, "cash")
				end
			})
		else
			table.insert(interactions, {"Araç Envanteri", "icons/trunk.png", 
				function(player, target)
					if not exports.cr_global:hasItem(player, 3, getElementData(element, "dbid")) then
						outputChatBox("[!]#FFFFFF Bu aracın envanterinin kilidini açmak için bir anahtara ihtiyacınız var.", 255, 0, 0, true)
						playSoundFrontEnd(4)
					else
						triggerServerEvent("openFreakinInventory", player, element, 500, 500)
					end
				end
			})

			table.insert(interactions, {"Kapı Kontrolü", "icons/doorcontrol.png",
				function(player, target)
					exports.cr_vehicle:fDoorControl(target)	
				end
			})

			table.insert(interactions, {"Arabanın İçine Gir", "icons/stair1.png", 
				function(player, target)
					triggerServerEvent("enterVehicleInterior", player, element)
				end
			})
			
			local leader = getElementData(localPlayer, "factionleader")
			if tonumber(leader) == 1 and ((getElementData(localPlayer, "faction") == 1) or (getElementData(localPlayer, "faction") == 3)) then
				table.insert(interactions, {"Arabayı Ara", "icons/stretcher.png", 
					function(player, target)
						triggerServerEvent("openFreakinInventory", player, element, 500, 500)
					end
				})
			end

			if (exports.cr_global:isStaffOnDuty(localPlayer) and exports.cr_integration:isPlayerLeaderAdmin(localPlayer)) then
				table.insert(interactions, {"ADM: Yenile", "icons/adm.png", 
					function(player, target)
						triggerServerEvent("vehicle-manager:respawn", player, element)
					end
				})
			end

			if (exports.cr_global:isStaffOnDuty(localPlayer) and exports.cr_integration:isPlayerGeneralAdmin(localPlayer)) then
				table.insert(interactions, {"ADM: Texture", "icons/adm.png", 
					function(player, target)
						triggerEvent("item-texture:vehtex", player, target)
					end
				})
			end
		end
	end
	
	table.insert(interactions, {"Kapat", "icons/cross_x.png",
		function()
			Interaction.Close()
		end
	})

	return interactions
end

function isFriendOf(accountID)
	for _, data in ipairs({online, offline}) do
		for k, v in ipairs(data) do
			if v.accountID == accountID then
				return true
			end
		end
	end
	return false
end