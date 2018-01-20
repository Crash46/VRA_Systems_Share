local dev 	    = GetSelf()
local sensor_data = get_base_data()

local feet_per_meter = 3.2808399

local update_time_step = 1.0/20
make_default_activity(update_time_step)
--update will be called 10 times per second

local L_10K = get_param_handle("L_10K")
local Alt100FTVRA = get_param_handle("Alt100FTVRA")
local Alt1000FTVRA = get_param_handle("Alt1000FTVRA")
local Alt10000FTVRA = get_param_handle("Alt10000FTVRA")
local Timer = 0

Alt100FTVRA:set(0)
Alt1000FTVRA:set(0)
Alt10000FTVRA:set(0)
Altitude = 0
T_10K_ARM = 0
L_10K:set(0) 

local mPressure                     = 1008 -- pressure start


function post_initialize()
    
end

function SetCommand(command,value)			
		
	if command == 3001 then  -- Reset
		L_10K:set(0)
		T_10K_ARM = 0
	end
end

function update()
	local Altitude = sensor_data.getBarometricAltitude()*feet_per_meter


	
	Alt100:set(((Altitude)/10) % 1000)	 			-- 12345 % 1000 = 345
	Alt1000:set((((Altitude)/100) % 10000 ) % 100)  -- 12345 % 10000 = 2345
	Alt10000:set((Altitude)/10000)
	
	Alt100FTVRA:set((Altitude) % 1000)
	Alt1000FTVRA:set((Altitude)% 10000)
	Alt10000FTVRA:set(Altitude)
		
	-- 10 000ft annunciator setup
	if Altitude > 10000 then
		T_10K_ARM = 1
	end
	-- 10 000ft annunciator light
	if Altitude < 10000 and T_10K_ARM > 0 then
		Timer = Timer +1
		if math.mod(Timer,10) > 5 then   -- (10 units = 1 sec) 5 units =0.5 seconds
			L_10K:set(1)
			else
			L_10K:set(0)
		end
	end	
	
	-- L_10K:set(L_10K)
	
end