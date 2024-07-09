local render = false
local introTexts = {
    exports.cr_ui:getServerColor(2) .. "Crown#FFFFFF Deathmatch",
    "Artık bir şeyleri değiştirmenin zamanı geldi.",
    "Öyleyse başlayalım!",
    "Yeni lobimiz artık burası!"
}
local currentTextIndex = 1
local renderSeasonText = false

local seasonText = "SEZON 6"
local growingText = true

addEvent("season.startScene", true)
addEventHandler("season.startScene", root, function()
    if _1stPlayer and isElement(_1stPlayer) then
		setElementAlpha(_1stPlayer, 0)
	end
	
	if _2ndPlayer and isElement(_2ndPlayer) then
		setElementAlpha(_2ndPlayer, 0)
	end
	
	if _3rdPlayer and isElement(_3rdPlayer) then
		setElementAlpha(_3rdPlayer, 0)
	end
	
	render = true
    showChat(false)
    showCursor(false)
    fadeCamera(false)
    setElementData(localPlayer, "hud_settings", {})
	toggleAllControls(false)

    setTimer(function()
        fadeCamera(true)
        lastTick = getTickCount()

        setElementInterior(localPlayer, 0)
        setElementDimension(localPlayer, 0)
        setCameraInterior(0)
        smoothMoveCamera(1636.9836425781, -1571.6375732422, 109.45010375977, 1559.0754394531, -1621.1650390625, 71.013763427734, 1970.1391601562, -1476.2312011719, 53.020889282227, 2035.1127929688, -1413.4678955078, 10.134928703308, (#introTexts - 1) * 5900)
        
        musicSound = playSound("public/sounds/music.mp3")
        addEventHandler("onClientRender", root, renderVignette)
        addEventHandler("onClientRender", root, renderScene)
    end, 1000, 1)
end)

function renderScene()
    if not renderSeasonText then
		local nowTick = getTickCount()
		local elapsedTime = nowTick - lastTick
		local progress = elapsedTime / 5900
		
		if progress > 1 then
			if currentTextIndex == #introTexts then
				removeEventHandler("onClientRender", root, renderScene)
				return
			end

			lastTick = nowTick
			currentTextIndex = currentTextIndex + 1
			if currentTextIndex > (#introTexts - 1) then
				currentTextIndex = 1
				removeEventHandler("onClientRender", root, renderScene)
				smoothMoveCamera(1970.1391601562, -1476.2312011719, 53.020889282227, 2035.1127929688, -1413.4678955078, 10.134928703308, 2455.7299804688, 1767.5771484375, 74.021011352539, 2541.029296875, 1800.6848144531, 33.673652648926, 10000)
				setTimer(function()
					lastTick = getTickCount()
					currentTextIndex = #introTexts
					addEventHandler("onClientRender", root, renderScene)

					setTimer(function()
						stopSound(musicSound)
						fadeCamera(false, 0)

						setTimer(function()
							leadersMusicSound = playSound("public/sounds/leaders_music.mp3")
							fadeCamera(true, 2)
							smoothMoveCamera(2591.2507324219, 1823.6121826172, 167.40519714355, 2565.7453613281, 1824.1599121094, -724.26947021484, 2608.3666992188, 1823.5609130859, 17.919719696045, -2888.0173339844, 1725.8328857422, -2180.8400878906, 8000)

							setTimer(function()
								smoothMoveCamera(2608.3666992188, 1823.5609130859, 17.919719696045, -2888.0173339844, 1725.8328857422, -2180.8400878906, 2599.8078613281, 1827.4263916016, 14.506002426147, 1722.9425048828, 1817.9747314453, -474.26116943359, 6000)

								setTimer(function()
									local r, g, b = exports.cr_ui:rgbaUnpack("#A77044", 1)
									fxCreateParticle("huge_smoke", 2597.1535644531, 1827.5125732422, 13.078125, 0, 0, 1, r, g, b, 255, false, 5, 1, 1, true)
									setElementAlpha(_3rdPlayer, 255)
								end, 6000, 1)

								setTimer(function()
									smoothMoveCamera(2599.8078613281, 1827.4263916016, 14.506002426147, 1722.9425048828, 1817.9747314453, -474.26116943359, 2599.583984375, 1819.7358398438, 14.151956558228, 1742.4571533203, 1817.3542480469, -404.63989257812, 6000)

									setTimer(function()
										local r, g, b = exports.cr_ui:rgbaUnpack("#D7D7D7", 1)
										fxCreateParticle("huge_smoke", 2597.1535644531, 1819.837890625, 13.078125, 0, 0, 1, r, g, b, 255, false, 5, 1, 1, true)
										setElementAlpha(_2ndPlayer, 255)
									end, 6500, 1)

									setTimer(function()
										smoothMoveCamera(2599.583984375, 1819.7358398438, 14.151956558228, 1742.4571533203, 1817.3542480469, -404.63989257812, 2599.5795898438, 1823.7131347656, 14.151956558228, 1678.8780517578, 1820.2342529297, -393.13458251953, 6000)

										setTimer(function()
											local r, g, b = exports.cr_ui:rgbaUnpack("#FEE101", 1)
											fxCreateParticle("huge_smoke", 2597.1535644531, 1823.5, 13.078125, 0, 0, 1, r, g, b, 255, false, 5, 1, 1, true)
											setElementAlpha(_1stPlayer, 255)
										end, 7000, 1)

										setTimer(function()
											smoothMoveCamera(2599.5795898438, 1823.7131347656, 14.151956558228, 1678.8780517578, 1820.2342529297, -393.13458251953, 2608.3666992188, 1823.5609130859, 17.919719696045, -2888.0173339844, 1725.8328857422, -2180.8400878906, 9000)

											setTimer(function()
												stopSound(leadersMusicSound)
												fadeCamera(false, 0)
												setCameraMatrix(2459.5144042969, -1982.6452636719, 23.969715118408, 2392.5031738281, -1920.1370849609, -16.058067321777)

												setTimer(function()
													fadeCamera(true, 2)
													smoothMoveCamera(2578.7807617188, 1823.2401123047, 22.796480178833, 2670.4619140625, 1825.5075683594, -17.07133102417, 2463.572265625, 1822.6971435547, 72.870269775391, 2554.4992675781, 1822.5654296875, 31.249555587769, 10000)
													setTimer(function()
														addEventHandler("onClientRender", root, renderScene)
														lastTick = getTickCount()
														renderSeasonText = true
														playSound("public/sounds/intro.mp3")
														
														setTimer(function()
															seasonText = "SEZON 7"
															playSound("public/sounds/stage_ready.mp3")
															
															setTimer(function()
																fadeCamera(false, 0)
																removeEventHandler("onClientRender", root, renderScene)
																removeEventHandler("onClientRender", root, renderVignette)
																
																setTimer(function()
																	showChat(true)
																	setCameraTarget(localPlayer)
																	clearChatBox()
																	toggleAllControls(true)
																	triggerEvent("hud.loadSettings", localPlayer)
																	triggerServerEvent("season.finishScene", localPlayer)
																	render = false
																end, 4000, 1)
															end, 6000, 1)
														end, 6000, 1)
													end, 1000, 1)
												end, 3000, 1)
											end, 12500, 1)
										end, 10000, 1)
									end, 10000, 1)
								end, 10000, 1)
							end, 12000, 1)
						end, 2000, 1)
					end, 8000, 1)
				end, 10000, 1)
				return
			end
			progress = 0
		end

		local text = introTexts[currentTextIndex]
		local alpha = math.sin(progress * math.pi) * 255

		dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), 0, 0, screenSize.x + 2, screenSize.y + 2, tocolor(0, 0, 0, alpha), 1, fonts.UbuntuBold.h0, "center", "center", false, false, false, true)
		dxDrawText(text, 0, 0, screenSize.x, screenSize.y, tocolor(255, 255, 255, alpha), 1, fonts.UbuntuBold.h0, "center", "center", false, false, false, true)
    else
        local now = getTickCount()
		local elapsedTime = now - lastTick
		local progress = elapsedTime / 2000

		local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, progress, "Linear")
		
		local scale
		if growingText then
			local progress = elapsedTime / 4000
			scale = interpolateBetween(0.5, 0, 0, 1, 0, 0, progress, "Linear")
		else
			scale = 1
		end
		
		if seasonText == "SEZON 6" then
			dxDrawBorderedText(3, tocolor(177, 84, 29, alpha), seasonText, 0, 0, screenSize.x, screenSize.y, tocolor(228, 134, 43, alpha), scale, seasonFonts.season6, "center", "center")
			return
		end
		
		for i = 1, 15 do
			local glowColor = tocolor(70, 117, 153, alpha - i * 40)
			dxDrawText(seasonText:gsub("#%x%x%x%x%x%x", ""), -i, -i, screenSize.x, screenSize.y, glowColor, scale, seasonFonts.season7, "center", "center", false, false, false, true)
		end

		dxDrawText(seasonText, 0, 0, screenSize.x, screenSize.y, tocolor(116, 192, 252, alpha), scale, seasonFonts.season7, "center", "center", false, false, false, true)
    end
end

function renderVignette()
    dxDrawImage(0, 0, screenSize.x, screenSize.y, ":cr_ui/public/images/vignette.png", 0, 0, 0, tocolor(255, 255, 255, 220))
end

function isRenderScene()
    return render
end