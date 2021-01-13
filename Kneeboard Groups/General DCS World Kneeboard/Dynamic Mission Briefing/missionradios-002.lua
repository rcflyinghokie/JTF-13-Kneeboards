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

y = y + 0.10

		add_picture(lightbanner,
				.09,
				y,
				1.82, -- HORIZONTAL SIZE
				.07,  --VERTICAL SIZE
				0,
				0,
				1,
				1) 
	
		add_text("Other AI Flight Frequencies:",mediumText,12,
			0.10,
			y)	
			y = y + .10
			
function AddOtherFlights(otherFlightTable)

	local ySpacing = .065
	if next(otherFlightTable) ~= nil then
	
		local allFlights = {}
			for group_num, group_data in pairs(otherFlightTable) do
				local flightData = {}
				flightData.unitFrequency = group_data.frequency .. " " .. missionData.radioModulation[group_data.modulation]
				flightData.unitTask = group_data.task		
				local unit_data = group_data.units[1]
					flightData.unitType = unit_data.type
					if type(unit_data.callsign) ~= 'table' then
						flightData.unitName = unit_data.callsign
					else
						local tempcallsign = string.sub(unit_data.callsign.name,0,string.len(unit_data.callsign.name) - 1)
						local callnumber = string.sub(tempcallsign, -1, -1)
						tempcallsign = string.sub(tempcallsign,0,string.len(tempcallsign) - 1)
						flightData.unitName = string.sub(tempcallsign.." "..callnumber,1,22)
					end
					flightData.unitSkill = unit_data.skill
				table.insert(allFlights, flightData)
			end
				
		if next(allFlights) ~= nil then	
				local i = 1
				local row = 1	
				local htabs = { -.74, -.14, .45 }
				local vtabs = {y}
			for flight_num, flight_data in pairs(allFlights) do
				if flight_data.unitSkill ~= "Client" then
					add_custom_text("Call: ",string.upper(flight_data.unitName),smallText,12,12,subTextColor,
					htabs[i],
					vtabs[row])
					
					y = vtabs[row] + ySpacing
					
					add_custom_text("Freq: ",flight_data.unitFrequency,smallText,12,12,subTextColor,
					htabs[i],
					y)
					y = y + ySpacing
					
					add_custom_text("Type: ",flight_data.unitType,smallText,12,12,subTextColor,
					htabs[i],
					y)							
					y = y + ySpacing
					
					local tempTask = string.sub(flight_data.unitTask,1,14)
					add_custom_text("Task: ",tempTask,smallText,12,12,subTextColor,
					htabs[i],
					y)							
					y = y + .10
					
					if i < 3 then
						i = i + 1
					else
						i = 1
						row = row + 1
						table.insert(vtabs, y)
					end
				end
			end
		end

	else
		add_custom_text("","There are no other flights.",smallText,12,12,subTextColor,
		-.90,
		y)
	
	end
end
				
if missionData.pilotcoalition == "blue" then

	AddOtherFlights(missionData.blueotherflights)
	
elseif missionData.pilotcoalition == "red" then

	AddOtherFlights(missionData.redotherflights)
	
else

	AddOtherFlights(missionData.allotherflights)
	
end



		
				
				
				
				
				
				
				