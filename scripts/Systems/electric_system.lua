local dev = GetSelf()

local update_time_step = 0.1
make_default_activity(update_time_step) --update will be called 10 times per second

local sensor_data = get_base_data()

local T_BATT = get_param_handle("T_BATT")
local L_BATT = get_param_handle("L_BATT")
local PanelTest = 3017
local T_PANELTEST = get_param_handle("T_PANELTEST")
local MasterBattery = 3011
local MasterBattIsOn = 1

local GENEG = 3012
local GENEGIsOn = 0
local T_GENEG = get_param_handle("T_GENEG")
local GENED = 3013
local GENEDIsOn = 0
local T_GENED = get_param_handle("T_GENED")

local CONV1 = 3014
local CONV2 = 3015
local DELESTAGE = 3018
local ELEC_P1 = get_param_handle("ELEC_P1")
local ELEC_P2 = get_param_handle("ELEC_P2")
local ELEC_P3 = get_param_handle("ELEC_P3")
local ELEC_CONV1 = get_param_handle("ELEC_CONV1")
local ELEC_CONV2 = get_param_handle("ELEC_CONV2")

local T_CONV1 = get_param_handle("T_CONV1")
local T_CONV2 = get_param_handle("T_CONV2")
local T_DELESTAGE = get_param_handle("T_DELESTAGE")

T_PANELTEST:set(0.0)
T_GENEG:set(1)
T_GENED:set(1)
T_CONV1:set(1)
T_CONV2:set(1)
T_DELESTAGE:set(0)

dev:listen_command(MasterBattery)
dev:listen_command(GENEG)
dev:listen_command(GENED)
dev:listen_command(CONV1)
dev:listen_command(CONV2)
dev:listen_command(PanelTest)
dev:listen_command(DELESTAGE)

function SetCommand(command,value)
	
	if command == MasterBattery then
		if (MasterBattIsOn == 1) then
			MasterBattIsOn = 0
		else
			MasterBattIsOn = 1
		end
	end
	-- Left Generator 
	if command == GENEG then
		if (T_GENEG:get() == 1) then
			T_GENEG:set(0)
		else
			T_GENEG:set(1)
		end
	end
	-- Right Generator 
	if command == GENED then
		if (T_GENED:get() == 1) then
			T_GENED:set(0)
		else
			T_GENED:set(1)
		end
	end
	-- Panel Test activation
	if command == PanelTest then
		if (T_PANELTEST:get() == 1 ) then
			T_PANELTEST:set(0)
		else
			T_PANELTEST:set(1)
		end
	end
	
	if command == CONV1 then
		if (T_CONV1:get() == 1 ) then
			T_CONV1:set(0)
		else
			T_CONV1:set(1)
		end
	end
	
	if command == CONV2 then
		if (T_CONV2:get() == 1 ) then
			T_CONV2:set(0)
		else
			T_CONV2:set(1)
		end
	end
	
	if command == DELESTAGE then
		if (T_DELESTAGE:get() == 1 ) then
			T_DELESTAGE:set(0)
		else
			T_DELESTAGE:set(1)
		end
	end
  -- if command == 3006 then   
   -- electric_system:AC_Generator_1_on(value > 0)
  -- elseif command == 3005 then
   -- electric_system:AC_Generator_2_on(value > 0)
  -- elseif command == 3004 then
   -- electric_system:DC_Battery_on(value > 0)
  -- end
end

function update()
	local rpml = sensor_data.getEngineLeftRPM()
	local rpmr = sensor_data.getEngineRightRPM()
	
	-- Switch Left Generator
	if T_GENEG:get() == 1 and rpml > 53 then
		GENEGIsOn = 1
		else
		GENEGIsOn = 0
	end
	-- Switch Right Generator
	if T_GENED:get() == 1 and rpmr > 53 then
		GENEDIsOn = 1
		else
		GENEDIsOn = 0
	end
	-- Main bus 
	if MasterBattIsOn == 1 or GENEDIsOn == 1 or GENEGIsOn == 1 then
		ELEC_P1:set(1)
		ELEC_P2:set(1)
		if T_DELESTAGE:get() == 1 then
			ELEC_P3:set(1)
		end
		else
		ELEC_P1:set(0)
		ELEC_P2:set(0)
		if T_DELESTAGE:get() == 0 then
			ELEC_P3:set(0)
		end
	end

	if ELEC_P3:get() == 1 and T_CONV1:get() == 1 then  
		ELEC_CONV1:set(1)
		else
		ELEC_CONV1:set(0)
	end
	
	if ELEC_P1:get() == 1 and T_CONV2:get() == 1 then  
		ELEC_CONV2:set(1)
		else
		ELEC_CONV2:set(0)
	end
		
	-- Master Battery Toggle
	T_BATT:set(MasterBattIsOn)
	L_BATT:set(MasterBattIsOn)

end