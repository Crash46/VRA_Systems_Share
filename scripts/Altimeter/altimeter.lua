local dev 	    = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.05
make_default_activity(update_time_step)
--update will be called 50 times per second


-- add barometric pressure adjustment knob command number
local Baro_Adj_Knob = 3002

-- add parameters from mainpanel init
local Alt10000 = get_param_handle("Alt10000")
local Alt1000  = get_param_handle("Alt1000")
local Alt100   = get_param_handle("Alt100")
local Baro_Press_1000 = get_param_handle("Baro_Press_1000")
local Baro_Press_0100 = get_param_handle("Baro_Press_1000")
local Baro_Press_0010 = get_param_handle("Baro_Press_1000")
local Baro_Press_0001 = get_param_handle("Baro_Press_0001")

-- Basic variables that will be used later
local feet_per_meter = 3.2808399
local ALT_PRESSURE_MAX = 30.99 -- in Hg
local ALT_PRESSURE_MIN = 29.10 -- in Hg
local ALT_PRESSURE_STD = 29.92 -- in Hg

-- Initial altimeter setting
local altimeter_setting = ALT_PRESSURE_STD

-- Subscribe to the barometric adjustment know command
dev:listen_command(Baro_Adj_Knob)

-- Set initial values for the parameters
Alt100:set(0)
Alt1000:set(0)
Alt10000:set(0)
Baro_Press_1000:set(0)
Baro_Press_0100:set(0)
Baro_Press_0010:set(0)
Baro_Press_0001:set(0)


function post_initialize()

end

function SetCommand(command,value)	
	-- TODO: need to adjust the rate of spinning
	if command == Baro_Adj_Knob then
		altimeter_setting = altimeter_setting + ((value / 0.05)*0.001)
		if altimeter_setting >= ALT_PRESSURE_MAX then -- If the pressure set is higher than the maximum allowed, set the altimeter setting to correspond to the maximum pressure
			altimeter_setting = ALT_PRESSURE_MAX 
		elseif altimeter_setting <= ALT_PRESSURE_MIN then -- Same as above but for the minimum pressure
			altimeter_setting = ALT_PRESSURE_MIN
		end
	end	
end

function update()
	
	update_altimeter()

	Baro_Press_0001:set(Baro0001)
	Baro_Press_0010:set(Baro0010)
	Baro_Press_0100:set(Baro0100)
	Baro_Press_1000:set(Baro1000)
	
end

function update_altimeter()

	-- Set altitude
	local altitude = sensor_data.getBarometricAltitude()*feet_per_meter
	
	-- Barometric pressure animation
	local mPressure = altimeter_setting * 33.86

    local Baro1000 = (mPressure)/1000
    local Baro0100 = ((mPressure/100)-math.floor(Baro1000*10))  
    local Baro0010 = ((mPressure/10)-(math.floor(Baro1000)*100)-(math.floor(Baro0100)*10))
    local Baro0001 = (mPressure-(math.floor(Baro1000)*1000)-(math.floor(Baro0100)*100)-(math.floor(Baro0010)*10))

		

	--print_message_to_user(mPressure)
	print_message_to_user(Baro0010)

	-- based on the barometric setting, adjust the displayed altitude
	local altitude_adjusted = (altimeter_setting - ALT_PRESSURE_STD)* 1000 -- 1000 feet per inHg / 10 feet per .01 in Hg

	Alt100:set((altitude + altitude_adjusted) % 1000)
	Alt1000:set((altitude + altitude_adjusted)% 10000)
	Alt10000:set(altitude + altitude_adjusted)

end
