local dev = GetSelf()
local update_time_ms = 1.0/20.0
make_default_activity(update_time_ms)

local sensor_data = get_base_data()
local StopwatchM = get_param_handle("StopwatchM")
local StopwatchS = get_param_handle("StopwatchS")

local StartStopReset = 406


dev:listen_command(StartStopReset)


function SetCommand(command, value)

end

function update()

end