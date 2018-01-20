local dev 	    = GetSelf()

local update_time_step = 0.1
make_default_activity(update_time_step) --update will be called 10 times per second

local sensor_data = get_base_data()

local L_250L = get_param_handle("L_250L")
local lbs_to_kg = 0.45359237
local kg_to_liter = 1/0.79
local fuel = get_param_handle("D_FUEL")  
local FFL = get_param_handle("D_FFL")
local FFR = get_param_handle("D_FFR")
local L_WINGL = get_param_handle("L_WINGL")
local L_WINGR = get_param_handle("L_WINGR")
local T_PANELTEST = get_param_handle("T_PANELTEST")

FFL:set(0.0)
FFR:set(0.0)
L_WINGL:set(0.0)
L_WINGR:set(0.0)
fuel_state = 0

function update()
	local g_load = sensor_data.getVerticalAcceleration()
	fuel_state = sensor_data.getTotalFuelWeight()*kg_to_liter
	fuel:set(sensor_data.getTotalFuelWeight()*kg_to_liter)
	FFL:set(sensor_data.getEngineLeftFuelConsumption()*kg_to_liter*60) -- kg/s to L/min
	FFR:set(sensor_data.getEngineRightFuelConsumption()*kg_to_liter*60) -- kg/s to L/min
	
	if (fuel_state > 1000 and g_load < 1) or fuel_state < 250 or T_PANELTEST:get() == 1 then
		L_250L:set(1)
		else
		L_250L:set(0)
	end
	
	if fuel_state < 1250 then
		L_WINGL:set(1)
		else
		L_WINGL:set(0)
	end
	
	if fuel_state < 1253 then
		L_WINGR:set(1)
		else
		L_WINGR:set(0)
	end
	
	
end

need_to_be_closed = false -- close lua state after initialization