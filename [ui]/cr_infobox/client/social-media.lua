local socials

local function announceSocialMediaAccounts()
    if localPlayer:getData('loggedin') ~= 1 then
        return false
    end

    if not socials then
        socials = {
            { key = 'discord', header = 'Discord Sunucumuz', url = ('Toplulukla buluşmak için %s\nsunucumuza katılın!\nBuraya tıklayarak kopyalayın.'):format('discord.gg/crowndm'), value = 'https://discord.gg/crowndm' },
            { key = 'instagram', header = 'Instagram Hesabımız', url = ('Etkinliklerden haberdar olmak için\n@%s hesabını takip edin!'):format('crown.deathmatch'), value = 'https://www.instagram.com/crown.deathmatch' },
			{ key = 'youtube', header = 'Youtube Kanalımız', url = ('Arada Youtube kanalımıza video atıyoruz.\nTıkla ve kanal linkimizi kopyala!\nKanalımıza abone ol, bildirimlerini aç!'), value = 'https://www.youtube.com/@crowndeathmatch' },
            { key = 'tiktok', header = 'Tiktok Hesabımız', url = ('Arada Tiktok hesabımıza video atıyoruz.\nTıkla ve hesap linkimizi kopyala!\nHesabımızı takip et, bildirimlerini aç!'), value = 'https://www.tiktok.com/@crowndeathmatch' },
        }
    end

    local social = socials[math.random(1, #socials)]
    addBox(social.key, { header = social.header, message = social.url }, 15000, 'bottom-center', social.value)
end
setTimer(announceSocialMediaAccounts, 1000 * 60 * 10, 0)

function announceSocialMediaWarn()
    if exports.cr_integration:isPlayerDeveloper(localPlayer) then
        announceSocialMediaAccounts()
        outputChatBox("[!]#FFFFFF Duyuru başarıyla geçildi.", 0, 255, 0, true)
    end
end
addCommandHandler("duyuruyap", announceSocialMediaWarn, false, false)