
local objects = 
{
	--Farid
	createObject (10184, -798.09351, 497.11655, 1368.04456, 0, 0, 270 ,1)
}

local col = createColSphere(-789.0458984375, 503.0791015625, 1368.7353515 ,15)

local function watchChanges()
	if getElementDimension(localPlayer) > 0 and getElementDimension(localPlayer) ~= getElementDimension(objects[1]) and getElementInterior(localPlayer) == getElementInterior(objects[1]) then
		for key, value in pairs(objects) do
			setElementDimension(value, getElementDimension(localPlayer))
		end
	elseif getElementDimension(localPlayer) == 0 and getElementDimension(objects[1]) ~= 65535 then
		for key, value in pairs(objects) do
			setElementDimension(value, 65535)
		end
	end
end
addEventHandler("onClientColShapeHit", col,
	function(element)
		if element == localPlayer then
			addEventHandler("onClientRender", root, watchChanges)
		end
	end
)
addEventHandler("onClientColShapeLeave", col,
	function(element)
		if element == localPlayer then
			removeEventHandler("onClientRender", root, watchChanges)
		end
	end
)

-- Put them standby for now.
for key, value in pairs(objects) do
	setElementDimension(value, 65535)
end

for index, object in ipairs (objects) do
    setElementDoubleSided (object, true)
	--setElementCollisionsEnabled (object, true)
end


