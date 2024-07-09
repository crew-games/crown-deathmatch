addEventHandler("onClientResourceStart", resourceRoot, function()
    if getVersion().sortable < "1.1.0" then
        return
    end

    local myShader, tec = dxCreateShader("car_paint.fx")

    if myShader then
        local textureVol = dxCreateTexture("images/smallnoise3d.dds")
        local textureCube = dxCreateTexture("images/cube_env256.dds")
        dxSetShaderValue(myShader, "sRandomTexture", textureVol)
        dxSetShaderValue(myShader, "sReflectionTexture", textureCube)

        local function applyShaderToVehicle(vehicle)
			engineApplyShaderToWorldTexture(myShader, "vehiclegrunge256", vehicle)
			engineApplyShaderToWorldTexture(myShader, "?emap*", vehicle)
        end

        for _, vehicle in ipairs(getElementsByType("vehicle")) do
            applyShaderToVehicle(vehicle)
        end

        addEventHandler("onClientElementStreamIn", root, function()
            if getElementType(source) == "vehicle" then
                applyShaderToVehicle(source)
            end
        end)

        addEventHandler("onClientElementStreamOut", root, function()
            if getElementType(source) == "vehicle" then
                engineRemoveShaderFromWorldTexture(myShader, "vehiclegrunge256", source)
                engineRemoveShaderFromWorldTexture(myShader, "?emap*", source)
            end
        end)
    end
end)