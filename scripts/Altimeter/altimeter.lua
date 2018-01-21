local dev 	    = GetSelf()
local sensor_data = get_base_data()

local feet_per_meter = 3.2808399

local update_time_step = 0.05
make_default_activity(update_time_step)
--update will be called 50 times per second


local Alt10000 = get_param_handle("Alt10000")
local Alt1000  = get_param_handle("Alt1000")
local Alt100   = get_param_handle("Alt100")

-- add barometric pressure adjustment know
local Baro_Adj_Knob = 3002

-- TODO: add the rest of the numbers once this one is working
local Baro_Press_1000 = get_param_handle("Baro_Press_1000")
local Baro_Press_0100 = get_param_handle("Baro_Press_1000")
local Baro_Press_0010 = get_param_handle("Baro_Press_1000")
local Baro_Press_0001 = get_param_handle("Baro_Press_0001")


local ALT_PRESSURE_MAX = 30.99 -- in Hg
local ALT_PRESSURE_MIN = 29.10 -- in Hg
local ALT_PRESSURE_STD = 29.92 -- in Hg


local altimeter_setting = ALT_PRESSURE_STD

dev:listen_command(Baro_Adj)

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
		altimeter_setting = altimeter_setting+ ((value / 0.05)*0.02)
		if altimeter_setting >= ALT_PRESSURE_MAX then
			altimeter_setting = ALT_PRESSURE_MAX
		elseif altimeter_setting <= ALT_PRESSURE_MIN then
			altimeter_setting = ALT_PRESSURE_MIN
		end
	end	
end

function update()
	
	update_altimeter()
	
end

function update_altimeter()
	local altitude = sensor_data.getBarometricAltitude()*feet_per_meter
	
	local Baro1000 = math.floor(altimeter_setting)
	local Baro0100 = math.floor(altimeter_setting) % 10
	local Baro0010 = math.floor(altimeter_setting*10) % 10
	local Baro0001 = math.floor(altimeter_setting*100) % 10

	Baro_Press_1000:set(Baro1000)
	Baro_Press_0100:set(Baro0100)
	Baro_Press_0010:set(Baro0010)
	Baro_Press_0001:set(Baro0001)

	-- based on the barometric setting, adjust the displayed altitude
	local altitude_adjusted = (altimeter_setting - ALT_PRESSURE_STD)* 1000 -- 1000 feet per inHg / 10 feet per .01 in Hg

	Alt100:set((altitude + altitude_adjusted) % 1000)
	Alt1000:set((altitude + altitude_adjusted)% 10000)
	Alt10000:set(altitude + altitude_adjusted)

end
