screenSize = Vector2(guiGetScreenSize())

function isRenderInfobox()
	if #Infobox.items > 0 then
		return true
	end
	return false
end