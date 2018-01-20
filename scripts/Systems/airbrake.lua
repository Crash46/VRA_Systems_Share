local dev = GetSelf()

local update_time_step = 0.05  --20 time per second
make_default_activity(update_time_step)

local P_HYD1 = get_param_handle("P_HYD1")
local ELEC_P1 = get_param_handle("ELEC_P1")
local sensor_data = get_base_data()
local Airbrake  = 73 -- This is the number of the command from command_defs
local AirbrakeOn = 147
local AirbrakeOff = 148

local airbrake_conso = get_param_handle("airbrake_conso")
local L_AF = get_param_handle("L_AF")
local L_WBRAKE = get_param_handle("L_WBRAKE")


local WheelBrakeOn = 74
local WheelBrakeOff = 75

--Creating local variables
local ABRAKE_COMMAND	=	0				-- COMMANDED GEAR POS 0=UP, 1=DOWN
local ABRAKE_STATE		=	0				-- ACTUALT GEAR POS 0=UP,1=DOWN

L_AF:set(0)
L_WBRAKE:set(0)

dev:listen_command(Airbrake)
dev:listen_command(AirbrakeOn)
dev:listen_command(AirbrakeOff)
dev:listen_command(WheelBrakeOn)
dev:listen_command(WheelBrakeOff)

function SetCommand(command,value)			
	
	if (command == Airbrake and P_HYD1:get()>4.5) then
		if (ABRAKE_COMMAND == 1) then
			ABRAKE_COMMAND = 0
		else
			ABRAKE_COMMAND = 1
		end
	end
	
	if (command == AirbrakeOn and P_HYD1:get()>4.5) then
		ABRAKE_COMMAND = 1
	end
	
	if (command == AirbrakeOff and P_HYD1:get()>4.5) then
		ABRAKE_COMMAND = 0
	end
	
	-- Wheel Brake
	if ELEC_P1:get() == 1 then
		if command == WheelBrakeOn then
			L_WBRAKE:set(1)
		end
		if command == WheelBrakeOff then
			L_WBRAKE:set(0)
		end
		else
		L_WBRAKE:set(0)
	end
end

function update()		
	
	if (ABRAKE_COMMAND == 0 and ABRAKE_STATE > 0) then
		-- Raise airbrake in increments of 0.02
		ABRAKE_STATE = ABRAKE_STATE - 0.02
	else
		if (ABRAKE_COMMAND == 1 and ABRAKE_STATE < 1) then
			-- Lower airbrake in increment of 0.02
			ABRAKE_STATE = ABRAKE_STATE + 0.02
		end
	end
	
	if ELEC_P1:get() == 1 then
		if ABRAKE_STATE > 0 then
			L_AF:set(1)
			else
			L_AF:set(0)
		end
		else
		L_AF:set(0)
	end
	
	if ABRAKE_STATE > 0 and ABRAKE_STATE < 1 then
		airbrake_conso:set(100)
		else
		airbrake_conso:set(0)
	end
	
	set_aircraft_draw_argument_value(21,ABRAKE_STATE)
	
end