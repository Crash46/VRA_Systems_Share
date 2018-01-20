local dev 	    = GetSelf()

local update_time_step = 0.1
make_default_activity(update_time_step) --update will be called 10 times per second

local sensor_data = get_base_data()
local alti = sensor_data.getRadarAltitude()*3.28084
local AircraftIsOnGround = get_param_handle("AircraftIsOnGround")

-- Variables
local L_SMOKE = get_param_handle("L_SMOKE")
local COCKPIT2 = get_param_handle("COCKPIT2")
local SmokeOnOff = 78
local SmokeIsOn = 0
-- local CockpitOnOff = 181
local CockpitIsOpen = 0
-- Initialisation

-- dev:listen_command(SmokeOnOff)
-- dev:listen_command(CockpitOnOff)

function SetCommand(command,value)			
	-- Smoke Light System Listening
	if command == SmokeOnOff and AircraftIsOnGround:get() < 0.5 then
		if (SmokeIsOn == 1) then
			SmokeIsOn = 0
		else
			SmokeIsOn = 1
		end
	end
	
	--if command == CockpitOnOff then
	--	if (CockpitIsOpen == 1) then
	--		CockpitIsOpen = 0
	--	else
	--		CockpitIsOpen = 1
	--	end
	--end
	
end

function update()
	-- Smoke Light System Listening
	L_SMOKE:set(SmokeIsOn)
	COCKPIT2:set(CockpitIsOpen)
	-- set_aircraft_draw_argument_value(181,CockpitIsOpen)
	
end

need_to_be_closed = false -- close lua state after initialization


