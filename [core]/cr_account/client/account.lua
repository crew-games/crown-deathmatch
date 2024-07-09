local sizeX, sizeY = 250, 40
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 1.9
local clickTick = 0

local selectedPage = 1
local hidePassword = true

local rememberMeCheckbox = nil
local _rememberMe = false
local accountInfo = false

function renderAccount()
	dxDrawRectangle(0, 0, screenSize.x, screenSize.y, exports.cr_ui:rgba(theme.GRAY[900], 100))
	
	if not passedIntro then
        if not isElement(introMusic) then
            introMusic = playSound("public/sounds/intro.mp3")
        end
        renderIntro()
        return
    end
	
	dxDrawImage((screenSize.x - 150) / 2, screenY - 230, 150, 150, ":cr_ui/public/images/logo.png", 0, 0, 0, exports.cr_ui:getServerColor(1))
	
	if selectedPage == 1 then
		--> Kullanıcı Adı
		dxDrawRectangle(screenX, screenY - 55, sizeX, sizeY, exports.cr_ui:rgba(theme.GRAY[900]))
		
		local linesR, linesG, linesB = exports.cr_ui:rgbaUnpack(theme.GRAY[700], 1)
        exports.cr_ui:dxDrawGradient(screenX, screenY - 55, sizeX, 1, linesR, linesG, linesB, 255, false, true)
        exports.cr_ui:dxDrawGradient(screenX, screenY - 55, 1, sizeY, linesR, linesG, linesB, 255, true, true)
        exports.cr_ui:dxDrawGradient(screenX - 1, screenY - 55 + sizeY, sizeX, 1, linesR, linesG, linesB, 255, false, false)
        exports.cr_ui:dxDrawGradient(screenX + sizeX - 1, screenY - 55, 1, sizeY, linesR, linesG, linesB, 255, true, false)
		
		dxDrawText(textBoxes["login_username"][2] and textBoxes["login_username"][1] or "Kullanıcı Adı", screenX + 15, screenY - 43, nil, nil, selectedTextBox == "login_username" and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.UbuntuRegular.body)
		
		if exports.cr_ui:inArea(screenX, screenY - 55, sizeX, sizeY) then
			exports.cr_cursor:setCursor("all", "ibeam")
			if not loading and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selectedTextBox = "login_username"
				textBoxes[selectedTextBox][1] = ""
				textBoxes[selectedTextBox][2] = true
			end
		end
		
		--> Şifre
		dxDrawRectangle(screenX, screenY - 5, sizeX, sizeY, exports.cr_ui:rgba(theme.GRAY[900]))
		
		local linesR, linesG, linesB = exports.cr_ui:rgbaUnpack(theme.GRAY[700], 1)
        exports.cr_ui:dxDrawGradient(screenX, screenY - 5, sizeX, 1, linesR, linesG, linesB, 255, false, true)
        exports.cr_ui:dxDrawGradient(screenX, screenY - 5, 1, sizeY, linesR, linesG, linesB, 255, true, true)
        exports.cr_ui:dxDrawGradient(screenX - 1, screenY - 5 + sizeY, sizeX, 1, linesR, linesG, linesB, 255, false, false)
        exports.cr_ui:dxDrawGradient(screenX + sizeX - 1, screenY - 5, 1, sizeY, linesR, linesG, linesB, 255, true, false)
		
		dxDrawText(hidePassword and (textBoxes["login_password"][2] and string.rep("*", #textBoxes["login_password"][1]) or "Şifre") or (textBoxes["login_password"][2] and textBoxes["login_password"][1] or "Şifre"), screenX + 15, screenY + 7, nil, nil, selectedTextBox == "login_password" and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.UbuntuRegular.body)
		dxDrawText(hidePassword and "" or "", screenX + sizeX - 20, screenY + 8, nil, nil, tocolor(255, 255, 255, 200), 1, iconFont, "center")
		
		if exports.cr_ui:inArea(screenX + sizeX - 40, screenY + 7, 30, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not loading then
			clickTick = getTickCount()
			hidePassword = not hidePassword
		end
		
		if exports.cr_ui:inArea(screenX, screenY - 5, sizeX - 35, sizeY) then
			exports.cr_cursor:setCursor("all", "ibeam")
			if not loading and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selectedTextBox = "login_password"
				textBoxes[selectedTextBox][1] = ""
				textBoxes[selectedTextBox][2] = true
			end
		end
		
		--> Beni Hatırla
		rememberMeCheckbox = exports.cr_ui:drawCheckbox({
            position = {
                x = screenX,
                y = screenY + 41
            },
            size = 20,

            name = "account_rememberMe",
            disabled = false,
            text = "Beni Hatırla",
            helperText = {
                text = "",
                color = theme.GRAY[200],
            },

            variant = "soft",
            color = "gray",
            checked = _rememberMe,

            disabled = not loading
        })
		
		--> Giriş Yap
		dxDrawRectangle(screenX, screenY + 68, sizeX, sizeY, exports.cr_ui:inArea(screenX, screenY + 68, sizeX, sizeY) and exports.cr_ui:getServerColor(1) or exports.cr_ui:getServerColor(1, 245))
		dxDrawText("Giriş Yap", screenX + sizeX - 125, screenY + 80, nil, nil, exports.cr_ui:rgba(theme.GRAY[900]), 1, fonts.UbuntuRegular.body, "center")
		
		if exports.cr_ui:inArea(screenX, screenY + 68, sizeX, sizeY) and getKeyState("mouse1") and clickTick + 600 <= getTickCount() and not loading then
			clickTick = getTickCount()
			
			if string.match(textBoxes["login_username"][1], "['\"\\%;]") or string.match(textBoxes["login_password"][1], "['\"\\%;]") then
                textBoxes["login_username"][1] = ""
                textBoxes["login_password"][1] = ""
				exports.cr_infobox:addBox("error", "Geçersiz karakterler algılandı.")
                return
            end

            if textBoxes["login_username"][1] == "" then
                exports.cr_infobox:addBox("error", "Kullanıcı adı boş bırakılamaz.")
				return
            end

            if textBoxes["login_password"][1] == "" then
                exports.cr_infobox:addBox("error", "Şifre boş bırakılamaz.")
				return
            end

            if string.len(textBoxes["login_username"][1]) < 3 or string.len(textBoxes["login_username"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Kullanıcı adı 3 ila 32 karakter arasında olmalıdır.")
                return
            end

            if string.len(textBoxes["login_password"][1]) < 6 or string.len(textBoxes["login_password"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Şifre 6 ila 32 karakter arasında olmalıdır.")
                return
            end

            if isTransferBoxActive() then
                exports.cr_infobox:addBox("error", "Sunucu dosyaları indirilirken hesabınıza erişemezsiniz.")
                return
            end

            if isTimer(spamTimer) then
                exports.cr_infobox:addBox("error", "Art arda birden fazla işlem yaptınız, lütfen 3 saniye bekleyin.")
                return
            end

            spamTimer = setTimer(function() end, 3000, 1)
			
			loading = true
			addEventHandler("onClientRender", root, renderQueryLoading)
			triggerServerEvent("account.requestLogin", localPlayer, textBoxes["login_username"][1], textBoxes["login_password"][1])
			
			if rememberMeCheckbox.checked then
				exports.cr_json:jsonSave("account", { username = textBoxes["login_username"][1], password = textBoxes["login_password"][1], rememberMe = rememberMeCheckbox.checked }, true)
			end
		end
		
		--> Kayıt Ol
		dxDrawRectangle(screenX, screenY + 113, sizeX, sizeY, exports.cr_ui:inArea(screenX, screenY + 113, sizeX, sizeY) and exports.cr_ui:rgba(theme.GRAY[800]) or exports.cr_ui:rgba(theme.GRAY[900]))
		dxDrawText("Kayıt Ol", screenX + sizeX - 125, screenY + 124, nil, nil, exports.cr_ui:getServerColor(1), 1, fonts.UbuntuRegular.body, "center")
		
		if exports.cr_ui:inArea(screenX, screenY + 113, sizeX, sizeY) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not loading then
			clickTick = getTickCount()
			selectedPage = 2
		end
	elseif selectedPage == 2 then
		--> Kullanıcı Adı
		dxDrawRectangle(screenX, screenY - 55, sizeX, sizeY, exports.cr_ui:rgba(theme.GRAY[900]))
		
		local linesR, linesG, linesB = exports.cr_ui:rgbaUnpack(theme.GRAY[700], 1)
        exports.cr_ui:dxDrawGradient(screenX, screenY - 55, sizeX, 1, linesR, linesG, linesB, 255, false, true)
        exports.cr_ui:dxDrawGradient(screenX, screenY - 55, 1, sizeY, linesR, linesG, linesB, 255, true, true)
        exports.cr_ui:dxDrawGradient(screenX - 1, screenY - 55 + sizeY, sizeX, 1, linesR, linesG, linesB, 255, false, false)
        exports.cr_ui:dxDrawGradient(screenX + sizeX - 1, screenY - 55, 1, sizeY, linesR, linesG, linesB, 255, true, false)
		
		dxDrawText(textBoxes["register_username"][2] and textBoxes["register_username"][1] or "Kullanıcı Adı", screenX + 15, screenY - 43, nil, nil, selectedTextBox == "register_username" and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.UbuntuRegular.body)
		
		if exports.cr_ui:inArea(screenX, screenY - 55, sizeX, sizeY) then
			exports.cr_cursor:setCursor("all", "ibeam")
			if not loading and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selectedTextBox = "register_username"
				textBoxes[selectedTextBox][1] = ""
				textBoxes[selectedTextBox][2] = true
			end
		end
		
		--> Şifre
		dxDrawRectangle(screenX, screenY - 5, sizeX, sizeY, exports.cr_ui:rgba(theme.GRAY[900]))
		
		local linesR, linesG, linesB = exports.cr_ui:rgbaUnpack(theme.GRAY[700], 1)
        exports.cr_ui:dxDrawGradient(screenX, screenY - 5, sizeX, 1, linesR, linesG, linesB, 255, false, true)
        exports.cr_ui:dxDrawGradient(screenX, screenY - 5, 1, sizeY, linesR, linesG, linesB, 255, true, true)
        exports.cr_ui:dxDrawGradient(screenX - 1, screenY - 5 + sizeY, sizeX, 1, linesR, linesG, linesB, 255, false, false)
        exports.cr_ui:dxDrawGradient(screenX + sizeX - 1, screenY - 5, 1, sizeY, linesR, linesG, linesB, 255, true, false)
		
		dxDrawText(hidePassword and (textBoxes["register_password"][2] and string.rep("*", #textBoxes["register_password"][1]) or "Şifre") or (textBoxes["register_password"][2] and textBoxes["register_password"][1] or "Şifre"), screenX + 15, screenY + 7, nil, nil, selectedTextBox == "register_password" and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.UbuntuRegular.body)
		dxDrawText(hidePassword and "" or "", screenX + sizeX - 20, screenY + 8, nil, nil, tocolor(255, 255, 255, 200), 1, iconFont, "center")
		
		if exports.cr_ui:inArea(screenX + sizeX - 40, screenY + 7, 30, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not loading then
			clickTick = getTickCount()
			hidePassword = not hidePassword
		end
		
		if exports.cr_ui:inArea(screenX, screenY - 5, sizeX - 35, sizeY) then
			exports.cr_cursor:setCursor("all", "ibeam")
			if not loading and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selectedTextBox = "register_password"
				textBoxes[selectedTextBox][1] = ""
				textBoxes[selectedTextBox][2] = true
			end
		end
		
		--> Şifre Yeniden
		dxDrawRectangle(screenX, screenY + 45, sizeX, sizeY, exports.cr_ui:rgba(theme.GRAY[900]))
		
		local linesR, linesG, linesB = exports.cr_ui:rgbaUnpack(theme.GRAY[700], 1)
        exports.cr_ui:dxDrawGradient(screenX, screenY + 45, sizeX, 1, linesR, linesG, linesB, 255, false, true)
        exports.cr_ui:dxDrawGradient(screenX, screenY + 45, 1, sizeY, linesR, linesG, linesB, 255, true, true)
        exports.cr_ui:dxDrawGradient(screenX - 1, screenY + 45 + sizeY, sizeX, 1, linesR, linesG, linesB, 255, false, false)
        exports.cr_ui:dxDrawGradient(screenX + sizeX - 1, screenY + 45, 1, sizeY, linesR, linesG, linesB, 255, true, false)
		
		dxDrawText(hidePassword and (textBoxes["register_password_again"][2] and string.rep("*", #textBoxes["register_password_again"][1]) or "Şifre Yeniden") or (textBoxes["register_password_again"][2] and textBoxes["register_password_again"][1] or "Şifre Yeniden"), screenX + 16, screenY + 56, nil, nil, selectedTextBox == "register_password_again" and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.UbuntuRegular.body)
		dxDrawText(hidePassword and "" or "", screenX + sizeX - 20, screenY + 58, nil, nil, tocolor(255, 255, 255, 200), 1, iconFont, "center")
		
		if exports.cr_ui:inArea(screenX + sizeX - 40, screenY + 57, 30, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not loading then
			clickTick = getTickCount()
			hidePassword = not hidePassword
		end
		
		if exports.cr_ui:inArea(screenX, screenY + 45, sizeX - 35, sizeY) then
			exports.cr_cursor:setCursor("all", "ibeam")
			if not loading and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selectedTextBox = "register_password_again"
				textBoxes[selectedTextBox][1] = ""
				textBoxes[selectedTextBox][2] = true
			end
		end
		
		--> Kayıt Ol
		dxDrawRectangle(screenX, screenY + 95, sizeX, sizeY, exports.cr_ui:inArea(screenX + 95, screenY + 95, sizeX, sizeY) and exports.cr_ui:getServerColor(1) or exports.cr_ui:getServerColor(1, 245))
		dxDrawText("Kayıt Ol", screenX + sizeX - 125, screenY + 106, nil, nil, tocolor(20, 20, 20, 255), 1, fonts.UbuntuRegular.body, "center")
		
		if exports.cr_ui:inArea(screenX, screenY + 95, sizeX, sizeY) and getKeyState("mouse1") and clickTick + 600 <= getTickCount() and not loading then
			clickTick = getTickCount()
			
			if string.match(textBoxes["register_username"][1], "['\"\\%;]") or string.match(textBoxes["register_password"][1], "['\"\\%;]") or string.match(textBoxes["register_password_again"][1], "['\"\\%;]") then
                textBoxes["register_username"][1] = ""
                textBoxes["register_password"][1] = ""
                textBoxes["register_password_again"][1] = ""
				exports.cr_infobox:addBox("error", "Geçersiz karakterler algılandı.")
                return
            end

            if textBoxes["register_username"][1] == "" then
                exports.cr_infobox:addBox("error", "Kullanıcı adı boş bırakılamaz.")
				return
            end

            if textBoxes["register_password"][1] == "" then
                exports.cr_infobox:addBox("error", "Şifre boş bırakılamaz.")
				return
            end
			
            if textBoxes["register_password_again"][1] == "" then
                exports.cr_infobox:addBox("error", "Şifre tekrarı boş bırakılamaz.")
				return
            end

            if string.len(textBoxes["register_username"][1]) < 3 or string.len(textBoxes["register_username"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Kullanıcı adı 3 ila 32 karakter arasında olmalıdır.")
                return
            end

            if string.len(textBoxes["register_password"][1]) < 6 or string.len(textBoxes["register_password"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Şifre 6 ila 32 karakter arasında olmalıdır.")
                return
            end
			
			if textBoxes["register_password"][1] ~= textBoxes["register_password_again"][1] then
				exports.cr_infobox:addBox("error", "Şifreler uyuşmuyor.")
                return
            end

            if isTimer(spamTimer) then
                exports.cr_infobox:addBox("error", "Art arda birden fazla işlem yaptınız, lütfen 3 saniye bekleyin.")
                return
            end
			
			spamTimer = setTimer(function() end, 3000, 1)
			
			loading = true
			addEventHandler("onClientRender", root, renderQueryLoading)
			triggerServerEvent("account.requestRegister", localPlayer, textBoxes["register_username"][1], textBoxes["register_password"][1])
		end
		
		--> Giriş Yap
		dxDrawText("giriş sekmesine dön", screenX + sizeX - 125, screenY + 145, nil, nil, exports.cr_ui:inArea(screenX + dxGetTextWidth("giriş sekmesine dön", 1, fonts.UbuntuRegular.body) - 75, screenY + 145, dxGetTextWidth("giriş sekmesine dön", 1, fonts.UbuntuRegular.body), 15) and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.UbuntuRegular.body, "center")
		
		if exports.cr_ui:inArea(screenX + dxGetTextWidth("giriş sekmesine dön", 1, fonts.UbuntuRegular.body) - 75, screenY + 145, dxGetTextWidth("giriş sekmesine dön", 1, fonts.UbuntuRegular.body), 15) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not loading then
			clickTick = getTickCount()
			selectedPage = 1
		end
	end
	
	if not accountInfo then
		local data, status = exports.cr_json:jsonGet("account", true)
		
		if status then
			if data.rememberMe then
				textBoxes["login_username"][1] = tostring(data.username)
				textBoxes["login_username"][2] = true
				textBoxes["login_password"][1] = tostring(data.password)
				textBoxes["login_password"][2] = true
				_rememberMe = true
				rememberMeCheckbox.checked = true
			else
				_rememberMe = false
				rememberMeCheckbox.checked = false
			end
		end
		
		accountInfo = true
	end
end

--==================================================================================================================

function eventWrite(...)
    write(...)
end

function write(char)
	if selectedTextBox ~= "" and textBoxes[selectedTextBox][2] and not loading and passedIntro then
		local text = textBoxes[selectedTextBox][1]
		local page = textBoxes[selectedTextBox][3]
		if #text <= 25 and selectedPage == page then
			textBoxes[selectedTextBox][1] = (textBoxes[selectedTextBox][1] .. char):gsub(" ", "")
			playSound(":cr_ui/public/sounds/key.mp3")
		end
	end
end

function removeCharacter(key, state)
    if (key == "backspace" and state) then
        if selectedTextBox ~= "" and textBoxes[selectedTextBox][2] and not loading and passedIntro then
			local text = textBoxes[selectedTextBox][1]
			local page = textBoxes[selectedTextBox][3]
			if #text > 0 and selectedPage == page then
				textBoxes[selectedTextBox][1] = string.sub(text, 1, #text - 1)
				playSound(":cr_ui/public/sounds/key.mp3")
			end
        end
    end
end

function enterKey(key, state)
    if (key == "enter" and state) and (clickTick + 600 <= getTickCount()) and not loading and passedIntro then
        if selectedPage == 1 then
			clickTick = getTickCount()
			
			if string.match(textBoxes["login_username"][1], "['\"\\%;]") or string.match(textBoxes["login_password"][1], "['\"\\%;]") then
                textBoxes["login_username"][1] = ""
                textBoxes["login_password"][1] = ""
				exports.cr_infobox:addBox("error", "Geçersiz karakterler algılandı.")
                return
            end

            if textBoxes["login_username"][1] == "" then
                exports.cr_infobox:addBox("error", "Kullanıcı adı boş bırakılamaz.")
				return
            end

            if textBoxes["login_password"][1] == "" then
                exports.cr_infobox:addBox("error", "Şifre boş buraxıla bilməz.")
				return
            end

            if string.len(textBoxes["login_username"][1]) < 3 or string.len(textBoxes["login_username"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Kullanıcı adı 3 ila 32 karakter arasında olmalıdır.")
                return
            end

            if string.len(textBoxes["login_password"][1]) < 3 or string.len(textBoxes["login_password"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Şifre 3 ila 32 karakter arasında olmalıdır.")
                return
            end

            if isTransferBoxActive() then
                exports.cr_infobox:addBox("error", "Sunucu dosyaları indirilirken hesabınıza erişemezsiniz.")
                return
            end

            if isTimer(spamTimer) then
                exports.cr_infobox:addBox("error", "Art arda birden fazla işlem yaptınız, lütfen 3 saniye bekleyin.")
                return
            end

            spamTimer = setTimer(function() end, 3000, 1)
			
			loading = true
			addEventHandler("onClientRender", root, renderQueryLoading)
			triggerServerEvent("account.requestLogin", localPlayer, textBoxes["login_username"][1], textBoxes["login_password"][1])
			
			if rememberMeCheckbox.checked then
				exports.cr_json:jsonSave("account", { username = textBoxes["login_username"][1], password = textBoxes["login_password"][1], rememberMe = rememberMeCheckbox.checked }, true)
			end
        elseif selectedPage == 2 then
			clickTick = getTickCount()
			
			if string.match(textBoxes["register_username"][1], "['\"\\%;]") or string.match(textBoxes["register_password"][1], "['\"\\%;]") or string.match(textBoxes["register_password_again"][1], "['\"\\%;]") then
                textBoxes["register_username"][1] = ""
                textBoxes["register_password"][1] = ""
                textBoxes["register_password_again"][1] = ""
				exports.cr_infobox:addBox("error", "Geçersiz karakterler algılandı.")
                return
            end

            if textBoxes["register_username"][1] == "" then
                exports.cr_infobox:addBox("error", "Kullanıcı adı boş bırakılamaz.")
				return
            end

            if textBoxes["register_password"][1] == "" then
                exports.cr_infobox:addBox("error", "Şifre boş buraxıla bilməz.")
				return
            end
			
            if textBoxes["register_password_again"][1] == "" then
                exports.cr_infobox:addBox("error", "Şifre tekrarı boş buraxıla bilməz.")
				return
            end

            if string.len(textBoxes["register_username"][1]) < 3 or string.len(textBoxes["register_username"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Kullanıcı adı 3 ila 32 karakter arasında olmalıdır.")
                return
            end

            if string.len(textBoxes["register_password"][1]) < 6 or string.len(textBoxes["register_password"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Şifre 6 ila 32 karakter arasında olmalıdır.")
                return
            end
			
			if textBoxes["register_password"][1] ~= textBoxes["register_password_again"][1] then
				exports.cr_infobox:addBox("error", "Şifreler uyuşmuyor.")
                return
            end

            if isTimer(spamTimer) then
                exports.cr_infobox:addBox("error", "Art arda birden fazla işlem yaptınız, lütfen 3 saniye bekleyin.")
                return
            end
			
			spamTimer = setTimer(function() end, 3000, 1)
			
			loading = true
			addEventHandler("onClientRender", root, renderQueryLoading)
			triggerServerEvent("account.requestRegister", localPlayer, textBoxes["register_username"][1], textBoxes["register_password"][1])
		end
    end
end

function pasteClipboardText(clipboardText)
	if clipboardText then
		if selectedTextBox ~= "" and textBoxes[selectedTextBox][2] and not loading and passedIntro then
			local text = textBoxes[selectedTextBox][1]
			local page = textBoxes[selectedTextBox][1]
			if #text <= 32 and selectedPage == page then
				textBoxes[selectedTextBox][1] = textBoxes[selectedTextBox][1] .. clipboardText
				playSound(":cr_ui/public/sounds/key.mp3")
			end
		end
	end
end

--==================================================================================================================

addEvent("account.accountScreen", true)
addEventHandler("account.accountScreen", root, function()
	loading = false
	removeEventHandler("onClientRender", root, renderLoading)
	
	addEventHandler("onClientRender", root, renderAccount)
	addEventHandler("onClientRender", root, renderSplash)
	addEventHandler("onClientCharacter", root, eventWrite)
	addEventHandler("onClientKey", root, removeCharacter)
	addEventHandler("onClientKey", root, enterKey)
	addEventHandler("onClientPaste", root, pasteClipboardText)
end)

addEvent("account.removeAccount", true)
addEventHandler("account.removeAccount", root, function()
    removeEventHandler("onClientRender", root, renderAccount)
    removeEventHandler("onClientRender", root, renderSplash)
    removeEventHandler("onClientCharacter", root, eventWrite)
    removeEventHandler("onClientKey", root, removeCharacter)
    removeEventHandler("onClientKey", root, enterKey)
	removeEventHandler("onClientPaste", root, pasteClipboardText)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	if getElementData(localPlayer, "loggedin") ~= 1 then
		loading = true
		addEventHandler("onClientRender", root, renderLoading)
		
		setPlayerHudComponentVisible("all", false)
		setPlayerHudComponentVisible("crosshair", true)
		setCameraInterior(0)
		setCameraMatrix(1994.6162109375, -1603.8291015625, 43.31729888916, 1916.7744140625, -1543.861328125, 61.88049697876, 0, 50)
		fadeCamera(true)
		showCursor(true)
		showChat(false)
		
		triggerServerEvent("account.requestPlayerInfo", localPlayer)
	end
end)

addEventHandler("onClientPlayerChangeNick", root, function(oldNick, newNick)
	if (source == localPlayer) then
		local legitNameChange = getElementData(localPlayer, "legitnamechange")
		if (oldNick ~= newNick) and (legitNameChange == 0) then
			cancelEvent()
			triggerServerEvent("account.resetPlayerName", localPlayer, oldNick, newNick)
		end
	end
end)