local clientID = "975807504518873099"

addEventHandler("onClientResourceStart", resourceRoot, function()
	if setDiscordApplicationID(clientID) then
		setRichPresenceOptions()
	end
end)

addEventHandler("onClientPlayerChangeNick", root, function()
	if isDiscordRichPresenceConnected() then
		setRichPresenceOptions()
	end
end)

addEventHandler("onClientPlayerJoin", root, function()
	if isDiscordRichPresenceConnected() then
		setRichPresenceOptions()
	end
end)

addEventHandler("onClientPlayerQuit", root, function()
	if isDiscordRichPresenceConnected() then
		setRichPresenceOptions()
	end
end)

addEventHandler("onClientElementDataChange", root, function(theKey, oldValue, newValue)
	if isDiscordRichPresenceConnected() then
		if theKey == "loggedin" then
			setRichPresenceOptions()
		end
	end
end)

function setRichPresenceOptions()
	setTimer(function()
		local loggedin = getElementData(localPlayer, "loggedin") or 0

		setDiscordRichPresenceAsset("logo", "Crown Deathmatch")
		setDiscordRichPresenceSmallAsset("mtasa", "Multi Theft Auto")
		setDiscordRichPresenceDetails((loggedin == 1) and getPlayerName(localPlayer):gsub("_", " ") or "Giriş Ekranında.")
		setDiscordRichPresenceState("Oyunda: " .. #getElementsByType("player") .. "/500")
		
		setDiscordRichPresenceButton(1, "Sunucuya Bağlan", "mtasa://185.160.30.185:22003")
		setDiscordRichPresenceButton(2, "Discord'a Katıl", "https://discord.gg/azerp")
	end, 1000, 1)
end