local dev = GetSelf()
local update_time_ms = 1.0/20.0
make_default_activity(update_time_ms)

local sensor_data = get_base_data()


local StopwatchM = get_param_handle("StopwatchM")
local StopwatchS = get_param_handle("StopwatchS")

local StartStopReset = 3406

local mHours 							= 0
local mMin 							= 0
local mSec 							= 0
local mMovingCrono					= false
local mSecCrono						= 0
local mSecStartCrono				= 0
local mTimeSwitch					= 0   --  1 = Time OS /  0 = Time Mission  
local mMin_Sec                      = "X" -- "Minuti"  -- "Secondi"

dev:listen_command(StartStopReset)


function SetCommand(command, value)

	if command == StartStopReset then
	
		if mMovingCrono then
			mSecStartCrono = 0
			mMovingCrono = false
            mMin_Sec = "X"
		else
			mSecStartCrono = tonumber(os.time())
			mMovingCrono = true		
            mMin_Sec = "Secondi"

		end
	end

	if command == StartStopReset then
		print_message_to_user("button pressed")
	
		if mMovingCrono then
			mSecStartCrono = 0
			mMovingCrono = false
            mMin_Sec = "X"
		else
			mSecStartCrono = tonumber(os.date('%M'))
			mMovingCrono = true		
            mMin_Sec = "Minuti"
		end
	end


end

function update()

	main()
	animate_StopWatch()

	StopwatchM:set(mMin)
	StopwatchS:set(mSec)
end

function main()

	local mIntHours = 0

	if mTimeSwitch == 1 then
		mHours = tonumber(os.date('%I')) +  (tonumber(os.date('%M'))/60)
		mMin = tonumber(os.date('%M'))
		mSec = tonumber(os.date('%S'))
	else

		mIntHours = tonumber(math.floor(get_absolute_model_time()/60/60))
		mMin = tonumber(math.floor(get_absolute_model_time()/60)-(mIntHours*60))
		mSec = tonumber(math.floor(get_absolute_model_time()-(mIntHours*60*60)-(mMin*60))) 
		mHours = tonumber(math.floor(get_absolute_model_time()/60/60)) + (mMin/60)
		
	end
	if mHours > 12 then
		mHours = mHours - 12
	end

end

function animate_StopWatch()

	if mMovingCrono and mMin_Sec == "Secondi" then -- Seconds
			if mSecCrono < 60 then
				mSecCrono = tonumber(os.time()) - mSecStartCrono
			else
				mSecStartCrono = tonumber(os.time())
				mSecCrono = tonumber(os.time()) - mSecStartCrono
			end	
		end
	    
	    if mMovingCrono and mMin_Sec == "Minuti" then   -- Minutes
			if mSecCrono < 60 then
				mSecCrono = tonumber(os.date('%M')) - mSecStartCrono
			else
				mSecStartCrono = tonumber(os.date('%M'))
				mSecCrono = tonumber(os.date('%M')) - mSecStartCrono
			end	
		end
end