musics = {
	{
		url = "public/sounds/musics/1.mp3",
		name = "Ogryzek - GLORY (Official Visualiser)"
	},
}

countries = {
	[1] = "Amerika",
	[2] = "Almanya",
	[3] = "Rusya",
	[4] = "Avusturalya",
	[5] = "Arjantin",
	[6] = "Belçika",
	[7] = "Bulgaristan",
	[8] = "Çin",
	[9] = "Fransa",
	[10] = "Brezilya",
	[11] = "İngiltere",
	[12] = "İrlanda",
	[13] = "İskoçya",
	[14] = "İsrail",
	[15] = "İsveç",
	[16] = "İsviçre",
	[17] = "İtalya",
	[18] = "Jamaika",
	[19] = "Japonya",
	[20] = "Kanada",
	[21] = "Kolombiya",
	[22] = "Küba",
	[23] = "Litvanya",
	[24] = "Macaristan",
	[25] = "Makedonya",
	[26] = "Meksika",
	[27] = "Nijerya",
	[28] = "Norveç",
	[29] = "Peru",
	[30] = "Portekiz",
	[31] = "Romanya",
	[32] = "Sırbistan",
	[33] = "Slovakya",
	[34] = "Ukrayna",
	[35] = "Yunanistan",
	[36] = "Danimarka",
	[37] = "Çekya",
	[38] = "Polonya",
	[39] = "Güney Kore",
	[40] = "Hollanda",
	[41] = "Arnavutluk",
	[42] = "İspanya",
	[43] = "Vietnam",
	[44] = "Avusturya",
	[45] = "Mısır",
	[46] = "Güney Afrika",
	[47] = "Qatar",
	[48] = "Türkiye",
	[49] = "Azerbaycan"
}

availableSkins = {
    [0] = {
        [1] = {
            240, 23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264, 272
        },
        [2] = {
            7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262
        },
        [3] = {
            49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 186, 187, 203, 210, 227, 228, 229, 294
        }
    },
    [1] = {
        [1] = {
            12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 298
        },
        [2] = {
            9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 256
        },
        [3] = {
            38, 53, 54, 55, 56, 88, 141, 178, 224, 225, 226, 263
        }
    }
}

function checkTurkishCharacters(input)
    local turkishCharacters = { "ı", "İ", "ş", "Ş", "ğ", "Ğ", "ü", "Ü", "ö", "Ö", "ç", "Ç", "ə", "Ə" }

    for i = 1, #turkishCharacters do
        if string.find(input, turkishCharacters[i]) then
            return true
        end
    end

    return false
end

function checkCharacterName(text)
	local foundSpace, valid = false, true
	local lastChar, current = " ", ""
	for i = 1, #text do
		local char = text:sub(i, i)
		if char == " " then
			if i == #text then
				valid = false
				return false, "Adınızda hata bulundu."
			else
				foundSpace = true
			end
			
			if #current < 2 then
				valid = false
				return false, "Adınız çok kısa."
			end
			current = ""
		elseif lastChar == " " then
			if char < "A" or char > "Z" then
				valid = false
				return false, "Yalnız adınızın baş harfleri büyük harfle yazılmalıdır."
			end
			current = current .. char
		elseif checkTurkishCharacters(text) then
			valid = false
			return false, "Karakter adında hiçbir Türk simgesi olamaz."
		elseif (char >= "a" and char <= "z") or (char >= "A" and char <= "Z") or (char == "'") then
			current = current .. char
		else
			valid = false
			return false, "Adınızda hiçbir uygun olmayan simge olmamalıdır."
		end
		lastChar = char
	end
	
	if valid and foundSpace and #text < 32 and #current >= 3 then
		return true, "Başarılı!"
	else
		return false, "Adınız çok uzun veya çok kısa değil, 3 - 32 karakterden ibaret olmalıdır."
	end
end

function convertMusicTime(time)
    local minutes = math.floor(math.modf(time, 3600) / 60)
    local seconds = math.floor(math.fmod(time, 60))
    return string.format("%02d:%02d", minutes, seconds)
end