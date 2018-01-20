local dev 	    = GetSelf()

local update_time_step = 0.1
make_default_activity(update_time_step) --update will be called 10 times per second

local sensor_data = get_base_data()


function update()

end

need_to_be_closed = true -- close lua state after initialization