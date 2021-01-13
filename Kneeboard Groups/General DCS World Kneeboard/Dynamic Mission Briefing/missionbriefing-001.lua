local lfs = require('lfs')
userPath = lfs.writedir()..'Data\\Kneeboard Builder Config\\Kneeboard Data\\'   -- set userpath directory
local missionData = dofile( userPath..'missiondata.lua') -- load mission data from mission
local functions = dofile(userPath..'functions.lua') -- load functions
dofile(userPath..'drawingdefinitions.lua') -- open drawingdefinitions.lua

local lightbanner  -- path to the lightbanner image
local darkbanner  -- path to the darkbanner image
local subTextColor --text color for the non-label and non-header text

-- set the background colors based upon the player's coalition
if missionData.pilotcoalition == 'blue' then
	darkbanner = userPath..'\\images\\blue_banner.png'
	lightbanner = userPath..'\\images\\light_blue_banner.png'
	subTextColor = {0,80,255,255}
else
	darkbanner = userPath..'\\images\\red_banner.png'
	lightbanner = userPath..'\\images\\light_red_banner.png'
	subTextColor = {156,0,5,255}
end


-- the mig-21 doesn't play like the rest, so we will need to scale and modify some variables to make things fit and look right
local scale = 1  -- default scale for the non-mig21 kneeboards
local modifier = .33 -- default modifier for the non-mig21 kneeboards (modifier is only used to help center the main heading text)
-- if missionData.pilottype == "MiG-21Bis" then
	-- scale = .6 -- kneeboard will be zoomed out a bit to display correctly 
	-- modifier = .53  -- since we are zoomed out a bit, we will need this modifier to help center the main heading text correctly
-- end

-- sets the three fontsizes and scales them according to the scale set above
local largeText = .006 * scale   
local mediumText = .005 * scale
local smallText = .004 * scale


-- set the unit of measure based on the players aircraft type (set in 'missiondata.lua')
local unitMeasureSystem = missionData.pilotmeasure
local tempUnit = "* C"
local heightUnit = " m"
local speedUnit = " m/s"
local qnhUnit = " mmHG"
local windHeightUnit = " meters"
local windHeight1 = 500
local windHeight2 = 2000
local windHeight3 = 8000

if unitMeasureSystem == "us" then  -- if not metric, set to the US system of measurement
	tempUnit = "* F"
	heightUnit = " ft"
	speedUnit = " kts"
	qnhUnit = " inHG"
	windHeightUnit = " feet"
	windHeight1 = functions.toFeet(windHeight1, unitMeasureSystem)
	windHeight2 = functions.toFeet(windHeight2, unitMeasureSystem)
	windHeight3 = functions.toFeet(windHeight3, unitMeasureSystem)
	
end

SetScale(FOV) -- set FOV (dcs native function)

local p = 0 -- variable for y position that will increment

add_picture(userPath..'\\images\\blankpaper.png',  -- add the blank paper texture background  (function located in 'drawingDefinitions.lua')
				0, -- X POSITION
				0, -- Y POSITION
				1.35*GetAspect(), -- HORIZONTAL SIZE
				2*GetAspect(),  --VERTICAL SIZE
				0,
				0,
				1,
				1)

add_picture(darkbanner,  -- add the darker header background
				.09, -- X POSITION
				.07, -- Y POSITION
				1.82, -- HORIZONTAL SIZE
				.13,  --VERTICAL SIZE
				0,
				0,
				1, 
				1) 
				
add_picture(userPath..'\\images\\border.png',  -- add the black border image
				.05, -- X POSITION
				.03, -- Y POSITION
				1.25*GetAspect(), -- HORIZONTAL SIZE
				1.96*GetAspect(),  --VERTICAL SIZE
				0,
				0,
				1,
				1)

p = p + 0.10  -- increment the y position by .10 to move down a line				
add_header_text("MISSION BRIEFING",largeText,12,  -- add the main header text  (function located in 'drawingDefinitions.lua')
				functions.Center(1.25*GetAspect(), "MISSION BRIEFING", modifier*largeText),  -- we used the modifier here
				p)	--add_text(stringValue, fontSize, font, Xposition, Yposition)

p = p + .10	 -- increment the y position		
add_picture(lightbanner,  -- add the lighter subheader background
				.09, -- X POSITION
				p, -- Y POSITION
				1.82, -- HORIZONTAL SIZE
				.07,  --VERTICAL SIZE
				0,
				0,
				1, 
				1) 
				
add_text("Weather:",mediumText,12,  -- add a level 1 subheader  (function located in 'drawingDefinitions.lua')
				0.10,
				p) --  add_text(stringValue, fontSize, font, Xposition, Yposition)
				
				
p = p + .10
local pr = p  -- pr will be the y position to increment for the second column 

add_text("GENERAL",smallText,12,  --add a level 2 subheader for weather
				.36,
				p)	
				
p = p + .065

-- uses the conversion functions in 'functions.lua' to convert the weather values to match the system of measure (either metric or us standard)
add_custom_text("Temperature: ",functions.toFahrenheit(missionData.temperature, unitMeasureSystem) .. tempUnit,smallText,12,12,subTextColor,  -- add text with two text strings; first is the label the second is the value.  
				-.48,
				p)	-- add_custom_text (labelString, valueString, textSize, labelFont, valueFont, valueColor, Xposition, Yposition)  (function located in 'drawingDefinitions.lua')

p = p + .065
add_custom_text("Cloud Base: ",functions.toFeet(missionData.cloudbase, unitMeasureSystem) .. heightUnit,smallText,12,12,subTextColor,
				-.48,
				p)	

p = p + .065
add_custom_text("Cloud Ceiling: ",functions.toFeet(missionData.cloudceiling, unitMeasureSystem) .. heightUnit,smallText,12,12,subTextColor,
				-.48,
				p)					
				
p = p + .065
add_custom_text("QNH: ",functions.toInHG(missionData.qnh, unitMeasureSystem) .. qnhUnit,smallText,12,12,subTextColor,
				-.48,
				p)	


add_text("WIND",smallText,12,  --another level 2 subheader for weather
				1.34,
				pr)	-- now on the second column so using pr instead of p
				
pr = pr + .065  -- increment pr
add_custom_text("at Ground: ",functions.toKnots(missionData.atGroundspeed, unitMeasureSystem) .. speedUnit .. "  "..functions.toCorrectDirection(missionData.atGrounddir).."* "..missionData.temperature.."* C",smallText,12,12,subTextColor,
				.40,
				pr)	
				
pr = pr + .065
add_custom_text("at ".. windHeight1 .. windHeightUnit ..": ",functions.toKnots(missionData.atGroundspeed * 2, unitMeasureSystem) .. speedUnit .. "  "..functions.toCorrectDirection(missionData.atGrounddir).."* "..functions.toTemperatureByHeight(missionData.temperature, windHeight1, unitMeasureSystem).."* C",smallText,12,12,subTextColor,
				.40,
				pr)
		
pr = pr + .065
add_custom_text("at ".. windHeight2 .. windHeightUnit ..": ",functions.toKnots(missionData.at2000speed, unitMeasureSystem) .. speedUnit .. "  "..functions.toCorrectDirection(missionData.at2000dir).."* "..functions.toTemperatureByHeight(missionData.temperature, windHeight2, unitMeasureSystem).."* C",smallText,12,12,subTextColor,
				.40,
				pr)
		
pr = pr + .065
add_custom_text("at ".. windHeight3 .. windHeightUnit ..": ",functions.toKnots(missionData.at8000speed, unitMeasureSystem) .. speedUnit .. "  "..functions.toCorrectDirection(missionData.at8000dir).."* "..functions.toTemperatureByHeight(missionData.temperature, windHeight3, unitMeasureSystem).."* C",smallText,12,12,subTextColor,
				.40,
				pr)							
				
p = p + .10   -- back to p for the y position for the next level 1 subheader
add_picture(lightbanner,
				.09, -- X POSITION
				p, -- Y POSITION
				1.82, -- HORIZONTAL SIZE
				.07,  --VERTICAL SIZE
				0,
				0,
				1, 
				1) 	

			
add_text("Situation:",mediumText,12,  -- add next level 1 subheader
				0.10,
				p)	
				
p = p + .075

local wrappedDescription -- the description text may be long, so will need to be text wrapped.  variable to hold textWrapped string.
	if missionData.description ~= "" then				
		
		--wrappedDescription = functions.textWrap( missionData.description, 68, nil, nil )  -- wrap the description text. calls the textWrap function found in 'functions.lua'.  functions.textWrap(text, maxLineCharacterCount, indent1, indent2)
		wrappedDescription = functions.WordWrap (missionData.description, 68)
	else	
	
		wrappedDescription = functions.textWrap( "A situation briefing is not available.", 68, nil, nil ) -- filler text if a description is not available in the mission.
		
	end

add_custom_text("",wrappedDescription,smallText,12,12,subTextColor,
				-.90,
				p)
p = functions.getTextBlockHeight(wrappedDescription,68,.12) + p  -- gets the line height for the description text so we know the y position for the next section (function located in 'functions.lua')




		
				
				
				
				
				
				