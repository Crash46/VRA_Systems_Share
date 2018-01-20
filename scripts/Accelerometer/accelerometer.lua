local dev = GetSelf()

local update_time_step = 0.1

make_default_activity(update_time_step)
--update will be called 10 times per second

local sensor_data = get_base_data()

local current_G = get_param_handle("current_G")
local MaxiG = get_param_handle("MaxiG")
local MiniG = get_param_handle("MiniG")

current_G:set(0.0)
MaxiG:set(1)
MiniG:set(1)


function post_initialize()
    
end

function SetCommand(command,value)			
		
	if command == 3001 then  -- Reset
		MaxiG:set(1)
		MiniG:set(1)
	end
end

function update()
    current_G:set(sensor_data.getVerticalAcceleration())
	
	local G_load = sensor_data.getVerticalAcceleration()
	local maximumG = MaxiG:get()
	local minimumG = MiniG:get()
	
	if G_load > maximumG then maximumG = G_load end
	if G_load < minimumG then minimumG = G_load end
	
	MaxiG:set(maximumG)
	MiniG:set(minimumG)
	
end

need_to_be_closed = false -- close lua state after initialization