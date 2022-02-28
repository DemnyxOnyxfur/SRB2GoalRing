// Mainly for stage packs that use a different goal ring.
// For example, SL_2006!
// The Heroes ring is used as a base.	
rawset(_G, "IsMemeStage", false) 		   -- SL_2006
rawset(_G, "IsMRCESpecialStage", false)	   -- Mystic Realm: Community Edition
rawset(_G, "IsMRSpecialStage", false)	   -- Mystic Realm: v5.X
rawset(_G, "IsVanillaSpecialStage", false) -- Vanilla

local function SpecialSignStages()
	-- SL_2006
	if (gamemap < 14)
		if (gamemap == 1 and mapheaderinfo[gamemap].lvlttl == "Wave Ocean")
		or (gamemap == 2 and mapheaderinfo[gamemap].lvlttl == "Dusty Desert")
		or (gamemap == 3 and mapheaderinfo[gamemap].lvlttl == "White Acropolis")
		or (gamemap == 4 and mapheaderinfo[gamemap].lvlttl == "Crisis City")
		or (gamemap == 5 and mapheaderinfo[gamemap].lvlttl == "Flame Core")
		or (gamemap == 6 and mapheaderinfo[gamemap].lvlttl == "Radical Train")
		or (gamemap == 7 and mapheaderinfo[gamemap].lvlttl == "Tropical Jungle")
		or (gamemap == 8 and mapheaderinfo[gamemap].lvlttl == "Kingdom Valley")
		or (gamemap == 9 and mapheaderinfo[gamemap].lvlttl == "Aquatic Base")
		or (gamemap == 13 and mapheaderinfo[gamemap].lvlttl == "Test Area")
			IsMemeStage = true
		else
			IsMemeStage = false
		end
	else
		IsMemeStage = false
	end
	-- Mystic Realm Versions
	if gamemap >= 123 and gamemap <= 129
		if gamemap == 123 and mapheaderinfo[gamemap].lvlttl == "Mudhole Karst"
		or gamemap == 124 and mapheaderinfo[gamemap].lvlttl == "Rainstorm Keep"
		or gamemap == 125 and mapheaderinfo[gamemap].lvlttl == "Labyrinth Woods"
		or gamemap == 126 and mapheaderinfo[gamemap].lvlttl == "Vulkan Forge"
		or gamemap == 127 and mapheaderinfo[gamemap].lvlttl == "Silver Cavern"
		or gamemap == 128 and mapheaderinfo[gamemap].lvlttl == "Nitric Citadel"
		or gamemap == 129 and mapheaderinfo[gamemap].lvlttl == "Starlight Temple"
			if mrce_hyperunlocked != nil -- If variable exists
				IsMRCESpecialStage = true
				IsMRSpecialStage = false
			else
				IsMRCESpecialStage = false
				IsMRSpecialStage = true
			end
		end
	else
		IsMRCESpecialStage = false
		IsMRSpecialStage = false
	end
	-- Vanilla Special Stages
	if gamemap >= 50 and gamemap <= 57
		if gamemap == 50 and mapheaderinfo[gamemap].lvlttl == "Floral Field"
		or gamemap == 51 and mapheaderinfo[gamemap].lvlttl == "Toxic Plateau"
		or gamemap == 52 and mapheaderinfo[gamemap].lvlttl == "Flooded Cove"
		or gamemap == 53 and mapheaderinfo[gamemap].lvlttl == "Cavern Fortress"
		or gamemap == 54 and mapheaderinfo[gamemap].lvlttl == "Dusty Wasteland"
		or gamemap == 55 and mapheaderinfo[gamemap].lvlttl == "Magma Caves"
		or gamemap == 56 and mapheaderinfo[gamemap].lvlttl == "Egg Satellite"
		or gamemap == 57 and mapheaderinfo[gamemap].lvlttl == "Black Hole"
			IsVanillaSpecialStage = true
		else
			IsVanillaSpecialStage = false
		end
	else
		IsVanillaSpecialStage = false
	end
end

addHook("MapLoad", SpecialSignStages, gamemap)