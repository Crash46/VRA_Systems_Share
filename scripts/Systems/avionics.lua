local dev = GetSelf()

local update_time_step = 0.1
make_default_activity(update_time_step)
--update will be called 10 times per second
local sensor_data = get_base_data()

-- Const

local degrees_per_radian = 57.2957795
local feet_per_meter_per_minute = 196.8

-- Variables
local DC_BUS_V  = get_param_handle("DC_BUS_V")
local ias = get_param_handle("D_IAS")
local mach = get_param_handle("D_MACH")
local AOA = get_param_handle("D_AOA")
local hdg = get_param_handle("D_HDG")
local vv = get_param_handle("D_VV")
local altitude_source = get_param_handle("ALT_SOURCE")
local altitude = get_param_handle("D_ALT")
local RPMG = get_param_handle("D_RPMG")
local RPMD = get_param_handle("D_RPMD")
local test = get_param_handle("D_TEST")
local pitch = get_param_handle("D_PITCH")
local L_VD_G = get_param_handle("L_VD_G")
local L_VD_D = get_param_handle("L_VD_D")
local ELEC_P2 = get_param_handle("ELEC_P2")
local FLAPSPOS = get_param_handle("FLAPSPOS")
local COCKPIT = get_param_handle("COCKPIT")

-- Initialisation
DC_BUS_V:set(0)
mach:set(0.0)
AOA:set(0.0)
ias:set(0.0)
hdg:set(0.0)
vv:set(0.0)
altitude:set(0.0)
RPMG:set(0.0)
RPMD:set(0.0)
test:set(0.0)
pitch:set(0.0)
L_VD_G:set(0.0)
L_VD_D:set(0.0)
FLAPSPOS:set(0.0)
COCKPIT:set(0.0)

function post_initialize()
	
	electric_system = GetDevice(3) --devices["ELECTRIC_SYSTEM"]
	-- print("post_initialize called")
end

function SetCommand(command,value)
			
end

function update()
	
	ias:set(sensor_data.getIndicatedAirSpeed()*1.9438444924574)
	mach:set(sensor_data.getMachNumber())
	AOA:set(sensor_data.getAngleOfAttack()*degrees_per_radian)
	hdg:set(360-(sensor_data.getHeading()*degrees_per_radian))
	vv:set(sensor_data.getVerticalVelocity()*feet_per_meter_per_minute)
	RPMG:set(sensor_data.getEngineLeftRPM())  -- sensor_data.getEngineLeftRPM()
	RPMD:set(sensor_data.getEngineRightRPM())
	pitch:set(sensor_data.getStickRollPosition())  -- *degrees_per_radian
	test:set(sensor_data.getHorizontalAcceleration())
	FLAPSPOS:set(sensor_data.getFlapsPos())
	COCKPIT:set(sensor_data.getCanopyPos())
	
	-- Altitude
	local barometric_altitude = sensor_data.getBarometricAltitude()*3.28084
	local radar_altitude = sensor_data.getRadarAltitude()*3.28084
	if radar_altitude > 495 then
	  altitude:set(barometric_altitude)
	  altitude_source:set("B")
	else
	  altitude:set(radar_altitude)
	  altitude_source:set("R")
	end
	
	-- Light Vanne Decharge
	if RPMG:get() > 5 and RPMG:get() < 80 and ELEC_P2:get() == 1 then
		L_VD_G:set(1)
		else
		L_VD_G:set(0)
	end
	
	if RPMD:get() > 5 and RPMD:get() < 80 and ELEC_P2:get() == 1 then
		L_VD_D:set(1)
		else
		L_VD_D:set(0)
	end
	
	-- Dinosaur electric system
	if electric_system ~= nil then
	   local DC_V     =  electric_system:get_DC_Bus_1_voltage()
	   local prev_val =  DC_BUS_V:get()
	   -- add some dynamic: 
	   DC_V = prev_val + (DC_V - prev_val) * update_time_step   
	   DC_BUS_V:set(DC_V)
	end	
end

need_to_be_closed = false -- close lua state after initialization

-- getAngleOfAttack
-- getAngleOfSlide
-- getBarometricAltitude
-- getCanopyPos
-- getCanopyState
-- getEngineLeftFuelConsumption --
-- getEngineLeftRPM
-- getEngineLeftTemperatureBeforeTurbine
-- getEngineRightFuelConsumption
-- getEngineRightRPM
-- getEngineRightTemperatureBeforeTurbine
-- getFlapsPos
-- getFlapsRetracted
-- getHeading
-- getHelicopterCollective
-- getHelicopterCorrection
-- getHorizontalAcceleration
-- getIndicatedAirSpeed
-- getLandingGearHandlePos
-- getLateralAcceleration
-- getLeftMainLandingGearDown
-- getLeftMainLandingGearUp
-- getMachNumber
-- getMagneticHeading
-- getNoseLandingGearDown
-- getNoseLandingGearUp
-- getPitch
-- getRadarAltitude
-- getRateOfPitch
-- getRateOfRoll
-- getRateOfYaw
-- getRightMainLandingGearDown
-- getRightMainLandingGearUp
-- getRoll
-- getRudderPosition --
-- getSpeedBrakePos
-- getStickPitchPosition
-- getStickRollPosition
-- getThrottleLeftPosition
-- getThrottleRightPosition
-- getTotalFuelWeight  
-- getTrueAirSpeed
-- getVerticalAcceleration
-- getVerticalVelocity
-- getWOW_LeftMainLandingGear
-- getWOW_NoseLandingGear
-- getWOW_RightMainLandingGear



