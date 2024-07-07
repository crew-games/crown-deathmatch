function copyPosToClipboard(prepairedText)
	setClipboard(prepairedText) 
end
addEvent("copyPosToClipboard",true)
addEventHandler("copyPosToClipboard", localPlayer,copyPosToClipboard)