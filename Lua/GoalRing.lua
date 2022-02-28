//Sign Sounds
freeslot("sfx_goalri", "sfx_endlvl")
sfxinfo[sfx_goalri] = {flags = SF_X2AWAYSOUND,}
sfxinfo[sfx_endlvl] = {flags = SF_X2AWAYSOUND,}

//Goal Rings
freeslot("SPR_GLRG", "SPR_GLR2", "SPR_GLRM", "SPR2_GEND")

local CV_GoalRingType = CV_RegisterVar({
name = "signtype",
defaultvalue = 0,
PossibleValue = {SA2=0, Heroes=1, SRB2=2, Modern=3}
})

rawset(_G, "GoalRing", true) --For those that want to check for Goal Ring
rawset(_G, "signScale", 0)
rawset(_G, "signStopped", false)
rawset(_G, "usingModels", false)

local signOriginalAngle
addHook("MapLoad", function(sign)
	for sign in mapthings.iterate
		if sign.type == mobjinfo[MT_SIGN].doomednum -- 501
			signOriginalAngle = sign.angle
		end
	end
end)


local postsign1
//local postsign2
//Sign things
addHook("MobjThinker", function(sign)

	if not sign and not sign.valid 
		assert(sign, "There is no sign!")
		return
	end
	if sign.tracer == nil
		assert(sign, "There is no sign.tracer!")
		return
	end
	if sign.tracer.tracer == nil
		assert(sign, "There is no sign.tracer.tracer!")
		return
	end
	
	if CV_FindVar("renderer").value == 2
	and CV_FindVar("gr_models").value == 1
		usingModels = true
	else
		usingModels = false
	end

	-- Set sign's scale
	-- GoalRing's actual height/radius
	sign.actualheight = 200*FRACUNIT
	sign.diameter = 90*FRACUNIT
	sign.height = 32*FRACUNIT
	sign.radius = 45*FRACUNIT
	
	if sign.prespinangle == nil --Compatibility with SA-Sonic.
		sign.prespinangle = sign.angle
	end
	if sign.emertrans == nil --Our trans value.
		sign.emertrans = TR_TRANS90
	end	
	
	-- GoalRing sound timer
	if sign.goalsound == nil
	or sign.goalsound >= 25
		sign.goalsound = 0
	end

	-- Change Sign's sprites depending on CV value
	if sign.state >= S_SIGN and sign.state <= S_SIGNSPIN6
	
		if CV_GoalRingType.value == 2
		and IsVanillaSpecialStage == false
		and IsMRCESpecialStage == false
		and IsMRSpecialStage == false
			sign.sprite = SPR_SIGN
			sign.tracer.sprite = SPR_SIGN
			sign.tracer.tracer.sprite = SPR_SIGN
			sign.tracer.tracer.flags2 = $1 & ~MF2_DONTDRAW
			sign.info.painchance = MT_SPARK
			if not consoleplayer.exiting
				sign.angle = FixedAngle(signOriginalAngle)*FRACUNIT
			end
		elseif CV_GoalRingType.value == 1
		or CV_GoalRingType.value == 3
		or IsVanillaSpecialStage == true
		or IsMRCESpecialStage == true
		or IsMRSpecialStage == true
		or IsMemeStage == true
			sign.sprite = SPR_GLRG
			sign.tracer.sprite = SPR_GLRG
			sign.tracer.tracer.sprite = SPR_GLRG
			if IsMRCESpecialStage == true
			or IsMRSpecialStage == true
			or IsVanillaSpecialStage == true
				sign.tracer.tracer.flags2 = $1 | MF2_DONTDRAW
			else
				sign.tracer.tracer.flags2 = $1 & ~MF2_DONTDRAW
			end
			sign.info.painchance = 0 -- Remove Sign's spin sparkle
			if sign.target and sign.target.player and sign.target.player.pflags & ~PF_FINISHED
				sign.tracer.tracer.info.dispoffset = 1 -- For Software
			end
		else
			sign.sprite = SPR_GLR2
			sign.tracer.sprite = SPR_GLR2
			sign.tracer.tracer.sprite = SPR_GLR2
			sign.info.painchance = 0 -- Remove Sign's spin sparkle
			if sign.goalsound == 16
				postsign1 = sign.tracer.tracer
				sign.tracer.tracer.flags2 = $1 | MF2_DONTDRAW -- "GOAL" flashing
			elseif sign.goalsound == 0
				sign.tracer.tracer.flags2 = $1 & ~MF2_DONTDRAW
			end
			if sign.target and sign.target.player and sign.target.player.pflags & ~PF_FINISHED
				sign.tracer.tracer.info.dispoffset = 1 -- For Software
			end
			if sign.tracer.tracer.state == S_EGGMANSIGN -- If "GOAL", make inner ring black instead of sign's default color "SKINCOLOR_CARBON"
				sign.tracer.color = SKINCOLOR_BLACK
			end
		end
	end
	
	if sign.state >= S_SIGN and sign.state <= S_CLEARSIGN
		if sign.sprite != SPR_SIGN
		or sign.tracer.sprite != SPR_SIGN
		or sign.tracer.tracer.sprite != SPR_SIGN
			sign.frame = $|FF_FULLBRIGHT
			sign.tracer.frame = $|FF_FULLBRIGHT
			sign.tracer.tracer.frame = $|FF_FULLBRIGHT
		else
			sign.frame = $1 & ~FF_FULLBRIGHT
			sign.tracer.frame = $1 & ~FF_FULLBRIGHT
			sign.tracer.tracer.frame = $1 & ~FF_FULLBRIGHT
		end
	end
	if not CV_GoalRingType.value --If SA2 goal ring...
		//Particle spin
		postsign1 = sign
		if (leveltime % 2 == 0)
			local signangle = sign.angle
			if signangle != 0
				signangle = $/ANG1
			end
			if sign.state ~= S_SIGN
			or IsMemeStage == true
			or IsMRCESpecialStage == true
			or IsMRSpecialStage == true
			or IsVanillaSpecialStage == true
				sign.signSparkle = P_SpawnMobj(sign.x, sign.y, sign.floorz + sign.height*2 + P_RandomRange(0, 100)*FRACUNIT, MT_IVSP)
			else
				sign.signSparkle = P_SpawnMobj(sign.x, sign.y, sign.floorz + sign.height*2 + P_RandomRange(0, 100)*FRACUNIT, MT_PARTICLE)
			end
			--Minor optimization.
			
			P_Thrust(sign.signSparkle, P_RandomRange(signangle, 360)*ANG1, P_RandomRange(1, 8)*FRACUNIT)
			P_SetObjectMomZ(sign.signSparkle, P_RandomRange(-5, 5)*FRACUNIT, true)
			P_SetScale(sign.signSparkle, sign.scale/2*FRACUNIT)
			sign.signSparkle.fuse = 32
			sign.signSparkle.blendmode = AST_ADD
			sign.signSparkle.colorized = true --This is how you color non-colorable sprites.
			sign.signSparkle.color = SKINCOLOR_SUPERGOLD5
			sign.signSparkle.frame = A|TR_TRANS80|FF_FULLBRIGHT
		end
	elseif CV_GoalRingType.value == 1
	or CV_GoalRingType.value == 3
	or IsVanillaSpecialStage == true
	or IsMRCESpecialStage == true
	or IsMRSpecialStage == true
		local signangle = sign.angle
		if signangle != 0
			signangle = $/ANG1
		end
		if IsMemeStage == true
		or IsMRCESpecialStage == true
		or IsMRSpecialStage == true
		or IsVanillaSpecialStage == true
			sign.signSparkle = P_SpawnMobj(sign.x, sign.y, sign.floorz + sign.height*2 + P_RandomRange(0, 100)*FRACUNIT, MT_IVSP)
			P_Thrust(sign.signSparkle, P_RandomRange(signangle, 360)*ANG1, P_RandomRange(1, 8)*FRACUNIT)
			P_SetObjectMomZ(sign.signSparkle, P_RandomRange(-5, 5)*FRACUNIT, true)
			P_SetScale(sign.signSparkle, sign.scale/2*FRACUNIT)
			sign.signSparkle.fuse = 32
			sign.signSparkle.blendmode = AST_ADD
			sign.signSparkle.colorized = true --This is how you color non-colorable sprites.
			sign.signSparkle.color = SKINCOLOR_SUPERGOLD5
			sign.signSparkle.frame = A|TR_TRANS80|FF_FULLBRIGHT
		else
			sign.signSparkle = P_SpawnMobj(sign.x + P_RandomRange(45, -45)*FRACUNIT, sign.y + P_RandomRange(45, -45)*FRACUNIT, sign.z + sign.actualheight + P_RandomRange(-10,10)*FRACUNIT, MT_IVSP)
			P_Thrust(sign.signSparkle, P_RandomRange(signangle, 360)*ANG1, P_RandomRange(-4,4)*FRACUNIT)
			P_SetObjectMomZ(sign.signSparkle, P_RandomRange(-2,2)*FRACUNIT, false)
			P_SetScale(sign.signSparkle, sign.scale/2*FRACUNIT)
			sign.signSparkle.blendmode = AST_ADD
			sign.signSparkle.colorized = true
			sign.signSparkle.color = SKINCOLOR_SUPERGOLD5
			sign.signSparkle.frame = $|FF_TRANS40|FF_FULLBRIGHT
			sign.signSparkle.flags = $1 & ~MF_NOGRAVITY
			sign.signSparkle.fuse = P_RandomRange(15,35)*FRACUNIT
		end
		postsign1 = sign
	elseif CV_GoalRingType.value == 2
	or IsVanillaSpecialStage == false
	or IsMRCESpecialStage == false
	or IsMRSpecialStage == false
		if sign.tracer and sign.tracer.tracer and sign.tracer.tracer.spriteyoffset == 8*FRACUNIT	
			sign.tracer.tracer.spriteyoffset = 0
		end
		S_StopSoundByID(sign, sfx_goalri)
		return 
	end
	
	if sign.tracer.sprite != SPR_PLAY and sign.tracer.frame < S
		sign.tracer.spriteyoffset = 0
	end
	
	-- If ceiling is shorter than GoalRing, change its scale
	if CV_GoalRingType.value != 2
	or IsMRCESpecialStage == false
	or IsMRSpecialStage == false
	or IsVanillaSpecialStage == false
		if sign.ceilingz < (sign.actualheight + sign.floorz)
			P_SetScale(sign, FixedDiv((sign.ceilingz - sign.floorz)*2, sign.actualheight))
		else
			P_SetScale(sign, FixedDiv(4*FRACUNIT, 2*FRACUNIT))
		end
	end
	signScale = sign.scale
	
	-- GoalRing rotation
	if sign.valid
		-- GoalRing Swish
		if sign.goalpassedsound == nil
			sign.goalpassedsound = 0
		end	
		if sign.angleRotation == nil
			sign.angleRotation = 0
		end
		
		if sign.goalStarRotation == nil
			sign.goalStarRotation = 0
		end
		
		if sign.goalRedRingRotation == nil
			sign.goalRedRingRotation = 0
		end
		
		--Minor optimization.
		
		if sign.state == S_SIGN
			-- Ring rotation
			sign.angleRotation = ($ + 3) % 360
			if IsMemeStage == true
				sign.angle = sign.angle
			else
				sign.angle = FixedAngle(sign.angleRotation*FRACUNIT)
			end
		end
		
		if CV_GoalRingType.value == 1
		or CV_GoalRingType.value == 3
		and not IsMRCESpecialStage
		and not IsMRSpecialStage
		and not IsVanillaSpecialStage
		//or CV_GoalRingType.value == 3
		or IsMemeStage == true
			if sign.state >= S_SIGN and sign.state <= S_CLEARSIGN
				local signStarSpawned = 0 -- Heroes Center Star	
				if signStarSpawned == 0
				and sign.valid
					sign.signStar = P_SpawnMobj(sign.x, sign.y, sign.z, MT_THOK)
					if CV_GoalRingType.value == 3
					//and usingModels
						sign.signStar.sprite = SPR_GLRM
						sign.signStar.frame = B|FF_FULLBRIGHT|FF_PAPERSPRITE
					else
						sign.signStar.sprite = SPR_GLRG
						sign.signStar.frame = T|FF_FULLBRIGHT|FF_PAPERSPRITE
					end
					sign.signStar.flags = sign.flags
					
					if CV_GoalRingType.value == 3
					and CV_FindVar("renderer").value == 1
						sign.signStar.flags2 = $1 | MF2_DONTDRAW
					else
						sign.signStar.flags2 = $1 & ~MF2_DONTDRAW
					end
					
					sign.signStar.eflags = sign.eflags
					sign.signStar.scale = sign.scale
					sign.signStar.tics = 2
					sign.signStar.dispoffset = 2
					signStarSpawned = 1
				end
				if signStarSpawned
				and sign.valid
					sign.goalStarRotation = ($ + 1) % 360
					if IsMemeStage == true -- SL_2006 Stages
						sign.signStar.angle = FixedAngle(sign.angleRotation*FRACUNIT*2)
					elseif CV_GoalRingType.value == 3
						sign.signStar.angle = sign.angle + ANGLE_90 //FixedAngle(sign.angleRotation*FRACUNIT)
					else
						sign.signStar.angle = FixedAngle(sign.goalStarRotation*FRACUNIT)
					end
					P_SetScale(sign.signStar, sign.scale)
					P_TeleportMove(sign.signStar, sign.x, sign.y, sign.z)
				end	
				
				local signRedRingSpawned = 0 -- Heroes Red Ring Thing
				if signRedRingSpawned == 0
				and sign.valid
					sign.signRedRing = P_SpawnMobj(sign.x, sign.y, sign.z, MT_THOK)
					if CV_GoalRingType.value == 3
					and CV_FindVar("renderer").value == 2
						sign.signRedRing.sprite = SPR_GLRM
						sign.signRedRing.frame = C|FF_FULLBRIGHT|FF_PAPERSPRITE
					elseif CV_GoalRingType.value == 3
						sign.signRedRing.sprite = SPR_GLRM
						sign.signRedRing.frame = C|FF_FULLBRIGHT|FF_PAPERSPRITE
					else
						sign.signRedRing.sprite = SPR_GLRG
						sign.signRedRing.frame = U|FF_FULLBRIGHT|FF_PAPERSPRITE
					end
					
					if CV_GoalRingType.value == 3
						sign.signRedRing.color = SKINCOLOR_MODERNGOALRING
					else
						sign.signRedRing.color = SKINCOLOR_RED -- Just in case
					end
					
					sign.signRedRing.flags = sign.flags
					sign.signRedRing.flags2 = $1 & ~MF2_DONTDRAW
					sign.signRedRing.eflags = sign.eflags
					sign.signRedRing.scale = sign.scale
					sign.signRedRing.dispoffset = 0
					sign.signRedRing.tics = 2
					signRedRingSpawned = 1
				end
				if signRedRingSpawned
				and sign.signRedRing.valid
					sign.goalRedRingRotation = ($ + 2) % 360
					if IsMemeStage == true -- SL_2006 Stages
					or CV_GoalRingType.value == 3
						if IsMemeStage == true
							sign.signRedRing.angle = sign.angle
						else
							sign.signRedRing.angle = sign.angle + ANGLE_90
						end
						sign.signRedRing.rollangle = 0
					else
						sign.signRedRing.angle = FixedAngle(sign.goalRedRingRotation*FRACUNIT)
						sign.signRedRing.rollangle = FixedAngle(sign.goalRedRingRotation*FRACUNIT)
					end
					P_SetScale(sign.signRedRing, sign.scale)
					if usingModels == true
					and CV_GoalRingType.value == 1
						P_TeleportMove(sign.signRedRing, sign.x, sign.y, sign.z + 56*FRACUNIT)
					else
						P_TeleportMove(sign.signRedRing, sign.x, sign.y, sign.z)
					end
				end
				if sign.target and sign.target.player and (sign.target.player.pflags & PF_FINISHED)
					if usingModels == true
						sign.signRedRing.angle = sign.angle
					//elseif usingModels
					//and CV_GoalRingType.value == 3
					//	sign.signRedRing.angle = sign.angle + ANGLE_90
					//	sign.signStar.angle = sign.angle + ANGLE_90
					elseif IsMemeStage == true
					and usingModels == true
						sign.signRedRing.angle = sign.angle + ANGLE_90
					else
						sign.signRedRing.angle = sign.angle + ANGLE_90
					end
					if CV_GoalRingType.value == 3
						sign.signStar.flags2 = $1 | MF2_DONTDRAW
						sign.signRedRing.frame = A|FF_FULLBRIGHT|FF_PAPERSPRITE
						sign.signStar.angle = sign.angle + ANGLE_90
						sign.signRedRing.angle = sign.angle + ANGLE_90
					else
						sign.signStar.angle = sign.angle + ANGLE_90
					end
				end
			end
		end
		
		if (sign.state == S_SIGN)
			-- Goal Sound timer
			sign.goalsound = $1 + 1
		end	
		if sign.goalsound == 1
		and sign.state == S_SIGN //and CV_GoalRingType.value != 2 --All but vanilla sign
			S_StartSoundAtVolume(sign, sfx_goalri, 150)
		end	
		
		//NiGHTS is stubborn so im forcing it lmao
		if IsVanillaSpecialStage == true
			//SignFadeIn
			if sign.fadeTimer == nil
				sign.fadeTimer = true
			end
			if sign.fadeTimer
				if sign.emertrans > 0
					if (leveltime % 5 == 0)
					sign.emertrans = $-FRACUNIT
					end
					if sign.emertrans <= 0
					sign.fadeTimer = false
					sign.emertrans = 0
					end
				end			
			end
			
			sign.tracer.frame = $ & ~FF_TRANSMASK --Remove all existing translucency
			sign.tracer.frame = $|sign.emertrans --Now apply the new one that is sign.emertrans
			
			local oneonly = false --Don't do this everytime for every player, plz, just one will do.
				for player in players.iterate
					if not oneonly and player.mo and player.mo.valid
						if player.exiting == 95 --We made it! Spin the ring, vanishing time!
							sign.state = S_SIGNSPIN1
						end
						if (sign.state >= S_SIGNSPIN1 and sign.state <= S_SIGNSPIN6)
							if sign.tracer.spritexscale > 0
								sign.tracer.spritexscale = $ - FRACUNIT/40
							else
								P_FlashPal(consoleplayer, PAL_WHITE, 15)
								S_StartSoundAtVolume(nil, sfx_s1c3, 255)
								P_RemoveMobj(sign)
								return
							end
						end
					oneonly = true
					end
				end
				
			if oneonly and sign and sign.valid --Player check complete.
				if not sign.fadeTimer --Not if we're still fading in.
					if (sign.state >= S_SIGNSPIN1 and sign.state <= S_SIGNSPIN6) --It's only in this state when we've exited.
					and (leveltime % 5 == 0)
						sign.emertrans = $+FRACUNIT
						if (sign.emertrans > TR_TRANS90) --We're done here. Vanish, ring!
							sign.emertrans = TR_TRANS90
						end
					end	
				end
				//postsign2 = sign --Add postthinkframe for good measure. 
			end
		else
			sign.tracer.frame = $ & ~FF_TRANSMASK
			sign.tracer.frame = $|FF_FULLBRIGHT
		end
		
		if sign.goalpassedsound == 0
		and sign.state == S_SIGNSPIN1
			S_StopSound(sign)
			S_StartSound(sign, sfx_endlvl)
			sign.goalpassedsound = 1
		end		
		if sign.spintimer == nil
			sign.spintimer = 0
		end
		sign.momz = 0
		sign.z = (sign.floorz + 1*FRACUNIT)
			
		if sign.target and sign.target.player and (sign.target.player.pflags & PF_FINISHED)
			sign.goalsound = 0
			sign.momz = sign.momz
			sign.spintimer = $1 + 1
		end
		if sign.spintimer >= 50
			sign.z = sign.floorz
			sign.spintimer = 50
		end
		
		if IsMRCESpecialStage
		or IsMRSpecialStage
			if IsVanillaSpecialStage return end
			if sign.state >= S_SIGNPLAYER and sign.state <= S_CLEARSIGN
				sign.tracer.tracer.flags2 = $1 & ~MF2_DONTDRAW
				signStopped = true
			else
				signStopped = false
			end
		end
	end
end, MT_SIGN)

--PostThinkFrame to force animations...
addHook("PostThinkFrame", do
/*
	if postsign2 
		if postsign2.valid
		postsign2.frame = $ & ~FF_TRANSMASK
		postsign2.frame =  $|postsign2.emertrans
		end
	end
*/
	if postsign1 
		if postsign1.valid
		--It's the pole sprite that gets in the way, so let's go nuclear.
			if postsign1.state > S_SIGN and postsign1.state <= S_CLEARSIGN
				if postsign1.sprite == SPR_SIGN and postsign1.frame == A
				postsign1.flags2 = $|MF2_DONTDRAW
				end
				if postsign1.tracer.sprite == SPR_SIGN and postsign1.tracer.frame == A
				postsign1.tracer.flags2 = $|MF2_DONTDRAW
				end
				if postsign1.tracer.tracer.sprite == SPR_SIGN and postsign1.tracer.tracer.frame == A
				postsign1.tracer.tracer.flags2 = $|MF2_DONTDRAW
				end	
				
				if postsign1.sprite != SPR_SIGN
				or postsign1.tracer.sprite != SPR_SIGN
				or postsign1.tracer.tracer.sprite != SPR_SIGN
					postsign1.frame = $1|FF_FULLBRIGHT
					postsign1.tracer.frame = $1|FF_FULLBRIGHT
					postsign1.tracer.tracer.frame = $1|FF_FULLBRIGHT
				else
					postsign1.frame = $1 & ~FF_FULLBRIGHT
					postsign1.tracer.frame = $1 & ~FF_FULLBRIGHT
					postsign1.tracer.tracer.frame = $1 & ~FF_FULLBRIGHT
				end
				
			end
			if postsign1.tracer and postsign1.tracer.tracer and (CV_GoalRingType.value != 2)
			or IsMRCESpecialStage == true -- Only MRCE because Vanilla doesnt use this
			or IsMRSpecialStage == true
				if (postsign1.tracer.tracer.sprite != SPR_GLRG and postsign1.tracer.tracer.sprite != SPR_GLR2)
				postsign1.tracer.tracer.spriteyoffset = 8*FRACUNIT --Go up higher, please
				else
				postsign1.tracer.tracer.spriteyoffset = 0 --NVM!
				end
				if (postsign1.tracer.tracer.sprite == SPR_PLAY)
				and P_IsValidSprite2(postsign1.tracer.tracer, SPR2_GEND)
					spr2defaults[SPR2_GEND] = SPR2_SIGN
					postsign1.tracer.tracer.sprite2 = SPR2_GEND -- Have your character have their own GoalRing End Sign Sprite!
					postsign1.tracer.tracer.frame = A|FF_FULLBRIGHT|FF_PAPERSPRITE
					postsign1.tracer.tracer.spriteyoffset = 0
				
				end
				if postsign1.state >= S_SIGNPLAYER and postsign1.state <= S_CLEARSIGN
				and usingModels == true -- This seems dependant on vid_mode, unfortunately.
					if postsign1.yuendcam and postsign1.yuendcam.valid -- No AdventureSonic camera!
						P_TeleportMove(postsign1.tracer.tracer, postsign1.tracer.tracer.x+FixedMul(8*postsign1.scale, cos(postsign1.angle+(ANGLE_180))), postsign1.tracer.tracer.y+FixedMul(8*postsign1.scale, sin(postsign1.angle+(ANGLE_180))), postsign1.tracer.tracer.z)
					else
						P_TeleportMove(postsign1.tracer.tracer, postsign1.tracer.tracer.x+FixedMul(8*postsign1.scale, cos(postsign1.angle)), postsign1.tracer.tracer.y+FixedMul(8*postsign1.scale, sin(postsign1.angle)), postsign1.tracer.tracer.z)
					end
				else
					P_TeleportMove(postsign1.tracer.tracer, postsign1.tracer.tracer.x, postsign1.tracer.tracer.y, postsign1.tracer.tracer.z)
				end
			end
		end
	postsign1 = nil
	end
end)