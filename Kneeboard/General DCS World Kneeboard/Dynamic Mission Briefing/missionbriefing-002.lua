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

if unitMeasureSystem == "us" then  -- if not metric, set to the US system of measurement
	tempUnit = "* F"
	heightUnit = " ft"
	speedUnit = " kts"
	qnhUnit = " inHG"
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
add_header_text("MISSION TASKING",largeText,12,  -- add the main header text  (function located in 'drawingDefinitions.lua')
				functions.Center(1.25*GetAspect(), "MISSION TASKING", modifier*largeText),  -- we used the modifier here
				p)	--add_text(stringValue, fontSize, font, Xposition, Yposition)

p = p + .10	 -- increment the y position		

function AddTask(coalitionHeader, taskDescription, yLocation)  -- function that adds the task subheader to allow for choice of blue coalition only, red coalition only or both coalitions
p = yLocation
add_picture(lightbanner,
				.09, -- X POSITION
				p, -- Y POSITION
				1.82, -- HORIZONTAL SIZE
				.07,  --VERTICAL SIZE
				0,
				0,
				1, 
				1)				
				
add_text(coalitionHeader,mediumText,12, -- add coaltion task subheader
				0.10,
				p)
					
p = p + .075
--wrappedTask = functions.textWrap( taskDescription, 68, nil, nil )
wrappedTask = functions.WordWrap (taskDescription, 68)
add_custom_text("",wrappedTask,smallText,12,12,subTextColor,
				-.90,
				p)
p = functions.getTextBlockHeight(wrappedTask,68,.12) + p + .10	
return p
end				

if missionData.pilotcoalition == 'blue' then -- adds the blue task subheader if the player's coalition is 'blue'

	if missionData.descriptionBlueTask ~= "" then  -- make sure a task exists for the blue side
	
		p = AddTask('Blue Task:', missionData.descriptionBlueTask, p)  -- adds the task for blue
	
	else
	
		p = AddTask('Blue Task:', 'No tasking available.', p)  -- adds the task for blue
	
	end

elseif missionData.pilotcoalition == 'red' then -- adds the red task subheader if the player's coalition is 'blue'

	if missionData.descriptionRedTask ~= "" then -- make sure a task exists for the red side
	
		p = AddTask('Red Task:', missionData.descriptionRedTask, p) -- adds the task for red
		
	else
	
		p = AddTask('Red Task:', 'No tasking available.', p) -- adds the task for red
	
	end

else  --adds both red and blue tasks if coalition is not chosen

	if missionData.descriptionBlueTask ~= "" then
	
		p = AddTask('Blue Task:', missionData.descriptionBlueTask, p) 
			
	else
	
		p = AddTask('Blue Task:', 'No tasking available.', p)  -- adds the task for blue
	
	end

	if missionData.descriptionRedTask ~= "" then
	
		p = AddTask('Red Task:', missionData.descriptionRedTask, p)
				
	else
	
		p = AddTask('Red Task:', 'No tasking available.', p) -- adds the task for red
	
	end

end



		
				
				
				
				
				
				