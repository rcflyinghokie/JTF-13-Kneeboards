local lfs = require('lfs')
userPath = lfs.writedir()..'Data\\Kneeboard Builder Config\\Kneeboard Data\\'

dofile(userPath..'drawingdefinitions.lua')
dofile(userPath..'airports.lua')
local missionData = dofile( userPath..'missiondata.lua')
local functions = dofile(userPath..'functions.lua')

SetScale(FOV)

local lightbanner
local darkbanner
local subTextColor

if missionData.pilotcoalition == 'blue' then

	darkbanner = userPath..'\\images\\blue_banner.png'
	lightbanner = userPath..'\\images\\light_blue_banner.png'
	subTextColor = {0,80,255,255}
else

	darkbanner = userPath..'\\images\\red_banner.png'
	lightbanner = userPath..'\\images\\light_red_banner.png'
	subTextColor = {156,0,5,255}
end

local scale = 1
local modifier = .33
-- if missionData.pilottype == "MiG-21Bis" then
	-- scale = .6
	-- modifier = .53
-- end

local largeText = .006 * scale
local mediumText = .005 * scale
local smallText = .004 * scale

local y = 0

add_picture(userPath..'\\images\\blankpaper.png',
				0,
				0,
				1.35*GetAspect(), -- HORIZONTAL SIZE
				2*GetAspect(),  --VERTICAL SIZE
				0,
				0,
				1,
				1)

add_picture(darkbanner,
				.09,
				.07,
				1.82, -- HORIZONTAL SIZE
				.13,  --VERTICAL SIZE
				0,
				0,
				1, 
				1)
				
add_picture(userPath..'\\images\\border.png',
				.05,
				.03,
				1.25*GetAspect(), -- HORIZONTAL SIZE
				1.96*GetAspect(),  --VERTICAL SIZE
				0,
				0,
				1, 
				1)

y = y + 0.10				
add_header_text("RADIO COMMUNICATION",largeText,12,
				functions.Center(1.25*GetAspect(), "RADIO COMMUNICATION", modifier*largeText),
				y)

y = y + 0.13

if missionData.pilotgroupfreq ~= nil then
add_custom_text("My Flight Frequency: ",missionData.pilotgroupfreq .. " " .. missionData.radioModulation[missionData.pilotmodulation],mediumText,12,12,subTextColor,
	.00,
	y)
end		
	
				
if missionData.radiodata then 			

	y = y + .10			
	add_picture(lightbanner,
					.09,
					y,
					1.82, -- HORIZONTAL SIZE
					.07,  --VERTICAL SIZE
					0,
					0,
					1, 
					1) 

	add_text("Preset Radio Frequencies:",mediumText,12,
					0.10,
					y)	
					
	y = y + .1				

		local i = 1
		local cx = -.80
		local cy = y
		local fy = 0
		for channel_num, channel_data in functions.spairs(missionData.radiodata) do
		
			if i == 10 then
				cx = .10
				fy = y
				y = cy
			end
		
		
			local channelName = functions.FindRadio(missionData.allRadios, channel_data, missionData.pilotcoalition)
			
			local channelString = ""
			if channelName ~= nil then
				channelString = channel_data.." -- "..channelName
			else
				channelString = channel_data
			end
		
			add_custom_text(channel_num..": ",channelString,smallText,12,12,subTextColor,
				cx,
				y)
				y = y + .07
				
			 i = i + 1
		end
	if y < fy then
		y = fy
	end
	
end


if missionData.pilottype == "P-51D" and missionData.radioButtonA then 	
	y = y + .10			
	add_picture(lightbanner,
					.09,
					y,
					1.82, -- HORIZONTAL SIZE
					.07,  --VERTICAL SIZE
					0,
					0,
					1,
					1) 
					
	add_text("Preset Radio Frequencies:",mediumText,12,
					0.10,
					y)	
					
	y = y + .10				
			add_custom_text("Radio Button A: ",missionData.radioButtonA,smallText,12,12,subTextColor,
				-.30,
				y)
				
			y = y + .1
			add_custom_text("Radio Button B: ",missionData.radioButtonB,smallText,12,12,subTextColor,
			-.30,
			y)
			
			y = y + .1
			add_custom_text("Radio Button C: ",missionData.radioButtonC,smallText,12,12,subTextColor,
			-.30,
			y)
			
			y = y + .1
			add_custom_text("Radio Button D: ",missionData.radioButtonD,smallText,12,12,subTextColor,
			-.30,
			y)
				
end



if missionData.pilottype == "MiG-21Bis" and missionData.mig_radio_data then 	
	y = y + .10			
	add_picture(lightbanner,
					.09,
					y,
					1.82, -- HORIZONTAL SIZE
					.07,  --VERTICAL SIZE
					0,
					0,
					1, 
					1)
					
	add_text("Preset Radio Frequencies:",mediumText,12,
					0.10,
					y)	
					
	y = y + .10				
		local i = 1
		local cx = -.80
		local cy = y
		local fy = 0
		for channel_num, channel_data in functions.spairs(missionData.mig_radio_data) do
		
			if i == 10 then
				cx = .10
				fy = y
				y = cy
			end
		
		
			local channelName = functions.FindRadio(missionData.allRadios, channel_data, missionData.pilotcoalition)
			
			local channelString = ""
			if channelName ~= nil then
				channelString = channel_data.." -- "..channelName
			else
				channelString = channel_data
			end
		
			channel_num = string.sub(channel_num, 13,14)
			add_custom_text(channel_num..": ",channelString,smallText,12,12,subTextColor,
				cx,
				y)
				y = y + .07
				
			 i = i + 1
		end
	if y < fy then
		y = fy
	end
				
end


y = y + .10			

local topY = y
local maxY = 0
local tankermaxY = y
local i = 1
local xPosition = { 0.18, 0.82, 1.41}
local row = 1

		add_picture(lightbanner,
				.09,
				y,
				1.82, -- HORIZONTAL SIZE
				.07,  --VERTICAL SIZE
				0,
				0,
				1,
				1)
	
		add_text("Mission Critical Radio Frequencies:",mediumText,12,
		0.10,
		y)	
		y = y + .10
		
		topY = y
		tankermaxY = y

function AddTankersAwacsJtacsFarps(tankersTable, awacsTable, jtacTable, farpsTable, coalition)

	if next(tankersTable) ~= nil or next(awacsTable) ~= nil or next(jtacTable) ~= nil or next(farpsTable) ~= nil then
		
		topY = y
		tankermaxY = y
		
		local ySpacing = .065
		if next(tankersTable) ~= nil then
			local allTankers = {}
			
			for group_num, group_data in pairs(tankersTable) do
				local tankerData = {}
				tankerData.unitFrequency = group_data.frequency .. " " .. missionData.radioModulation[group_data.modulation]
							
				for unit_num, unit_data in pairs(group_data.units) do
					tankerData.unitType = unit_data.type
					
					if type(unit_data.callsign) ~= 'table' then
						tankerData.unitName = unit_data.callsign
					else
						local tempName = string.sub(unit_data.callsign.name,0,string.len(unit_data.callsign.name) - 2)
						tankerData.unitName = tempName
					end
					
				end


				local tModeChannel = nil
				local tChannel = nil
				
				for waypoint_num, waypoint_data in pairs(group_data.route.points) do
					for task_num, task_data in pairs(waypoint_data.task.params.tasks) do
						if task_data.id == "WrappedAction" then
							if task_data.params.action.id == "ActivateBeacon" then
								if tModeChannel == nil then
									tModeChannel = task_data.params.action.params.modeChannel
									local tempTacanChannel = task_data.params.action.params.channel
									tChannel = string.format("%02d", tempTacanChannel)
								end
							end
						end
					end
				end
			
				tankerData.tacanModeChannel = tModeChannel
				tankerData.tacanChannel = tChannel	
					
				table.insert(allTankers, tankerData)	
				
			end
			
			
			if next(allTankers) ~= nil then
					local _xposition = xPosition[i]
					add_text("TANKERS",smallText,12,
						_xposition,
						topY)
					y = topY + .08
					
				for tanker_num, tanker_data in pairs(allTankers) do
					
					add_custom_text("Call: ",string.upper(tanker_data.unitName),smallText,12,12,subTextColor,
					_xposition -.86,
					y)
					
					y = y + ySpacing
					
					add_custom_text("Freq: ",tanker_data.unitFrequency,smallText,12,12,subTextColor,
					_xposition -.86,
					y)
					y = y + ySpacing
					
					if tanker_data.tacanChannel ~= nil then

						add_custom_text("TACAN: ",tanker_data.tacanChannel..tanker_data.tacanModeChannel,smallText,12,12,subTextColor,
						_xposition -.86,
						y)
						y = y + ySpacing
					
					end
					
					local t = functions.mysplit(tanker_data.unitType, sep)
					add_custom_text("Type: ",t[1],smallText,12,12,subTextColor,
					_xposition -.86,
					y)							
					y = y + .10
				end
					tankermaxY = y
					if maxY < y then
						maxY = y
					end
					
					i = i + 1
					
					if i > 3 then
						row = row + 1
						i = 1
					end
					

			end
		end

		if next(awacsTable) ~= nil then

			local allAwacs = {}
			
			for group_num, group_data in pairs(awacsTable) do
				local awacsData = {}	
				awacsData.unitFrequency = group_data.frequency .. " " .. missionData.radioModulation[group_data.modulation]

				for unit_num, unit_data in pairs(group_data.units) do
					awacsData.unitType = unit_data.type

					if type(unit_data.callsign) == 'table' then
						local tempName = string.sub(unit_data.callsign.name,0,string.len(unit_data.callsign.name) - 2)
						awacsData.unitName = tempName
					else
						awacsData.unitName = unit_data.callsign
					end
					
				end
				
				table.insert(allAwacs, awacsData)

			end

			if next(allAwacs) ~= nil then
				local _xposition = xPosition[i]
				add_text("AWACS",smallText,12,
					_xposition,
					topY)
				y = topY + .08
					
				for awacs_num, awacs_data in pairs(allAwacs) do
				
					add_custom_text("Call: ",string.upper(awacs_data.unitName),smallText,12,12,subTextColor,
					_xposition -.90,
					y)
					
					y = y + ySpacing
					
					add_custom_text("Freq: ",awacs_data.unitFrequency,smallText,12,12,subTextColor,
					_xposition -.90,
					y)
					
					y = y + ySpacing
					
					add_custom_text("Type: ",awacs_data.unitType,smallText,12,12,subTextColor,
					_xposition -.90,
					y)
				
					y = y + .1
					
				end

				if maxY < y then
					maxY = y
				end
				i = i + 1
				if i > 3 then
					row = row + 1
					i = 1
				end
			end
		
		end
		
		if next(jtacTable) ~= nil then  -- check if jtacTable contains any data
			
			local allJTACdetail = {}
			for group_num, group_data in pairs(jtacTable) do  -- loop through vehicle groups in jtacTable
				if group_data.coalition == coalition or coalition == nil then
					local jtacData = {}  			
					jtacData.callname = group_data.callname
					jtacData.frequency = group_data.frequency .. " " .. group_data.modulation
					jtacData.type = group_data.unitType
					table.insert(allJTACdetail, jtacData)  -- insert data into allJTAC table
				end
			end -- end group_num, group_data loop
		
			if next(allJTACdetail) ~= nil then
				
				local _xposition = xPosition[i]
				add_text("FAC",smallText,12,
					xPosition[i],
					topY)
				y = topY + .08
					
				for jtac_num, jtac_data in pairs(allJTACdetail) do
				
					add_custom_text("Call: ",string.upper(jtac_data.callname),smallText,12,12,subTextColor,
					xPosition[i] -.93,
					y)
					
					y = y + ySpacing
					
					add_custom_text("Freq: ",jtac_data.frequency,smallText,12,12,subTextColor,
					xPosition[i] -.93,
					y)
					
					y = y + ySpacing
					
					add_custom_text("Type: ",jtac_data.type,smallText,12,12,subTextColor,
					xPosition[i] -.93,
					y)
				
					y = y + .1
					
				end
				if maxY < y then
					maxY = y
				end
				i = i + 1
				if i > 3 then
					row = row + 1
					i = 1
				end
			end
		end -- jtacTable populated check
		
		if next(farpsTable) ~= nil then

			local allFarps = {}
			
			for farp_num, farp_data in pairs(farpsTable) do
			
				if farp_data.coalition == coalition then
					local farpsData = {}	
					farpsData.unitName = farp_data.callnameonly
					farpsData.unitFrequency = farp_data.frequency
					farpsData.unitModulation = farp_data.modulation
					farpsData.unitType = farp_data.type
					
					table.insert(allFarps, farpsData)
				end

			end

			if next(allFarps) ~= nil then
				local _xposition = xPosition[i]
				if row > 1 then
					y = tankermaxY
				else
					y = topY
				end
				add_text("FARPS",smallText,12,
					_xposition,
					y)
				y = y + .08
					
				for farp_num, farp_data in pairs(allFarps) do
				
					add_custom_text("Call: ",string.upper(farp_data.unitName),smallText,12,12,subTextColor,
					_xposition -.90,
					y)
					
					y = y + ySpacing
					
					add_custom_text("Freq: ",farp_data.unitFrequency.. " " .. farp_data.unitModulation ,smallText,12,12,subTextColor,
					_xposition -.90,
					y)
					
					y = y + ySpacing
					
					add_custom_text("Type: ",farp_data.unitType,smallText,12,12,subTextColor,
					_xposition -.90,
					y)
				
					y = y + .1
					
				end

				if maxY < y then
					maxY = y
				end
				i = i + 1
				if i > 3 then
					row = row + 1
				end
			end
		
		end
		
		if y < maxY then
			y = maxY
		end
	
	else
	add_custom_text("","There are no mission critical radio frequencies.",smallText,12,12,subTextColor,
				-.90,
				y)
	end



	
end


if missionData.pilotcoalition == "blue" then
	
	AddTankersAwacsJtacsFarps(missionData.bluetankers, missionData.blueawacs, missionData.allJTAC, missionData.allFARPradios, 'blue')

elseif missionData.pilotcoalition == "red" then
	
	AddTankersAwacsJtacsFarps(missionData.redtankers, missionData.redawacs, missionData.allJTAC, missionData.allFARPradios, 'red')

else

	AddTankersAwacsJtacsFarps(missionData.alltankers, missionData.allawacs, missionData.allJTAC, missionData.allFARPradios, nil)
	
end



		
				
				
				
				
				
				
				