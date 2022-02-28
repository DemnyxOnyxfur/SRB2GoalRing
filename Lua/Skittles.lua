// Rainbow skincolor for the Modern Goal Ring \\

// Color
freeslot("SKINCOLOR_MODERNGOALRING")
skincolors[SKINCOLOR_MODERNGOALRING] = {
	name = "ModernGoalRing",
	ramp = {32,33,48,49,73,74,96,97,130,131,145,146,160,161,178,180},
	invcolor = SKINCOLOR_MODERNGOALRING,
	accessible = false
}

//change this to your desired skincolors
local flashColors = {
	skincolors[SKINCOLOR_MODERNGOALRING]
}
local flashDelay = 4 //change this to how many tics it takes to animate

local rampPos = 1
local rampDir = true
local ramps = {}

for curcol = 1, table.maxn(flashColors), 1
	//convert the ramp to a table
	ramps[curcol] = {{}}
	for i = 0, 15, 1
		ramps[curcol][1][i+1] = flashColors[curcol].ramp[i]
	end

	//create the offset versions of the ramp
	for i = 2, 16,1
		ramps[curcol][i] = {{}}

		for pos,val in ipairs(ramps[curcol][i-1]) do
			if not (pos == 16) then
				ramps[curcol][i][pos+1] = val
			else
				ramps[curcol][i][1] = val
			end
		end
	end
end

local function RampWave()
	if not (leveltime % flashDelay) then

		rampPos = $1+1
		
		//too high, time to go back
		if not (ramps[1][rampPos])
			rampPos = 1
		end
		
		for i = 1, table.maxn(ramps), 1
			flashColors[i].ramp = ramps[i][rampPos]
		end
	end
end

addHook("ThinkFrame", RampWave)