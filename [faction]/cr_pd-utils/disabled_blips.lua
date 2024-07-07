local blips = {}

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		if (getElementData(localPlayer, "faction") == 1 or getElementData(localPlayer, "faction") == 116) and (getElementData(localPlayer) or 0) > 0 then
			for key, value in pairs(getElementsByType("player")) do
				if value ~= localPlayer and not blips[value] and (getElementData(value, "faction") == 1 or getElementData(value, "faction") == 116) and (getElementData(value) or 0) > 0 then
					blips[value] = createBlipAttachedTo(value, 0, 2, 0, 0, 255)
				end
			end
		end
	end
)

addEventHandler("onClientElementDataChange", root,
	function(name)
		if (name == "faction" or name == "duty") and getElementType(source) == "player" then
			local newfaction = getElementData(source, "faction")
			local newduty = tonumber(getElementData(source, "duty")) or 0
			
			if source == localPlayer then
				if (newfaction ~= 1) or (newfaction ~= 116) or newduty == 0 then
					for key, value in pairs(blips) do
						destroyElement(value)
					end
					blips = {}
				else
					for key, value in pairs(getElementsByType("player")) do
						if value ~= localPlayer and not blips[value] and (getElementData(value, "faction") == 1 or getElementData(value, "faction") == 116) and (getElementData(value) or 0) > 0 then
							blips[value] = createBlipAttachedTo(value, 0, 2, 0, 0, 255)
						end
					end
				end
			elseif getElementData(localPlayer, "faction") == 1 then
				if (newfaction == 1) or (newfaction == 45) and newduty > 0 then
					if not blips[source] then
						blips[source] = createBlipAttachedTo(source, 0, 2, 0, 0, 255)
					end
				elseif blips[source] then
					destroyElement(blips[source])
					blips[source] = nil
				end
			end
		end
	end
)

addEventHandler("onClientPlayerQuit", root,
	function()
		if blips[source] then
			destroyElement(blips[source])
			blips[source] = nil
		end
	end
)