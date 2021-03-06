local lfs = require('lfs')
userPath = lfs.writedir()..'Data\\Kneeboard Builder Config\\Kneeboard Data\\'

local simPath = './'
local translatePath = simPath .. 'Scripts/Aircrafts/_Common/Cockpit/Transliterate.lua'
local beaconsPath = simPath .. 'Mods/terrains/CaucasusBase/beacons.lua'

dofile(beaconsPath)
dofile(translatePath)
dofile(userPath..'drawingdefinitions.lua')
local missionData = dofile( userPath..'missiondata.lua')
local functions = dofile(userPath..'functions.lua')
dofile(userPath..'morse.lua')

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
local smallerText = .00325 * scale

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
add_header_text("NAVIGATION BEACONS",largeText,12,
				functions.Center(1.25*GetAspect(), "NAVIGATION BEACONS", modifier*largeText),
				y)
y = y + 0.10			
add_picture(lightbanner,  -- add the lighter subheader background
				.09, -- X POSITION
				y, -- Y POSITION
				1.82, -- HORIZONTAL SIZE
				.07,  --VERTICAL SIZE
				0,
				0,
				1, 
				1) 
				
add_text("Page 2",mediumText,12,  -- add a level 1 subheader  (function located in 'drawingDefinitions.lua')
				functions.Center(1.25*GetAspect(), "Page 2", modifier*largeText),
				y) --  add_text(stringValue, fontSize, font, Xposition, Yposition)

y = y + 0.13

local i = 0
local ai = 1
x = .10
xp = -.90
startY = y
for beacon_name, beacon_data in functions.spairs(beacons) do
	-- for _airdrome, _airdrome_data in pairs(airdrome_data) do
		-- for runway_name, runway_data in pairs(_airdrome_data)

			if ai > 28 and ai < 57  then
				if beacon_data.type == 8 then
				
					local tempName = TransliterateToLat(beacon_name)
					tempName = functions.mysplit(tempName, '-')
					add_text(tempName[1], smallText, 12,x,y)
					y = y + .065
					
					local callsign = TransliterateMorzeToLatDefault(beacon_data.callsign)
					add_custom_text("",functions.ParseBeaconFrequency(beacon_data.frequency).. " AM  " .. TransliterateToMorse(callsign), smallText, 12,12, subTextColor,xp,y)
					y = y + .065
					
					local lat, lon = functions.getLatLon(beacon_data.position.latitude,beacon_data.position.longitude)
					add_custom_text("",lat, smallerText, 12,12,subTextColor,xp,y)
					y = y + .065
					add_custom_text("",lon, smallerText, 12,12,subTextColor,xp,y)
					y = y + .1
						
					i = i + 1		
				end
					
				if i == 10 then
					x = .70
					xp = -.30
					y = startY
				elseif i == 19 then
					x = 1.3
					xp = .3
					y = startY
				end
			end
			if beacon_data.type == 8 then
				ai = ai + 1
			end
				
		-- end
	-- end
end
