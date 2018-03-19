local dev 	    = GetSelf()
local update_time_step = 0.05
make_default_activity(update_time_step) --update will be called 50 times per second

local sensor_data = get_base_data()

-- add parameters from mainpanel init
local Alt10000 = get_param_handle("Alt10000")
local Alt1000  = get_param_handle("Alt1000")
local Alt100   = get_param_handle("Alt100")
local Baro_Press_1000 = get_param_handle("Alt_Baro_Press_1000")
local Baro_Press_0100 = get_param_handle("Alt_Baro_Press_0100")
local Baro_Press_0010 = get_param_handle("Alt_Baro_Press_0010")
local Baro_Press_0001 = get_param_handle("Alt_Baro_Press_0001")

-- add barometric pressure adjustment knob command number
local Baro_Adj_Knob = 3002

local Baro1k = 0
local Baro100 = 0
local Baro10 = 0
local Baro1 = 0

-- Basic contants that will be used later
local feet_per_meter = 3.2808399
local ALT_PRESSURE_MAX = 30.99 -- in Hg
local ALT_PRESSURE_MIN = 29.10 -- in Hg
local ALT_PRESSURE_STD = 29.92 -- in Hg

-- Initial altimeter setting
local altimeter_setting = ALT_PRESSURE_STD
local Pressure = 0

-- Subscribe to the barometric adjustment knob command
dev:listen_command(Baro_Adj_Knob)



-- Set initial values for the parameters
Alt100:set(0)
Alt1000:set(0)
Alt10000:set(0)
Baro_Press_0001:set(0)
Baro_Press_0010:set(0)
Baro_Press_0100:set(0)
Baro_Press_1000:set(0)

function post_initialize()

end

function SetCommand(command,value)	
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
end

function update_altimeter()

	-- Set altitude
	local altitude = sensor_data.getBarometricAltitude()*feet_per_meter
	
	-- Barometric pressure animation
	local Pressure = altimeter_setting * 33.86 -- Convert from Hg to HP

    local Baro1k = (Pressure)/1000
    local Baro100 = ((Pressure/100)-math.floor(Baro1k*10))  
    local Baro10 = ((Pressure/10)-(math.floor(Baro1k)*100)-(math.floor(Baro100)*10))
    local Baro1 = (Pressure-(math.floor(Baro1k)*1000)-(math.floor(Baro100)*100)-(math.floor(Baro10)*10))

	--print_message_to_user(mPressure)
	--print_message_to_user(Baro1)

	-- based on the barometric setting, adjust the displayed altitude
	local altitude_adjusted = (altimeter_setting - ALT_PRESSURE_STD)* 1000 -- 1000 feet per inHg / 10 feet per .01 in Hg

	Alt100:set((altitude + altitude_adjusted) % 1000)
	Alt1000:set((altitude + altitude_adjusted)% 10000)
	Alt10000:set(altitude + altitude_adjusted)

	Baro_Press_0001:set(Baro1)
	Baro_Press_0010:set(Baro10)
	Baro_Press_0100:set(Baro100)
	Baro_Press_1000:set(Baro1k)

end

need_to_be_closed = false