_1stPlayer = createPed(253, 2036.4870605469, -1438.2783203125, 19.455863952637)
setElementFrozen(_1stPlayer, true)
setElementRotation(_1stPlayer, 0, 0, 90)
setPedAnimation(_1stPlayer, "PARK", "Tai_Chi_Loop", -1, true, false, false)
setElementData(_1stPlayer, "datas", {
	charactername = "Pala_Guzman",
	kills = 21471,
	deaths = 4220
})

_2ndPlayer = createPed(134, 2036.9870605469, -1435.8, 19.455863952637)
setElementFrozen(_2ndPlayer, true)
setElementRotation(_2ndPlayer, 0, 0, 90)
setPedAnimation(_2ndPlayer, "BSKTBALL", "BBALL_def_loop", -1, true, false, false)
setElementData(_2ndPlayer, "datas", {
	charactername = "Loki_Guzman",
	kills = 16822,
	deaths = 8593
})

_3rdPlayer = createPed(134, 2036.9870605469, -1440.6783203125, 19.455863952637)
setElementFrozen(_3rdPlayer, true)
setElementRotation(_3rdPlayer, 0, 0, 90)
setPedAnimation(_3rdPlayer, "SHOP", "ROB_Loop_Threat", -1, true, false, false)
setElementData(_3rdPlayer, "datas", {
	charactername = "Mulayim_El_Guzman",
	kills = 16664,
	deaths = 4271
})

datas = {}

setTimer(function()
	if (getElementData(localPlayer, "loggedin") == 1) then
		if _1stPlayer or _2ndPlayer or _3rdPlayer then
			local cameraX, cameraY, cameraZ = getCameraMatrix(localPlayer)
			for index, ped in pairs({ _1stPlayer, _2ndPlayer, _3rdPlayer }) do
				if isElement(ped) then
					local boneX, boneY, boneZ = getPedBonePosition(ped, 6)
					boneZ = boneZ + 0.15
					
					local distance = math.sqrt((cameraX - boneX) ^ 2 + (cameraY - boneY) ^ 2 + (cameraZ - boneZ) ^ 2)
					local alpha = distance >= 20 and math.max(0, 255 - (distance * 7)) or 255
					
					if (distance <= 30) and (isElementOnScreen(ped)) and (isLineOfSightClear(cameraX, cameraY, cameraZ, boneX, boneY, boneZ, true, false, false, true, false, false, false, localPlayer)) and (getElementAlpha(ped) >= 200) then
						local screenX, screenY = getScreenFromWorldPosition(boneX, boneY, boneZ)
						
						if screenX and screenY then
							if index == 1 then
								color = "#FEE101"
								outlineColor = "#CCB400"
							elseif index == 2 then
								color = "#D7D7D7"
								outlineColor = "#A3A3A3"
							elseif index == 3 then
								color = "#A77044"
								outlineColor = "#734E2F"
							end
							
							dxDrawBorderedText(2, exports.cr_ui:rgba(outlineColor, alpha / 255), index, screenX, 0, screenX, screenY, exports.cr_ui:rgba(color, alpha / 255), 1, seasonFonts.season6_nametag, "center", "bottom", false, true, false, true)
						end
					end
				end
				
				if isElement(ped) then
					local boneX, boneY, boneZ = getPedBonePosition(ped, 2)
					local distance = math.sqrt((cameraX - boneX) ^ 2 + (cameraY - boneY) ^ 2 + (cameraZ - boneZ) ^ 2)
					local alpha = distance >= 20 and math.max(0, 255 - (distance * 7)) or 255
					
					if (distance <= 30) and (isElementOnScreen(ped)) and (isLineOfSightClear(cameraX, cameraY, cameraZ, boneX, boneY, boneZ, true, false, false, true, false, false, false, localPlayer)) and (getElementAlpha(ped) >= 200) then
						local screenX, screenY = getScreenFromWorldPosition(boneX, boneY, boneZ)
						
						if screenX and screenY then
							local datas = getElementData(ped, "datas")
							if datas then
								dxDrawText((datas.charactername):gsub("_", " ") .. "\nÖldürme: " .. datas.kills .. "\nÖlme: " .. datas.deaths, screenX, 0, screenX, screenY, exports.cr_ui:rgba(theme.GRAY[100], alpha / 255), 0.9, "default", "center", "bottom", false, true, false, true)
							end
						end
					end
				end
			end
		end
	end
end, 5, 0)