//Emerald Stuff for special stages!
//Only MRCE and Vanilla, though
local function emeraldStuff(emerald)
	if not emerald.valid return end

	-- For Software players
	//emerald.info.dispoffset = 1
	
	-- Fade timer
	if emerald.fadeTimer == nil
		emerald.fadeTimer = 40
	end

	emerald.frame = $|FF_FULLBRIGHT -- Always be FullBright
	
	if IsMRCESpecialStage
	or IsVanillaSpecialStage
	or IsMRSpecialStage
		emerald.destscale = signScale*2
		emerald.flags = MF_NOGRAVITY|MF_SCENERY
		emerald.shadowscale = 0 -- Remove emerald's shadow
		if emerald.z <= emerald.floorz + 70*FRACUNIT
			emerald.z = $1 + FRACUNIT*3
		end
	//end
		if IsVanillaSpecialStage
			for player in players.iterate
				if player.mo and player.mo.valid
					if player.exiting > 41
						emerald.destscale = FRACUNIT
					elseif player.exiting <= 40 and player.exiting > 0
						P_SetObjectMomZ(emerald, FRACUNIT, true)
						emerald.destscale = FRACUNIT
						if leveltime % 8 == 0
							emerald.frame = $ - FRACUNIT -- Fade from FF_TRANS50 to Opaque
						end
					else
						-- Fade from FF_TRANS90 to FF_TRANS50
						if emerald.fadeTimer
							emerald.fadeTimer = $ - 1
							if leveltime % 3 == 0
								emerald.frame = $ - FRACUNIT
							end
						end
					end
					emerald.frame = $|FF_FULLBRIGHT
				end
			end
		end

		if IsMRSpecialStage
			for sign in mapthings.iterate 
				if sign.type == mobjinfo[MT_SIGN].doomednum
					P_TeleportMove(emerald, sign.mobj.x, sign.mobj.y, emerald.z)
				end
			end
		end
		
		if not IsVanillaSpecialStage
		and signStopped == true
			emerald.flags2 = $1 | MF2_DONTDRAW
		else
			emerald.flags2 = $1 & ~MF2_DONTDRAW
		end
		
	end
end

freeslot("SPR_FKEM", "S_ORBITWIREFRAME") -- So we don't accidentally unlock Hyper
states[S_ORBITWIREFRAME] = {SPR_FKEM, A|FF_FULLBRIGHT, 1, A_OrbitNights, ANG2*2, 0, S_ORBITWIREFRAME}
local function gotEmerald(gotEmerald)
	if IsVanillaSpecialStage
		gotEmerald.state = S_ORBITWIREFRAME
		if consoleplayer and consoleplayer.exiting
			gotEmerald.flags2 = $|MF2_DONTDRAW
		end
	end
end

addHook("MobjThinker", emeraldStuff, MT_EMERALD1)
addHook("MobjThinker", emeraldStuff, MT_EMERALD2)
addHook("MobjThinker", emeraldStuff, MT_EMERALD3)
addHook("MobjThinker", emeraldStuff, MT_EMERALD4)
addHook("MobjThinker", emeraldStuff, MT_EMERALD5)
addHook("MobjThinker", emeraldStuff, MT_EMERALD6)
addHook("MobjThinker", emeraldStuff, MT_EMERALD7)
--addHook("MobjThinker", emeraldStuff, MT_EMERALD8) Emerald 8 doesn't exist, it's a freeslot for SA-Sonic just incase for mods.
addHook("MobjThinker", gotEmerald, MT_GOTEMERALD)

rawset(_G, "EmeraldType", 0)
addHook("MobjThinker", function(nightsGoal)
	if IsVanillaSpecialStage
	and nightsGoal and nightsGoal.valid
		if gamemap == 50 then EmeraldType = MT_EMERALD1
		elseif gamemap == 51 then EmeraldType = MT_EMERALD2
		elseif gamemap == 52 then EmeraldType = MT_EMERALD3
		elseif gamemap == 53 then EmeraldType = MT_EMERALD4
		elseif gamemap == 54 then EmeraldType = MT_EMERALD5
		elseif gamemap == 55 then EmeraldType = MT_EMERALD6
		elseif gamemap == 56 then EmeraldType = MT_EMERALD7
		elseif gamemap == 57 then EmeraldType = MT_GOTEMERALD
		else
			return
		end
		if nightsGoal and nightsGoal.valid
			states[S_NIGHTSDRONE_GOAL1] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_GOAL2] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_GOAL3] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_GOAL4] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING1] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING2] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING3] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING4] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING5] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING6] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING7] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING8] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING9] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING10] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING11] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING12] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING13] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING14] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING15] = {sprite = SPR_NULL}
			states[S_NIGHTSDRONE_SPARKLING16] = {sprite = SPR_NULL}
		end
		if leveltime == 1 -- For the love of god please spawn them ONCE
			for player in players.iterate
			local sign = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.floorz, MT_SIGN)
			local emerald = P_SpawnMobjFromMobj(sign, 0, 0, 0, EmeraldType)
			nightsGoal.z = $1 + 70*FRACUNIT
			nightsGoal.scale = emerald.scale*6 -- Hopefully this is enough
			emerald.flags = $ & ~MF_SPECIAL -- Or else if the player is too close to the emerald on spawn, it'll be collected
			return -- ONLY ONCE
			end
		end
	else
		return
	end
end, MT_NIGHTSDRONE_GOAL)