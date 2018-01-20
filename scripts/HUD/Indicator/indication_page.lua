dofile(LockOn_Options.script_path.."scripts/HUD/Indicator/definitions.lua")

local sensor_data = get_base_data()
local P_HYD1 = get_param_handle("P_HYD1")
local P_HYD2 = get_param_handle("P_HYD2")
PitchLineClipRadius = 163

function AddElement(object)
    object.use_mipfilter    = true
	object.additive_alpha   = true
	object.h_clip_relation  = h_clip_relations.COMPARE
	object.level			= HUD_DEFAULT_LEVEL
    Add(object)
end

local BASE_COLOR  = {255,0  ,0,255}
local BASE_COLOR2 = {0,255,0,255} --128,165,0,120
local PitchScale   		= MakeMaterial("HUD_grid2.tga",BASE_COLOR2) -- image of the fixed net
local BASE_COLOR_MAT    = MakeMaterial(nil,BASE_COLOR)

local shape_rotation = (sensor_data.getRoll()) * 57.3

-- shape_rotation = math.tan(shape_rotation/57.3) * 1000 -- to mils -- NOTE: this does nothing currently, returns 0

local full_radius = 400 -- is this the radius of "HUD/net view field"? Units 108 (pixels or angular units)? no effect!
local grid_shift  = (sensor_data.getPitch() / 57.3) * 1000 -- explain shift?-35
local grid_radius =  full_radius + grid_shift


local grid_origin	         = CreateElement "ceSimple"
grid_origin.name 		     = create_guid_string() -- no such function in this script. Not in definitions.lua either. Could be in elements_defs.lua
grid_origin.collimated 		 = true
AddElement(grid_origin)

local PitchScaleParam	    = CreateElement "ceTexPoly" --this could be the text area on HUD
PitchScaleParam.name 		= create_guid_string() -- this must be external function call.
PitchScaleParam.vertices   = {{-grid_radius, grid_radius},
			   { grid_radius, grid_radius},
			   { grid_radius,-grid_radius},
			   {-grid_radius,-grid_radius}}
PitchScaleParam.indices	= {0,1,2,2,3,0}
PitchScaleParam.tex_coords = {{0,0},{1,0},{1,1},{0,1}}
PitchScaleParam.material   = PitchScale	   
PitchScaleParam.element_params  = {"D_PITCH"}  -- Global Variable to test
PitchScaleParam.controllers     = {{"move_up_down_using_parameter",0,0}} 
PitchScaleParam.collimated = true
PitchScaleParam.parent_element = grid_origin.name
AddElement(PitchScaleParam)

-------------------------------
function AddPitchLine(name, tex_params, parent, index)

	local Line = AddHUDTexElement(name, 
					{{-37, -2.5}, {-37, 2.5}, 
					{37, 2.5}, {37, -2.5}},
					tex_params, 
					{{"D_PITCH", index, 348, PitchLineClipRadius}},
					{0.0, index * five_degrees, 0.0},
					{0.0, 0.0, 0.0},
					parent,
					HUD_DEFAULT_LEVEL)

	textpos = -1.2
	if index < 0 then
		textpos = 0.8
	end
				
	local Text1 = AddHUDTextElement(("txt_" .. name), 
				  {{"txt_pitch", index}}, 
				  {-41, textpos, 0.0}, 
				  name,
				  HUD_DEFAULT_LEVEL)
	
	local Text2 = AddHUDTextElement(("txt_" .. name .. string.format("%i", 2)), 
				  {{"txt_pitch", index}}, 
				  {41, textpos, 0.0}, 
				  name,
				  HUD_DEFAULT_LEVEL)
end
-------------------------------------------

local FONT_         = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},BASE_COLOR2,50,"test_font") --this is font object declaration. Mig-21 does not have fonts, therefore disabled.

local test_output           = CreateElement "ceStringPoly"
test_output.name            = create_guid_string()
test_output.material        = FONT_
test_output.init_pos        = {70,-70}
test_output.alignment       = "CenterCenter"
test_output.stringdefs      = {0.01,0.75 * 0.01, 0, 0}
test_output.formats         = {"%06.2f","%s"}    --%06.2f
test_output.element_params  = {"COCKPIT"}  -- Global Variable to test
test_output.controllers     = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
test_output.additive_alpha  = true
test_output.collimated     = true
AddElement(test_output)

local test2_output           = CreateElement "ceStringPoly"
test2_output.name            = create_guid_string()
test2_output.material        = FONT_
test2_output.init_pos        = {70,-80}
test2_output.alignment       = "CenterCenter"
test2_output.stringdefs      = {0.01,0.75 * 0.01, 0, 0}
test2_output.formats         = {"%06.2f","%s"}    --%06.2f
test2_output.element_params  = {"COCKPIT2"}  -- Global Variable to test
test2_output.controllers     = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
test2_output.additive_alpha  = true
test2_output.collimated     = true
AddElement(test2_output)

local ias_output = CreateElement "ceStringPoly"
ias_output.name = create_guid_string()
ias_output.material = FONT_
ias_output.init_pos = {-80,20}
ias_output.alignment = "RightCenter"
ias_output.stringdefs = {0.010,0.75 * 0.010, 0, 0}    --{ecrase vertical si inf a 0.01,ecrase lateral * streccth, 0, 0}
ias_output.formats = {"%3.0f","%s"}
ias_output.element_params = {"D_IAS"}
ias_output.controllers = {{"text_using_parameter",0,0}}
ias_output.additive_alpha = true
ias_output.collimated = true
AddElement(ias_output)

local AOA_output = CreateElement "ceStringPoly"
AOA_output.name = create_guid_string()
AOA_output.material = FONT_
AOA_output.init_pos = {-100,-90}
AOA_output.alignment = "LeftCenter"
AOA_output.stringdefs = {0.01,0.75 * 0.01, 0, 0}
AOA_output.formats = {"i %-2.1f","%s"}
AOA_output.element_params = {"D_AOA"}
AOA_output.controllers = {{"text_using_parameter",0,0}}
AOA_output.additive_alpha = true
AOA_output.collimated = true
AddElement(AOA_output)

local mach_output = CreateElement "ceStringPoly"
mach_output.name = create_guid_string()
mach_output.material = FONT_
mach_output.init_pos = {-100,-100}
mach_output.alignment = "LeftCenter"
mach_output.stringdefs = {0.01,0.75 * 0.01, 0, 0}
mach_output.formats = {"M %.2f","%s"}
mach_output.element_params = {"D_MACH"}
mach_output.controllers = {{"text_using_parameter",0,0}}
mach_output.additive_alpha = true
mach_output.collimated = true
AddElement(mach_output)

local G_output = CreateElement "ceStringPoly"
G_output.name = create_guid_string()
G_output.material = FONT_
G_output.init_pos = {-100,-110}
G_output.alignment = "LeftCenter"
G_output.stringdefs = {0.01,0.75 * 0.01, 0, 0}
G_output.formats = {"G %2.1f","%s"}
G_output.element_params = {"current_G"}
G_output.controllers = {{"text_using_parameter",0,0}}
G_output.additive_alpha = true
G_output.collimated = true
AddElement(G_output)

local HDG_output = CreateElement "ceStringPoly"
HDG_output.name = create_guid_string()
HDG_output.material = FONT_
HDG_output.init_pos = {0,90}
HDG_output.alignment = "CenterCenter"
HDG_output.stringdefs = {0.01,0.75 * 0.01, 0, 0}
HDG_output.formats = {"%3.0f","%s"}
HDG_output.element_params = {"D_HDG"}
HDG_output.controllers = {{"text_using_parameter",0,0}}
HDG_output.additive_alpha = true
HDG_output.collimated = true
AddElement(HDG_output)

local ALT_output = CreateElement "ceStringPoly"
ALT_output.name = create_guid_string()
ALT_output.material = FONT_
ALT_output.init_pos = {90,20}
ALT_output.alignment = "RightCenter"
ALT_output.stringdefs = {0.010,0.75 * 0.010, 0, 0}
ALT_output.formats = {"%.0f","%s"}
ALT_output.element_params = {"D_ALT"}
ALT_output.controllers = {{"text_using_parameter",0,0}}
ALT_output.additive_alpha = true
ALT_output.collimated = true
AddElement(ALT_output)

local altitude_source           = CreateElement "ceStringPoly"
altitude_source.name            = create_guid_string()
altitude_source.material        = FONT_
altitude_source.init_pos        = {110,20}
altitude_source.alignment       = "RightCenter"
altitude_source.stringdefs      = {0.010,0.75 * 0.010, 0, 0}
altitude_source.formats         = {"%s","%s"} 
altitude_source.element_params  = {"ALT_SOURCE"}
altitude_source.controllers     = {{"text_using_parameter",0,0}} --first index is for element_params (starting with 0) , second for formats ( starting with 0)
altitude_source.additive_alpha  = true
altitude_source.collimated     = true
AddElement(altitude_source)

local VV_output = CreateElement "ceStringPoly"
VV_output.name = create_guid_string()
VV_output.material = FONT_
VV_output.init_pos = {100,-5}
VV_output.alignment = "RightCenter"
VV_output.stringdefs = {0.01,0.75 * 0.01, 0, 0}
VV_output.formats = {"%5.0f","%s"}
VV_output.element_params = {"D_VV"}
VV_output.controllers = {{"text_using_parameter",0,0}}
VV_output.additive_alpha = true
VV_output.collimated = true
AddElement(VV_output)

local RPM_output = CreateElement "ceStringPoly"
RPM_output.name = create_guid_string()
RPM_output.material = FONT_
RPM_output.init_pos = {100,-110}
RPM_output.alignment = "RightCenter"
RPM_output.stringdefs = {0.01,0.75 * 0.01, 0, 0}
RPM_output.formats = {"%0.1f%%","%s"}
RPM_output.element_params = {"D_RPMG"}
RPM_output.controllers = {{"text_using_parameter",0,0}}
RPM_output.additive_alpha = true
RPM_output.collimated = true
AddElement(RPM_output)

function texture_box (UL_X,UL_Y,W,H) --this is texture box function. Receives some coordinates and dimensions, returns 4 pairs of values. Nothing is calling this function inside script.
local texture_size_x = 128
local texture_size_y = 128
local ux = UL_X / texture_size_x
local uy = UL_Y / texture_size_y
local w  = W / texture_size_x
local h  = W / texture_size_y

return {{ux	    ,uy},
		{ux + w ,uy},
		{ux + w ,uy + h},
		{ux	 	,uy + h}}
end

function create_textured_box(UL_X,UL_Y,DR_X,DR_Y) -- function that creates textured square. This function is called 2 times in below code.

local size_per_pixel = 1/8
local texture_size_x = 128
local texture_size_y = 128
local W = DR_X - UL_X
local H = DR_Y - UL_Y

local half_x = 0.5 * W * size_per_pixel
local half_y = 0.5 * H * size_per_pixel
local ux 	 = UL_X / texture_size_x
local uy 	 = UL_Y / texture_size_y
local w  	 = W / texture_size_x
local h 	 = H / texture_size_y

local object = CreateElement "ceTexPoly"
object.vertices =  {{-half_x, half_y},
				    { half_x, half_y},
				    { half_x,-half_y},
				    {-half_x,-half_y}}
object.indices	  = {0,1,2,2,3,0}
object.tex_coords = {{ux     ,uy},
					 {ux + w ,uy},
					 {ux + w ,uy + h},
				     {ux 	 ,uy + h}}	 
				 
return object

end

gun_sight_mark 					= create_textured_box(7,7,25,25) -- this is create_textured_box function call with parameters
gun_sight_mark.material       	= PitchScale	
gun_sight_mark.name 			= BASE_COLOR_MAT
gun_sight_mark.collimated	  	= true
gun_sight_mark.element_params   = {"WS_GUN_PIPER_AVAILABLE",
								   "WS_GUN_PIPER_AZIMUTH",
								   "WS_GUN_PIPER_ELEVATION"} 
								   
gun_sight_mark.controllers 	   = {{"parameter_in_range"				,0,0.9,1.1},--check that piper available using WS_GUN_PIPER_AVAILABLE
								  {"move_left_right_using_parameter",1, 0.73 },	--azimuth move by WS_GUN_PIPER_AZIMUTH , 0.73 is default collimator distance (from eye to HUD plane)
								  {"move_up_down_using_parameter"   ,2, 0.73 }, --elevation move by WS_GUN_PIPER_ELEVATION
								 }
AddElement(gun_sight_mark)

