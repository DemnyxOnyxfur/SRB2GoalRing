// Thank you for letting me use this!
//Xian.exe was here
addHook("PlayerThink", function(p)
	if gamemap == 123 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD1) != 1)
		emeralds = $ + 1
		S_StartSound(null, sfx_cgot)
	elseif gamemap == 124 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD2) != 2)
		emeralds = $ + 2
		S_StartSound(null, sfx_cgot)
	elseif gamemap == 125 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD3) != 4)
		emeralds = $ + 4
		S_StartSound(null, sfx_cgot)
	elseif gamemap == 126 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD4) != 8)
		emeralds = $ + 8
		S_StartSound(null, sfx_cgot)
	elseif gamemap == 127 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD5) != 16)
		emeralds = $ + 16
		S_StartSound(null, sfx_cgot)
	elseif gamemap == 128 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD6) != 32)
		emeralds = $ + 32
		S_StartSound(null, sfx_cgot)
	elseif gamemap == 129 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD7) != 64)
		emeralds = $ + 64
	end
end)