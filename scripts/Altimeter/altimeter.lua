local dev 	    = GetSelf()
local sensor_data = get_base_data()

local feet_per_meter = 3.2808399

local update_time_step = 0.05
make_default_activity(update_time_step)
--update will be called 50 times per second

local AnimationPpress_adjIncDt      = 0.2
local AnimationAltimIncDec          = update_time_step / 0.05

local Alt10000 = get_param_handle("Alt10000")
local Alt1000  = get_param_handle("Alt1000")
local Alt100   = get_param_handle("Alt100")

local Baro_Adj = 3002
local Baro_Press_0001 = get_param_handle("Baro_Press_0001")


dev:listen_command(Baro_Adj)

Alt100:set(0)
Alt1000:set(0)
Alt10000:set(0)

Baro_Press_0001:set(0)
Pressure = 0 
Altitude = 0
local Baro_Adj_left = false --barometric adjustment switch centered
local Baro_Adj_right = false --barometric adjustment switch centered
Minimum_Pressure = 950
Maximum_Pressure = 1050


------------------------
-- Reference
------------------------
--local ALT_PRESSURE_MAX = 30.99 -- in Hg
--local ALT_PRESSURE_MIN = 29.10 -- in Hg
--local ALT_PRESSURE_STD = 29.92 -- in Hg

--local alt_needle = get_param_handle("D_ALT_NEEDLE") -- 0 to 1000
--local alt_10k = get_param_handle("D_ALT_10K") -- 0 to 100,000
--local alt_1k = get_param_handle("D_ALT_1K") -- 0 to 10,000
--local alt_100s = get_param_handle("D_ALT_100S") -- 0 to 1000
--local alt_adj_NNxx = get_param_handle("ALT_ADJ_NNxx") -- first digits, 29-30 is input
--local alt_adj_xxNx = get_param_handle("ALT_ADJ_xxNx") -- 3rd digit, 0-10 input
--local alt_adj_xxxN = get_param_handle("ALT_ADJ_xxxN") -- 4th digit, 0-10 input

--local alt_setting = ALT_PRESSURE_STD

------------------------


function post_initialize()
    
end

function SetCommand(command,value)	

	--Rotate barometric adjustment switch right	
	if command == Baro_Adj > 0 then
		Baro_Adj_right = true
	end

	--Rotate barometric adjustment switch left
	if command == Baro_Adj > 0 then
		Baro_Adj_left = true
	end
end

function update()
	
	update_altimeter()
	update_barometric_pressure()
	
end

function update_altimeter()
	local Altitude = sensor_data.getBarometricAltitude()*feet_per_meter
	
	Alt100:set((Altitude) % 1000)
	Alt1000:set((Altitude)% 10000)
	Alt10000:set(Altitude)
end

function update_barometric_pressure()

	if Baro_Adj_right then
		Pressure = Pressure - AnimationPpress_adjIncDt
		Baro_Adj_right = false
		if Pressure < Minimum_Pressure then
			Pressure = Minimum_Pressure
		end
	end


	if Baro_Adj_left then
		Pressure = Pressure + AnimationPpress_adjIncDt
		Baro_Adj_left = false
		if Pressure > Maximum_Pressure then
			Pressure = Maximum_Pressure
		end
	end

end


--function update_altimeter()
    -- altimeter
    --local alt = sensor_data.getBarometricAltitude()*meters_to_feet

    --local altNNxx = math.floor(alt_setting)         -- for now just make it discrete
    --local altxxNx = math.floor(alt_setting*10) % 10
    --local altxxxN = math.floor(alt_setting*100) % 10

    -- first update the selected setting value displayed
    --alt_adj_NNxx:set(altNNxx)
    --alt_adj_xxNx:set(altxxNx)
    --alt_adj_xxxN:set(altxxxN)

    -- based on setting, adjust displayed altitude
    --local alt_adj = (alt_setting - ALT_PRESSURE_STD)*1000   -- 1000 feet per inHg / 10 feet per .01 inHg -- if we set higher pressure than actual => altimeter reads higher

    --alt_10k:set((alt+alt_adj) % 100000)
    --alt_1k:set((alt+alt_adj) % 10000)
    --alt_100s:set((alt+alt_adj) % 1000)
    --alt_needle:set((alt+alt_adj) % 1000)
--end