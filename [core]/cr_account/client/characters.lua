local CONTAINER_PADDING = 20
local lastClick = getTickCount()

local store = {
	currentCharacter = 1
}

function renderCharacters()
	local characters = getElementData(localPlayer, "account:characters")
    local characterCount = characters and #characters or 1
	
	if not store.ped and not isElement(store.ped) then
		setCameraMatrix(400.54150390625, -2077.3400878906, 10.722999572754, 400.54440307617, -2076.3415527344, 10.667260169983, 0, 70)
		setCameraInterior(localPlayer:getInterior())
        local ped = createPed(0, 400.736328125, -2071.98046875, 10.740701675415, 180)
		ped:setFrozen(true)
		ped:setModel(characters[store.currentCharacter].skin)
		ped:setAnimation("misc", "idle_chat_02")
        ped:setDimension(localPlayer:getDimension())
        ped:setInterior(localPlayer:getInterior())
        store.ped = ped
		lastClick = getTickCount()
    end
	
    local ped = store.ped

    local joinCharacterButton1 = exports.cr_ui:drawButton({
        position = {
            x = CONTAINER_PADDING,
            y = CONTAINER_PADDING
        },
        size = {
            x = 200,
            y = 35
        },

        text = "Karaktere Gir",
        icon = "",
        radius = 8,

        variant = "soft",
        color = "green",

        disabled = not characters or loading
    })
	
	local createCharacterButton = exports.cr_ui:drawButton({
        position = {
            x = CONTAINER_PADDING,
            y = CONTAINER_PADDING + 40
        },
        size = {
            x = 200,
            y = 35
        },

        icon = "",
        text = "Karakter Oluştur",
        radius = 8,

        variant = "soft",
        color = "blue",

        disabled = not characters or loading
    })

    exports.cr_ui:drawTypography({
        position = {
            x = CONTAINER_PADDING,
            y = screenSize.y - CONTAINER_PADDING * 3
        },
        text = getElementData(localPlayer, "account:username"),
        color = theme.GRAY[200],
        scale = "h1",
        alignX = "left",
        alignY = "top",
        fontWeight = "light",
        wrap = false,
    })

    if not characters then
        exports.cr_ui:drawSpinner({
            position = {
                x = screenSize.x / 2 - 128 / 2,
                y = screenSize.y / 2 - 128 / 2
            },
            size = 128,
            color = "blue",
            speed = 1,
            variant = "soft",
        })
    end

    drawSlider({
        position = {
            x = screenSize.x / 2 - 500 / 2,
            y = screenSize.y - 200
        },
        size = {
            x = 500,
            y = 200
        },
        containerSize = {
            x = 250,
            y = 70
        },
        count = characterCount,
        current = store.currentCharacter,
        content = function()
            local row = characters and characters[store.currentCharacter]
            if row and store.ped then
                local bonePositionX, bonePositionY, bonePositionZ = getPedBonePosition(store.ped, 32)
                local x, y = getScreenFromWorldPosition(bonePositionX, bonePositionY, bonePositionZ, 0, false)

                if x and y then
                    local characterName = row.characterName:gsub("_", " ")

                    exports.cr_ui:drawList({
                        position = {
                            x = x + 100,
                            y = y
                        },
                        size = {
                            x = 200,
                            y = 200
                        },

                        padding = 15,
                        rowHeight = 30,

                        name = "account_characters_list",
                        header = characterName:upper(),
                        items = {
                            { text = "Rütbe: " .. exports.cr_rank:getRankTitle(row.kills), icon = "", key = "" },
                            { text = "Öldürme: " .. row.kills, icon = "", key = "" },
                            { text = "Ölme: " .. row.deaths, icon = "", key = "" },
                            { text = "Seviye: " .. row.level, icon = "", key = "" },
                        },

                        variant = "soft",
                        color = "gray",
                    })

                    local joinCharacterButton2 = exports.cr_ui:drawButton({
                        position = {
                            x = x + 100,
                            y = y + 210
                        },
                        size = {
                            x = 200,
                            y = 35
                        },
                        text = "Karaktere Gir [ENTER]",
                        icon = "",
                        radius = 8,

                        variant = "soft",
                        color = "green",

                        textProperties = {
                            align = "center",
                            color = "#FFFFFF",
                            font = fonts.h6.regular,
                            scale = 1,
                        },

                        disabled = loading,
                    })

                    if joinCharacterButton1.pressed or joinCharacterButton2.pressed or isKeyPressed("enter") and lastClick + 300 < getTickCount() and not loading then
                        lastClick = getTickCount()
                        triggerServerEvent("account.joinCharacter", localPlayer, row.id)
						loading = true
						addEventHandler("onClientRender", root, renderQueryLoading)
                    end
                end
            end
        end,
        switch = function(current)
            if not loading then
                store.currentCharacter = current
                ped:setModel(characters[store.currentCharacter].skin)
            end
        end
    })

    if characters and not loading then
        if isKeyPressed("arrow_l") and lastClick + 300 <= getTickCount() then
            lastClick = getTickCount()
            local newIndex = math.max(1, store.currentCharacter - 1)
            store.currentCharacter = newIndex
            ped:setModel(characters[store.currentCharacter].skin)
        end

        if isKeyPressed("arrow_r") and lastClick + 300 <= getTickCount() then
            lastClick = getTickCount()
            local newIndex = math.min(characterCount, store.currentCharacter + 1)
            store.currentCharacter = newIndex
            ped:setModel(characters[store.currentCharacter].skin)
        end

        if createCharacterButton.pressed then
            local characters = getElementData(localPlayer, "account:characters")
            local maxCharacterCount = tonumber(localPlayer:getData("charlimit") or 1)
            local characterCount = characters and #characters or 1

            if characterCount >= maxCharacterCount then
                exports.cr_infobox:addBox("error", "Maksimum karakter sayısına ulaştınız, marketten karakter slotu satın alınız.")
                return
            end

            local ped = store.ped
            if ped and isElement(ped) then
                ped:destroy()
            end
			
			removeEventHandler("onClientRender", root, renderCharacters)
            triggerEvent("account.characterCreation", localPlayer)
        end
    end
end

addEvent("account.characterSelection", true)
addEventHandler("account.characterSelection", root, function()
    addEventHandler("onClientRender", root, renderCharacters)
end)

addEvent("account.joinCharacter", true)
addEventHandler("account.joinCharacter", root, function(characterID)
    triggerServerEvent("account.joinCharacter", localPlayer, characterID)
end)

addEvent("account.joinCharacterComplete", true)
addEventHandler("account.joinCharacterComplete", root, function()
	if isEventHandlerAdded("onClientRender", root, renderCharacters) then
		removeEventHandler("onClientRender", root, renderCharacters)
	end
	
	if isEventHandlerAdded("onClientRender", root, renderCharacterCreation) then
		removeEventHandler("onClientRender", root, renderCharacterCreation)
	end
	
	local ped = store.ped
	if ped and isElement(ped) then
		ped:destroy()
	end
	
	if isTimer(music.timer) then
		killTimer(music.timer)
	end
	
	if isElement(music.sound) then
		destroyElement(music.sound)
	end
	
	clearChatBox()
	showChat(true)
	showCursor(false)
	setCameraTarget(localPlayer, localPlayer)

	outputChatBox("[!]#FFFFFF " .. getPlayerName(localPlayer):gsub("_", " ") .. " isimli karakterinize giriş sağlandı.", 0, 255, 0, true)
	outputChatBox("[!]#FFFFFF Keyifli DM'ler ve eğlenceler dileriz.", 0, 255, 0, true)
	
	triggerEvent("playSuccessfulSound", localPlayer)
end)