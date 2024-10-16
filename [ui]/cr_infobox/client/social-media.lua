local socials

local function announceSocialMediaAccounts()
    if localPlayer:getData("loggedin") ~= 1 then
        return false
    end

    if not socials then
        socials = {
            { key = "discord", header = "Discord Sunucumuz", url = ("Toplulukla buluşmak için %s\nsunucumuza katılın!\nBuraya tıklayarak kopyalayın."):format("discord.gg/crowndm"), value = "https://discord.gg/crowndm" },
        }
    end

    local social = socials[math.random(1, #socials)]
    addBox(social.key, { header = social.header, message = social.url }, 15000, "bottom-center", social.value)
end
setTimer(announceSocialMediaAccounts, 1000 * 60 * 10, 0)