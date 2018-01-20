dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")

local gettext = require("i_18n")
_ = gettext.translate

cursor_mode = 
{ 
    CUMODE_CLICKABLE = 0,
    CUMODE_CLICKABLE_AND_CAMERA  = 1,
    CUMODE_CAMERA = 2,
};

clickable_mode_initial_status  = cursor_mode.CUMODE_CLICKABLE
use_pointer_name			   = true

function default_button(hint_,device_,command_,arg_,arg_val_,arg_lim_)

	local   arg_val_ = arg_val_ or 1
	local   arg_lim_ = arg_lim_ or {0,1}

	return  {	
				class 				= {class_type.BTN},
				hint  				= hint_,
				device 				= device_,
				action 				= {command_},
				stop_action 		= {command_},
				arg 				= {arg_},
				arg_value			= {arg_val_}, 
				arg_lim 			= {arg_lim_},
				use_release_message = {true}
			}
end

function default_1_position_tumb(hint_, device_, command_, arg_, arg_val_, arg_lim_)
	local   arg_val_ = arg_val_ or 1
	local   arg_lim_ = arg_lim_ or {0,1}
	return  {	
				class 		= {class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {arg_val_}, 
				arg_lim   	= {arg_lim_},
				updatable 	= true, 
				use_OBB 	= true
			}
end

function default_2_position_tumb(hint_, device_, command_, arg_)
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {1,-1}, 
				arg_lim   	= {{0,1},{0,1}},
				updatable 	= true, 
				use_OBB 	= true
			}
end

function default_3_position_tumb(hint_,device_,command_,arg_,cycled_,inversed_)
	local cycled = true
	
	
	local val =  1
	if inversed_ then
	      val = -1
	end
	if cycled_ ~= nil then
	   cycled = cycled_
	end
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {val,-val}, 
				arg_lim   	= {{-1,1},{-1,1}},
				updatable 	= true, 
				use_OBB 	= true,
				cycle       = cycled
			}
end

function default_axis(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_)
	
	local default = default_ or 1
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	
	return  {	
				class 		= {class_type.LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {{0,1}},
				updatable 	= updatable, 
				use_OBB 	= true,
				gain		= {gain},
				relative    = {relative}, 				
			}
end

function default_movable_axis(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_)
	
	local default = default_ or 1
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	
	return  {	
				class 		= {class_type.MOVABLE_LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {{0,1}},
				updatable 	= updatable, 
				use_OBB 	= true,
				gain		= {gain},
				relative    = {relative}, 				
			}
end

function default_axis_limited(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_, arg_lim_)
	
	local relative = false
	local default = default_ or 0
	local updatable = updatable_ or false
	if relative_ ~= nil then
		relative = relative_
	end

	local gain = gain_ or 0.1
	return  {	
				class 		= {class_type.LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {arg_lim_},
				updatable 	= updatable, 
				use_OBB 	= false,
				gain		= {gain},
				relative    = {relative},  
			}
end


function multiposition_switch(hint_,device_,command_,arg_,count_,delta_,inversed_, min_)
    local min_   = min_ or 0
	local delta_ = delta_ or 0.5
	
	local inversed = 1
	if	inversed_ then
		inversed = -1
	end
	
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-delta_ * inversed,delta_ * inversed}, 
				arg_lim   	= {{min_, min_ + delta_ * (count_ -1)},
							   {min_, min_ + delta_ * (count_ -1)}},
				updatable 	= true, 
				use_OBB 	= true
			}
end

function multiposition_switch_limited(hint_,device_,command_,arg_,count_,delta_,inversed_,min_)
    local min_   = min_ or 0
	local delta_ = delta_ or 0.5
	
	local inversed = 1
	if	inversed_ then
		inversed = -1
	end
	
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-delta_ * inversed,delta_ * inversed}, 
				arg_lim   	= {{min_, min_ + delta_ * (count_ -1)},
							   {min_, min_ + delta_ * (count_ -1)}},
				updatable 	= true, 
				use_OBB 	= true,
				cycle     	= false, 
			}
end

function default_button_axis(hint_, device_,command_1, command_2, arg_1, arg_2, limit_1, limit_2)
	local limit_1_   = limit_1 or 1.0
	local limit_2_   = limit_2 or 1.0
return {
			class		=	{class_type.BTN, class_type.LEV},
			hint		=	hint_,
			device		=	device_,
			action		=	{command_1, command_2},
			stop_action =   {command_1, 0},
			arg			=	{arg_1, arg_2},
			arg_value	= 	{1, 0.5},
			arg_lim		= 	{{0, limit_1_}, {0,limit_2_}},
			animated        = {false,true},
			animation_speed = {0, 0.4},
			gain = {0, 0.1},
			relative	= 	{false, false},
			updatable 	= 	true, 
			use_OBB 	= 	true,
			use_release_message = {true, false}
	}
end

function default_animated_lever(hint_, device_, command_, arg_, animation_speed_,arg_lim_)
local arg_lim__ = arg_lim_ or {0.0,1.0}
return  {	
	class  = {class_type.TUMB, class_type.TUMB},
	hint   	= hint_, 
	device 	= device_,
	action 	= {command_, command_},
	arg 		= {arg_, arg_},
	arg_value 	= {1, 0},
	arg_lim 	= {arg_lim__, arg_lim__},
	updatable  = true, 
	gain 		= {0.1, 0.1},
	animated 	= {true, true},
	animation_speed = {animation_speed_, 0},
	cycle = true
}
end

function default_button_tumb(hint_, device_, command1_, command2_, arg_)
	return  {	
				class 		= {class_type.BTN,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command1_,command2_},
				stop_action = {command1_,0},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-1,1}, 
				arg_lim   	= {{-1,0},{0,1}},
				updatable 	= true, 
				use_OBB 	= true,
				use_release_message = {true,false}
			}
end

elements = {}

-- 10 000 ft reset
elements["PNT_073"]		= default_button(_("Reset 10000 ft"),devices.ALTIMETER,device_commands.Button_1,73)

-- Gmeter reset
elements["PNT_074"]		= default_button(_("Push to set G-meter"),devices.ACCELEROMETER,device_commands.Button_1,74)

-- Flaps
-- elements["PNT_018"] = FCS_Tumb("Flaps Control", devices.AVIONICS, device_commands.Button_18, device_commands.Button_134,218) -- uses PNT_018 and PNT_134
elements["PNT_016"] = default_button("Flaps Up",devices.COMMANDS, device_commands.Button_1,200)
elements["PNT_017"] = default_button("Flaps Mid",devices.COMMANDS, device_commands.Button_2,201)
elements["PNT_018"] = default_button("Flaps Full Down",devices.COMMANDS, device_commands.Button_3,203)

--SwitchOFF elements["POINTER"] = default_2_position_tumb(LOCALIZE("Test Command"),devices.TEST, device_commands.Button_1,444) -- 44 arg number
elements["PNT_019"] = default_button("Gear Down",devices.COMMANDS, device_commands.Button_4,219)
elements["PNT_020"] = default_button("Gear Up",devices.COMMANDS, device_commands.Button_5,220)

-- Airbrake
--elements["PNT_013"] = default_button("Airbrakes Down",devices.AIR, device_commands.Button_13,213)
--elements["PNT_014"] = default_button("Airbrakes Up",devices.AIR, device_commands.Button_14,214)

-- Altimeter Setting
--elements["SET-PRESSURE"] = { class = {class_type.LEV}, hint = "Set Altimeter", device = devices.ALTIMETER, action = {device_commands.Button_1}, arg = {8}, arg_value = {0.5}, arg_lim = {{0.0, 1.0}} } 
elements["PNT-ALT-LEVR"] = default_axis(_("Set Pressure"),devices.ALTIMETER, device_commands.Button_2, 300, 0.04, 1, false, true)
-- IAS Index Setting
--elements["PNT-IAS-LEVR"] = default_axis(_("Set IAS Index"),devices.ALTIMETER, device_commands.Button_3, 301, 0.04, 1, false, true)
-- HDG Index Setting
elements["PNT-HDG-LEVR"] = default_axis(_("Set Heading Bug"),devices.ALTIMETER, device_commands.Button_4, 304, 0.02, 1, false, true)
-- HRZ Secours Index Setting
elements["PNT-HRZSEC-LVR"] = default_axis(_("Reset Standby Horizon"),devices.ALTIMETER, device_commands.Button_5, 305, 0.04, 1, false, true)
-- Horizon Index Setting
elements["PNT-HRZ-LVR"] = default_axis(_("Horizon Plane Set"),devices.ALTIMETER, device_commands.Button_6, 306, 0.04, 1, false, true)

-- SIB VHF UHF
elements["PNT-SIB-UHF"] = default_axis(_("UHF Volume"),devices.ALTIMETER, device_commands.Button_7, 302, 0.04, 1, false, true)
elements["PNT-SIB-VHF"] = default_axis(_("VHF Volume"),devices.ALTIMETER, device_commands.Button_8, 303, 0.04, 1, false, true)

--Light System Control Panel
elements["PTR-LIGHT-NAV"]			= default_3_position_tumb(_("Navigation Lights, FLASH/OFF/STEADY"), devices.LIGHT_SYSTEM, device_commands.Button_1, 280)
elements["PTR-LIGHT-FORMATION"]		= default_2_position_tumb(_("Formation Lights, ON/OFF"), devices.LIGHT_SYSTEM, device_commands.Button_2, 281)
elements["PTR-LIGHT-INTENS"]		= default_2_position_tumb(_("Intensity, STRONG/LOWVIS"), devices.LIGHT_SYSTEM, device_commands.Button_3, 282)
elements["PTR-LIGHT-ANTICOLLISION"]	= default_2_position_tumb(_("Anticollision Lights, ON/OFF"), devices.LIGHT_SYSTEM, device_commands.Button_4, 283)


--added by jph:
elements["PNT-PANEL-LT"] = default_axis(_("Panel Light Front"),devices.LIGHT_SYSTEM, device_commands.Button_201, 501, 0.02, 1, false, true)
--


-- Landing Light
elements["PTR-LAND-LVR"]		= default_3_position_tumb(_("Lights, OFF/TAXI/LANDING"), devices.LIGHT_SYSTEM, device_commands.Button_6, 311)

elements["PTR-T-ALARME"]		= default_3_position_tumb(_("High Alpha Alarm, HIDRAG/OFF/LOWDRAG"), devices.LIGHT_SYSTEM, device_commands.Button_5, 295)

--Front Switch Control Panel
elements["PTR-PNL-T-SON"]	= default_2_position_tumb(_("Alarme Sonore, ON/OFF"), devices.LIGHT_SYSTEM, device_commands.Button_7, 284)
elements["PTR-PNL-T-PITOT"]	= default_2_position_tumb(_("Pitot Heat, ON/OFF"), devices.LIGHT_SYSTEM, device_commands.Button_8, 285)
elements["PTR-PNL-T-CENTGYRO"]	= default_2_position_tumb(_("Centrale Gyroscopique, ON/OFF"), devices.GYRO_SYSTEM, device_commands.Button_1, 286)
elements["PTR-PNL-T-HRZSEC"]	= default_2_position_tumb(_("Horizon Secours, ON/OFF"), devices.GYRO_SYSTEM, device_commands.Button_2, 287)
elements["PTR-PNL-T-ELECTROPUMP"]	= default_2_position_tumb(_("Electropompe, ON/OFF"), devices.HYDRAULIC_SYSTEM, device_commands.Button_10, 288)

--Warning Light Panel
elements["PTR-ALM-T-BATT"]	= default_2_position_tumb(_("Master Battery"), devices.ELECTRIC_SYSTEM, device_commands.Button_11, 289)
elements["PTR-ALM-T-GENEG"]	= default_2_position_tumb(_("Left Generator"), devices.ELECTRIC_SYSTEM, device_commands.Button_12, 290)
elements["PTR-ALM-T-GENED"]	= default_2_position_tumb(_("Right Generator"), devices.ELECTRIC_SYSTEM, device_commands.Button_13, 291)
elements["PTR-ALM-T-CONV1"]	= default_2_position_tumb(_("Left Inverter"), devices.ELECTRIC_SYSTEM, device_commands.Button_14, 292)
elements["PTR-ALM-T-CONV2"]	= default_2_position_tumb(_("Right Inverter"), devices.ELECTRIC_SYSTEM, device_commands.Button_15, 293)
elements["PTR-ALM-T-CRASHBAR"]	= default_2_position_tumb(_("Crash Bar"), devices.ELECTRIC_SYSTEM, device_commands.Button_16, 315)
elements["PTR-T-LIGHTEST"]		= default_button(_("Warning Light Test"),devices.ELECTRIC_SYSTEM,device_commands.Button_17,294)

elements["PTR-T-DELESTAGE"]		= default_2_position_tumb(_("Delestage"),devices.ELECTRIC_SYSTEM,device_commands.Button_18,316)

-- elements["PTR-LGHTCP-FLOOD"]			= default_axis(_("Flood Light"), devices.LIGHT_SYSTEM, device_commands.Button_5, 296)
-- elements["PTR-LGHTCP-CONSOLE"]		= default_axis(_("Console Light"), devices.LIGHT_SYSTEM, device_commands.Button_6, 297)

-- Engine Starting Panel
elements["PTR-START-LENG"]	= default_3_position_tumb(_("Left Engine Start, START/VENT/OFF"), devices.START_PANEL, device_commands.Button_20, 296)
elements["PTR-START-RENG"]	= default_3_position_tumb(_("Right Engine Start, START/VENT/OFF"), devices.START_PANEL, device_commands.Button_21, 297)
elements["PTR-START-BPG"]	= default_2_position_tumb(_("Low Pressure Pump, BPG"), devices.START_PANEL, device_commands.Button_22, 298)
elements["PTR-START-BPD"]	= default_2_position_tumb(_("Low Pressure Pump, BPD"), devices.START_PANEL, device_commands.Button_23, 299)
elements["PTR-START-COCKBPL"]	= default_2_position_tumb(_("Protective Cover, BPG"), devices.START_PANEL, device_commands.Button_24, 307)
elements["PTR-START-COCKBPR"]	= default_2_position_tumb(_("Protective Cover, BPD"), devices.START_PANEL, device_commands.Button_25, 308)
elements["PTR-START-LFUELCUT"]	= default_2_position_tumb(_("Fuel Cutoff Left"), devices.START_PANEL, device_commands.Button_26, 309)
elements["PTR-START-RFUELCUT"]	= default_2_position_tumb(_("Fuel Cutoff Right"), devices.START_PANEL, device_commands.Button_27, 310)

-- Oxygen command and panel
elements["PTR-OXYG-NORMAL"]	= default_2_position_tumb(_("Normal / 100%"), devices.LIGHT_SYSTEM, device_commands.Button_11, 312)
elements["PTR-OXYG-OPENCLOSE"]	= default_2_position_tumb(_("Open/Close"), devices.LIGHT_SYSTEM, device_commands.Button_12, 313)

-- Cache Horizon
elements["PNT-CACHE-HRZ"]	= default_2_position_tumb(_("Hide/Show"), devices.GYRO_SYSTEM, device_commands.Button_3, 314)
-- Toggle side smoke system 
elements["PNT-SWITCH-FUMI"]	= default_2_position_tumb(_("Right/Left"), devices.SYSTEMS, device_commands.Button_1, 317)


for i,o in pairs(elements) do
	if  o.class[1] == class_type.TUMB or 
	   (o.class[2]  and o.class[2] == class_type.TUMB) or
	   (o.class[3]  and o.class[3] == class_type.TUMB)  then
	   o.updatable = true
	   o.use_OBB   = true
	end
end