-- Defines
INTERIOR_X = 1
INTERIOR_Y = 2
INTERIOR_Z = 3
INTERIOR_INT = 4
INTERIOR_DIM = 5
INTERIOR_ANGLE = 6
INTERIOR_FEE = 7

INTERIOR_TYPE = 1
INTERIOR_DISABLED = 2
INTERIOR_LOCKED = 3
INTERIOR_OWNER = 4
INTERIOR_COST = 5
INTERIOR_SUPPLIES = 6
INTERIOR_FACTION = 7


function canEnterInterior(theInterior)
	local interiorID = getElementData(theInterior, "dbid")
	if interiorID then
		local interiorStatus = getElementData(theInterior, "status")
		if interiorStatus[INTERIOR_DISABLED] then
			return false, 1, "Mülk askıya alınmış."
		elseif interiorStatus[INTERIOR_LOCKED] then
			return false, 2, "Kapı kilitli."
		end
		return true
	end
	return false, 3, "Bir hata oluştu!"
end

function isInteriorForSale(theInterior)
	local interiorStatus = getElementData(theInterior, "status") 
	if not interiorStatus then
		return false
	end
	
	if interiorStatus[INTERIOR_TYPE] ~= 2 then
		if interiorStatus[INTERIOR_OWNER] <= 0 and interiorStatus[INTERIOR_FACTION] <= 0 then
			if interiorStatus[INTERIOR_LOCKED] then
				if not interiorStatus[INTERIOR_DISABLED] then
					return true
				end
			end
		end
	end		
	return false
end
