local dev = GetSelf()

local update_time_step = 0.1
make_default_activity(update_time_step) 
--update will be called 10 times per second
local sensor_data = get_base_data()

local T_NAVLIGHT = get_param_handle("T_NAVLIGHT")
local T_STROBELIGHT = get_param_handle("T_STROBELIGHT")
local T_FORMLIGHT = get_param_handle("T_FORMLIGHT")
local T_LANDINGLIGHT = get_param_handle("T_LANDINGLIGHT")
local PANEL_LIGHT_FRONT = get_param_handle("PANEL-LIGHT-FRONT")

local NavLight = 3001
local StrobeLight  = 3004 -- This is the number of the command from command_defs
local FormationLight = 3002
local LandingLight = 3006

local NavLightSwitch = 3001
local StrobeLightSwitch = 502
local FormLightSwitch = 503
local LandLightSwitch = 504

local PANEL_LIGHT_SWITCH = 3201

NavLightSwitchIsOn = 0
StrobeLightSwitchIsOn = 0
FormLightSwitchIsOn = 0
LandLightSwitchIsOn = 0
PANEL_LIGHT_SWITCH = 0

dev:listen_command(NavLightSwitch)
dev:listen_command(FormationLightSwitch)
dev:listen_command(StrobeLightSwitch)
dev:listen_command(LandLightSwitch)
dev:listen_command(PANEL_LIGHT_SWITCH)

T_NAVLIGHT:set(0)
T_STROBELIGHT:set(0)
T_FORMLIGHT:set(0)
T_LANDINGLIGHT:set(0)
--PANEL_LIGHT_SWITCH:set(0)

function SetCommand(command,value)	
	
--	if command == PANEL_LIGHT_SWITCH then
--		if (PANEL_LIGHT_FRONT == 1) then
--			PANEL_LIGHT_FRONT = 0
--		else
--			PANEL_LIGHT_FRONT = 1
--		end
--	end

	
	if command == NavLight or command == NavLightSwitch then
		if (NavLightSwitchIsOn == 1) then
			NavLightSwitchIsOn = 0
		else
			NavLightSwitchIsOn = 1
		end
	end
		
	if command == StrobeLight or command == StrobeLightSwitch then
		if (StrobeLightSwitchIsOn == 1) then
			StrobeLightSwitchIsOn = 0
		else
			StrobeLightSwitchIsOn = 1
		end
	end
	
	if command == FormationLight then
		if (FormLightSwitchIsOn == 1) then
			FormLightSwitchIsOn = 0
		else
			FormLightSwitchIsOn = 1
		end
	end
	
	if command == LandingLight or command == LandLightSwitch then
		if (LandLightSwitchIsOn == 1) then
			LandLightSwitchIsOn = 0
		else
			LandLightSwitchIsOn = 1
		end
	end

end


function update()

	if (PANEL_LIGHT_SWITCH == 1) then
		PANEL_LIGHT_FRONT:set(1)
		else
		PANEL_LIGHT_FRONT:set(0)
	end

	if (NavLightSwitchIsOn == 1) then
		T_NAVLIGHT:set(1)
		else
		T_NAVLIGHT:set(0)
	end
	
	if (StrobeLightSwitchIsOn == 1) then
		T_STROBELIGHT:set(1)
		else
		T_STROBELIGHT:set(0)
	end
	
	if (FormLightSwitchIsOn == 1) then
		T_FORMLIGHT:set(1)
		else
		T_FORMLIGHT:set(0)
	end
	
	if (LandLightSwitchIsOn == 1) then
		T_LANDINGLIGHT:set(1)
		else
		T_LANDINGLIGHT:set(0)
	end
		
	set_aircraft_draw_argument_value(190,NavLightSwitchIsOn)
	set_aircraft_draw_argument_value(191,NavLightSwitchIsOn)
	set_aircraft_draw_argument_value(203,NavLightSwitchIsOn)
	
	set_aircraft_draw_argument_value(195,StrobeLightSwitchIsOn)
	set_aircraft_draw_argument_value(196,StrobeLightSwitchIsOn)
	set_aircraft_draw_argument_value(192,StrobeLightSwitchIsOn)
	
	set_aircraft_draw_argument_value(202,FormLightSwitchIsOn)
	set_aircraft_draw_argument_value(201,FormLightSwitchIsOn)
	
	set_aircraft_draw_argument_value(209,LandLightSwitchIsOn)
	set_aircraft_draw_argument_value(130,LandLightSwitchIsOn)
	
	
end