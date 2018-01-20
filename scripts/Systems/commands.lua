local dev = GetSelf()

local update_time_step = 0.05  --20 time per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()


local P_HYD2 = get_param_handle("P_HYD2")
local ELEC_P1 = get_param_handle("ELEC_P1")
local D_TrimPicth = get_param_handle("D_TrimPicth")
local AircraftIsOnGround = get_param_handle("AircraftIsOnGround")
local Gear  = 68 --This is the number of the command from command_defs
local GearDown = 430
local GearUp = 431

local Gear_Down_Switch = 3004 
local Gear_Up_Switch = 3005

local TrimUp = 95 
-- local TrimNeutral = 97 
local TrimDown = 96

local FlapsUp = 145 
local FlapsMid = 72 
local FlapsDown = 146

local FlapsUp_Switch = 3003 
local FlapsMid_Switch = 3002 
local FlapsDown_Switch = 3001 

local flaps_status = get_param_handle("flaps_status")
local D_flaps_command = get_param_handle("D_flaps_command")
local flaps_conso = get_param_handle("flaps_conso")
local L_FLAPS = get_param_handle("L_FLAPS")

local L_Trappes = get_param_handle("L_Trappes")
local Gear_status = get_param_handle("Gear_status")
local gear_conso = get_param_handle("gear_conso")
local L_TNS = get_param_handle("L_TNS")
local profondeur = get_param_handle("D_ANGLE")
local Timer = 0
AircraftIsOnGround:set(get_aircraft_draw_argument_value(4))

-- Creating local variables
-- Testing aircraft on Ground
if AircraftIsOnGround:get() == 1 then
	Gear_Command	=	1				-- COMMANDED GEAR POS 0=UP, 1=DOWN
	Gear_State		=	1				-- ACTUAL GEAR POS 0=UP,1=DOWN
else
	Gear_Command	=	0				-- COMMANDED GEAR POS 0=UP, 1=DOWN
	Gear_State		=	0
end

local HAS_STARTED		= 	0
local BRAKE_COMMAND		=	0
local BRAKE_STATE		=	0
local flaps_command		=	1  -- 0.5
local flaps_state		=	0  -- 0.5
local TrimIndicator 	= 0

dev:listen_command(Gear)
dev:listen_command(Gear_Down_Switch)
dev:listen_command(Gear_Up_Switch)

dev:listen_command(BrakeOn)
dev:listen_command(BrakeOff)

dev:listen_command(FlapsMid)
dev:listen_command(FlapsUp)
dev:listen_command(FlapsDown)

dev:listen_command(TrimUp)
-- dev:listen_command(TrimNeutral)
dev:listen_command(TrimDown)

L_Trappes:set(1)
Gear_status:set(0)
gear_conso:set(0)
flaps_status:set(0.0)
flaps_conso:set(0)
D_flaps_command:set(0)
L_TNS:set(0.0)
profondeur:set(0)


function SetCommand(command,value)			
	--print_message_to_user(string.format("New SetCommand Triggered %d gearstate %d", command, GEAR_STATE))
	--env.info(string.format("Command %f", command), true)
	
	if command == Gear then
		if (Gear_Command == 1) then
			Gear_Command = 0
		else
			Gear_Command = 1
		end
	end
	
	if command == Gear_Down_Switch then  -- 3019
		Gear_Command = 1
	elseif command == Gear_Up_Switch then -- 3020
		Gear_Command = 0
	end
	
	-- Flaps command
	if (command == FlapsUp and P_HYD2:get()>10) or (command == FlapsUp_Switch and P_HYD2:get()>10) then
		flaps_command = 0 -- UP instruction
	end
	
	if (command == FlapsMid and P_HYD2:get()>10) or (command == FlapsMid_Switch and P_HYD2:get()>10) then
		flaps_command = 0.5 -- Mid instruction
	end
	
	if (command == FlapsDown and P_HYD2:get()>10) or (command == FlapsDown_Switch and P_HYD2:get()>10) then
		flaps_command = 1 -- DOWN instruction
	end
	
	-- Trim command
	if command == TrimUp then
		TrimIndicator = TrimIndicator + 0.05 -- Up instruction
	end
	if command == TrimDown then
		TrimIndicator = TrimIndicator - 0.05  -- Up instruction
	end

end
-- local p_gearstate = get_param_handle("GEARSTATE") --Any examples of this? I don't remember...
-- local fmparams = get_param_handle("FM_Params")
-- fmparams:set(string.format("%sGEARSTATE;",fmparams:get()))

function update()		
	-- p_gearstate:set(Gear_State)
	-- print_message_to_user(string.format("Update gearstate %d", Gear_State))
	-- env.info(string.format("Update!", 1), true)
	
	if (Gear_Command == 0 and Gear_State > 0) and AircraftIsOnGround:get() < 0.1 then
		-- Raise gear in increments of 0.1
		Gear_State = Gear_State - 0.015
	else
		if (Gear_Command == 1 and Gear_State < 1) then
			-- Lower gear in increment of 0.1
			Gear_State = Gear_State + 0.015
		end
	end
	
	
	if Gear_State > 0 and Gear_State < 1 and (ELEC_P1:get() == 1) then
		L_Trappes:set(1)
		else
		L_Trappes:set(0)
	end
	
	if Gear_State > 0 and Gear_State < 1 then
			gear_conso:set(100)
			else
			gear_conso:set(0)
	end
	
	--UP instruction
	if flaps_command == 1 and  flaps_state > 0 then
		flaps_state = flaps_state - 0.005 
		else
		flaps_state = flaps_state
	end
	
	--Down instruction
	if flaps_command == 0 and  flaps_state < 1 then
		flaps_state = flaps_state + 0.005 
		else
		flaps_state = flaps_state
	end
	
	--Mid instruction
	if (flaps_command == 0.5 and  flaps_state < 0.5) then
		flaps_state = flaps_state + 0.005 
		else if (flaps_command == 0.5 and  flaps_state > 0.5) then
			flaps_state = flaps_state - 0.005
			end
	end
	
	-- TNS Light
	local ias = sensor_data.getIndicatedAirSpeed()*1.9438
	local rpml = sensor_data.getEngineLeftRPM()
	local rpmr = sensor_data.getEngineRightRPM()
	
	if ELEC_P1:get() == 1 then
		if Gear_State < 0.1 then
			if (ias < 195 and rpml < 80) or (ias < 195 and rpmr < 80) then
				Timer = Timer +1
				if math.mod(Timer,10) > 5 then   -- (10 units = 1 sec) 5 units =0.5 seconds
					L_TNS:set(1)
				else
					L_TNS:set(0)
				end
			end
			else
			L_TNS:set(0)
		end
		else
		L_TNS:set(0)
	end
	
	if (flaps_state > 0 and flaps_state < 0.5) or (flaps_state > 0.51 and flaps_state < 1) then
		flaps_conso:set(100)
		else
		flaps_conso:set(0)
	end
	
	-- Flaps Light
	if flaps_state > 0 and ELEC_P1:get() == 1 then
		L_FLAPS:set(1)
		else
		L_FLAPS:set(0)
	end
	
	set_aircraft_draw_argument_value(20,flaps_state)
	set_aircraft_draw_argument_value(9,flaps_state)
	set_aircraft_draw_argument_value(10,flaps_state)
	flaps_status:set(flaps_state)
	D_flaps_command:set(flaps_command)
	D_TrimPicth:set(TrimIndicator)
	profondeur:set(get_aircraft_draw_argument_value(15))
	Gear_status:set(Gear_State)
	set_aircraft_draw_argument_value(0,Gear_State)
	set_aircraft_draw_argument_value(3,Gear_State)
	set_aircraft_draw_argument_value(5,Gear_State)
	AircraftIsOnGround:set(get_aircraft_draw_argument_value(4))
	
end
