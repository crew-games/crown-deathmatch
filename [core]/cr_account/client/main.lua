screenSize = Vector2(guiGetScreenSize())

theme = exports.cr_ui:useTheme()
fonts = exports.cr_ui:useFonts()
iconFont = exports.cr_fonts:getFont("FontAwesome", 10)

loading = false
passedIntro = false

music = {
	sound = nil,
	timer = nil,
	index = 0,
	beginning = false,
	paused = false,
}

selectedTextBox = ""
textBoxes = {
	["login_username"] = {"", false, 1},
	["login_password"] = {"", false, 1},
	["register_username"] = {"", false, 2},
	["register_password"] = {"", false, 2},
	["register_password_again"] = {"", false, 2}
}

function playMusic()
	if not (music.beginning) then
		music.index = math.random(1, #musics)
		music.sound = playSound(musics[music.index].url, false)
		setSoundVolume(music.sound, 0.5)
		music.beginning = true
	else
		if (music.beginning) and (music.sound) and (not getSoundPosition(music.sound)) then
			music.index = music.index >= #musics and 1 or music.index + 1
			music.sound = playSound(musics[music.index].url, false)
			setSoundVolume(music.sound, 0.5)
		end
	end
end

function isKeyPressed(key)
    if isConsoleActive() or isMainMenuActive() then
        return false
    end
    return getKeyState(key)
end