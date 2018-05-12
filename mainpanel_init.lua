
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
shape_name   	   = "BAE_cockpit"
is_EDM			   = true
new_model_format   = true
ambient_light    = {255,255,255}
ambient_color_day_texture    = {72, 100, 160}
ambient_color_night_texture  = {40, 60 ,150}
ambient_color_from_devices   = {50, 50, 40}
ambient_color_from_panels	 = {35, 25, 25}
dusk_border					 = 0.4
draw_pilot					 = false
external_model_canopy_arg	 = 38

use_external_views = false 
cockpit_local_point = {3.925,	0.936,	0}  -- position cockpit

day_texture_set_value   = 0.0
night_texture_set_value = 0.1

controllers = LoRegisterPanelControls()

mirrors_data = 
{
    center_point 	  = {0.60,0.40,0.00}, 
    width 		 	  = 0.35, --integrated (keep in mind that mirrors can be none planar )
    aspect 		 	  = 3.0,
	rotation 	 	  = math.rad(-20);
	animation_speed   = 2.0;
	near_clip 		  = 0.1;
	middle_clip		  = 10;
	far_clip		  = 60000;
	arg_value_when_on = 1.0;
}

mirrors_draw                    = CreateGauge()
mirrors_draw.arg_number    		= 103
mirrors_draw.input   			= {0,1}
mirrors_draw.output   			= {1,0}
mirrors_draw.controller         = controllers.mirrors_draw

CockpitCanopy				= CreateGauge()
CockpitCanopy.arg_number	= 98
CockpitCanopy.input			= {0.0, 1.0}
CockpitCanopy.output		= {0.0, 1.0}
--CockpitCanopy.controller	= controllers.base_gauge_CanopyState
CockpitCanopy.controller	= controllers.CockpitCanopy

StickPitch							= CreateGauge()
StickPitch.arg_number				= 2
StickPitch.input					= {-100, 100}
StickPitch.output					= {-1, 1}
StickPitch.controller				= controllers.base_gauge_StickPitchPosition

StickBank							= CreateGauge()
StickBank.arg_number				= 3
StickBank.input						= {-100, 100}
StickBank.output					= {-1, 1}
StickBank.controller				= controllers.base_gauge_StickRollPosition

RudderPedals						= CreateGauge()
RudderPedals.arg_number				= 4
RudderPedals.input					= {-100,100}
RudderPedals.output					= {1,-1}
RudderPedals.controller				= controllers.base_gauge_RudderPosition

ThrottleLeft						= CreateGauge()
ThrottleLeft.arg_number				= 5
ThrottleLeft.input					= {0, 1}
ThrottleLeft.output					= {0, 1}
ThrottleLeft.controller				= controllers.base_gauge_ThrottleLeftPosition

ThrottleRight						= CreateGauge()
ThrottleRight.arg_number			= 6
ThrottleRight.input					= {0, 1}
ThrottleRight.output				= {0, 1}
ThrottleRight.controller			= controllers.base_gauge_ThrottleRightPosition

Landinggearhandle					= CreateGauge()
Landinggearhandle.arg_number		= 8
Landinggearhandle.input				= {0, 1}
Landinggearhandle.output			= {0, 1}
Landinggearhandle.controller		= controllers.gear_handle_animation

---------------------------------------------------------------
-- ENGINE
---------------------------------------------------------------

Engine_RPM_L						= CreateGauge()
Engine_RPM_L.arg_number				= 16
Engine_RPM_L.input					= {0.0, 100.0} 
Engine_RPM_L.output					= {0.0, 1.0}
Engine_RPM_L.controller				= controllers.base_gauge_EngineLeftRPM

Engine_FF_L							= CreateGauge("parameter")
Engine_FF_L.parameter_name   		= "D_FFL"
Engine_FF_L.arg_number				= 60
Engine_FF_L.input					= {0.0, 100.0}
Engine_FF_L.output					= {0.0, 1.0}

Engine_TEMP_L						= CreateGauge()
Engine_TEMP_L.arg_number			= 52
Engine_TEMP_L.input					= {300, 1100} 
Engine_TEMP_L.output				= {0.3, 0.9}
Engine_TEMP_L.controller			= controllers.base_gauge_EngineLeftTemperatureBeforeTurbine

--Engine_RPM_R						= CreateGauge()
--Engine_RPM_R.arg_number				= 17
--Engine_RPM_R.input					= {0.0, 110.0} 
--Engine_RPM_R.output					= {0.0, 1.1}
--Engine_RPM_R.controller				= controllers.base_gauge_EngineRightRPM

Engine_FF_R							= CreateGauge("parameter")
Engine_FF_R.parameter_name   		= "D_FFR"
Engine_FF_R.arg_number				= 61
Engine_FF_R.input					= {0.0, 100.0}
Engine_FF_R.output					= {0.0, 1.0}

Engine_TEMP_R						= CreateGauge()
Engine_TEMP_R.arg_number			= 51
Engine_TEMP_R.input					= {300, 900} 
Engine_TEMP_R.output				= {0.3, 0.9}
Engine_TEMP_R.controller			= controllers.base_gauge_EngineRightTemperatureBeforeTurbine

---------------------------------------------------------------
-- INSTRUMENTS
---------------------------------------------------------------
--IAS_GAUGE      			  			= CreateGauge("parameter")
--IAS_GAUGE.parameter_name   			= "D_IAS"
--IAS_GAUGE.arg_number    	 		= 101
--IAS_GAUGE.input    		 			= {0.0, 1000} 
--IAS_GAUGE.output    		  		= {0.0, 1.0} 

IndicatedAirSpeed							= CreateGauge()
IndicatedAirSpeed.arg_number				= 101
IndicatedAirSpeed.input						= {0.0, 514.444444}  --m/s
IndicatedAirSpeed.output					= {0.0, 1.0}
IndicatedAirSpeed.controller				= controllers.base_gauge_IndicatedAirSpeed

VerticalVelocity					= CreateGauge()
VerticalVelocity.arg_number			= 24
VerticalVelocity.input				= {-30.5, -20.3, -10.2, -5.1, -2.5,  0, 2.5,  5.1, 10.2, 20.3, 30.5}
VerticalVelocity.output				= {-0.6,  -0.4,   -0.2, -0.1, -0.05, 0, 0.05, 0.1, 0.2,  0.4,  0.6}
VerticalVelocity.controller			= controllers.base_gauge_VerticalVelocity

Gload								= CreateGauge()
Gload.arg_number					= 7
Gload.input							= {-10.0, 10.0}
Gload.output						= {-1.0, 1.00}
Gload.controller					= controllers.base_gauge_VerticalAcceleration

MaximG                              = CreateGauge("parameter")
MaximG.parameter_name               = "MaxiG"
MaximG.arg_number                   = 71
MaximG.input                        = {0, 10}
MaximG.output                       = {0, 1.0}

MinimG                              = CreateGauge("parameter")
MinimG.parameter_name               = "MiniG"
MinimG.arg_number                   = 72
MinimG.input                        = {-4, 0}
MinimG.output                       = {-0.4, 0}

--AOA_Units							= CreateGauge("parameter")
--AOA_Units.parameter_name   			= "D_AOA"
--AOA_Units.arg_number				= 10
--AOA_Units.input						= {0.0, 3000.0}
--AOA_Units.output					= {0.0, 30.0}

HrzRoll								= CreateGauge()
HrzRoll.arg_number					= 26
HrzRoll.input						= {-math.pi, math.pi}
HrzRoll.output						= {-1.0, 1.00}
HrzRoll.controller					= controllers.base_gauge_Roll

HrzPitch							= CreateGauge()
HrzPitch.arg_number					= 27
HrzPitch.input						= {-math.pi, math.pi}
HrzPitch.output						= {1.0, -1.00}
HrzPitch.controller					= controllers.base_gauge_Pitch


-------------------------------------------------------------
-----------------------Altimeter-------------------------
------------------------------------------------------------
--100 ft needle
Alt_100ft_Gauge               		= CreateGauge("parameter")
Alt_100ft_Gauge.parameter_name   	= "Alt100"
Alt_100ft_Gauge.arg_number     		= 18
Alt_100ft_Gauge.input          		= {0.0, 1000}
Alt_100ft_Gauge.output         		= {0.0, 1}

--1000 ft needle
Alt_1000ft_Gauge               		= CreateGauge("parameter")
Alt_1000ft_Gauge.parameter_name   	= "Alt1000"
Alt_1000ft_Gauge.arg_number    		= 19
Alt_1000ft_Gauge.input         		= {0.0, 10000}
Alt_1000ft_Gauge.output        		= {0.0, 1.0}

--10000 ft gauge
Alt_10000ft_Gauge 			  		 = CreateGauge("parameter")
Alt_10000ft_Gauge.parameter_name   	 = "Alt10000"
Alt_10000ft_Gauge.arg_number    	 = 57
Alt_10000ft_Gauge.input    		 	 = {0.0,40000} 
Alt_10000ft_Gauge.output    		 = {0.0,0.4}


Alt_Baro_Press_1000_Gauge					= CreateGauge("parameter")
Alt_Baro_Press_1000_Gauge.parameter_name 	= "Alt_Baro_Press_1000"
Alt_Baro_Press_1000_Gauge.arg_number		= 73
Alt_Baro_Press_1000_Gauge.input 			= {0.0, 10}
Alt_Baro_Press_1000_Gauge.output 			= {0.0, 1.0}

Alt_Baro_Press_0100_Gauge					= CreateGauge("parameter")
Alt_Baro_Press_0100_Gauge.parameter_name 	= "Alt_Baro_Press_0100"
Alt_Baro_Press_0100_Gauge.arg_number		= 74
Alt_Baro_Press_0100_Gauge.input 			= {0.0, 10}
Alt_Baro_Press_0100_Gauge.output 			= {0.0, 1.0}

Alt_Baro_Press_0010_Gauge					= CreateGauge("parameter")
Alt_Baro_Press_0010_Gauge.parameter_name 	= "Alt_Baro_Press_0010"
Alt_Baro_Press_0010_Gauge.arg_number		= 75
Alt_Baro_Press_0010_Gauge.input 			= {0.0, 10}
Alt_Baro_Press_0010_Gauge.output 			= {0.0, 1.0}

Alt_Baro_Press_0001_Gauge					= CreateGauge("parameter")
Alt_Baro_Press_0001_Gauge.parameter_name 	= "Alt_Baro_Press_0001"
Alt_Baro_Press_0001_Gauge.arg_number		= 76
Alt_Baro_Press_0001_Gauge.input 			= {0.0, 10}
Alt_Baro_Press_0001_Gauge.output 			= {0.0, 1.0}

------------------------------STOPWATCH-------------------------------------
--add hours when ready

StopwatchM									= CreateGauge("parameter")
StopwatchM.arg_number						= 91
StopwatchM.input							= {0,60}
StopwatchM.output							= {0,1}
StopwatchM.parameter_name 					= "StopwatchM"

StopwatchS									= CreateGauge("parameter")
StopwatchS.arg_number						= 90
StopwatchS.input							= {0,60}
StopwatchS.output							= {0,1}
StopwatchS.parameter_name 					= "StopwatchS"


----------------------------------------------------------------------------

CompassRose							= CreateGauge()  
CompassRose.arg_number				= 28
CompassRose.input					= {0.0, math.rad(360.0)}
CompassRose.output					= {0.0, 1.0}
CompassRose.controller				= controllers.base_gauge_Heading

TotalFuel							= CreateGauge("parameter")
TotalFuel.parameter_name   			= "D_FUEL"
TotalFuel.arg_number				= 25
TotalFuel.input						= {0.0, 1300}
TotalFuel.output					= {0.0, 1.3}

G_MACH      			  			= CreateGauge("parameter")
G_MACH.parameter_name   			= "D_MACH"
G_MACH.arg_number    	 			= 9
G_MACH.input    		 			= {0.0,1.0} 
G_MACH.output    		  			= {0.0,1.0} 

FlapsPos							= CreateGauge()
FlapsPos.arg_number					= 42
FlapsPos.input						= {0.0, 20.0} 
FlapsPos.output						= {0.0, 1.00}
FlapsPos.controller					= controllers.base_gauge_FlapsPos

L_BAY     			  				= CreateGauge("parameter")
L_BAY.parameter_name   				= "L_Trappes"
L_BAY.arg_number    	 			= 53
L_BAY.input    		 				= {0.0,1.0} 
L_BAY.output    		  			= {0.0,1.0}

L_AF     			  				= CreateGauge("parameter")
L_AF.parameter_name   				= "L_AF"
L_AF.arg_number    	 				= 45
L_AF.input    		 				= {0.0,1.0} 
L_AF.output    		  				= {0.0,1.0}

L_gear     			  				= CreateGauge("parameter")
L_gear.parameter_name   			= "Gear_status"
L_gear.arg_number    	 			= 54
L_gear.input    		 			= {0.0,1.0} 
L_gear.output    		  			= {0.0,1.0}

Pi_HYD1     			  			= CreateGauge("parameter")
Pi_HYD1.parameter_name   			= "P_HYD1"
Pi_HYD1.arg_number    	 			= 55
Pi_HYD1.input    		 			= {0.0,30} 
Pi_HYD1.output    		  			= {0.0,0.3}

Pi_HYD2     			  			= CreateGauge("parameter")
Pi_HYD2.parameter_name   			= "P_HYD2"
Pi_HYD2.arg_number    	 			= 56
Pi_HYD2.input    		 			= {0.0,30} 
Pi_HYD2.output    		  			= {0.0,0.3}


FLAPS      			  				= CreateGauge("parameter")
FLAPS.parameter_name   				= "flaps_status"
FLAPS.arg_number    	 			= 58
FLAPS.input    		 				= {0.0,1.0} 
FLAPS.output    		  			= {0.0,1.0}

FLAPSWITCH      			  		= CreateGauge("parameter")
FLAPSWITCH.parameter_name   		= "D_flaps_command"
FLAPSWITCH.arg_number    	 		= 59
FLAPSWITCH.input    		 		= {0.0,1.0} 
FLAPSWITCH.output    		  		= {0.0,1.0}

L_TNS								= CreateGauge("parameter")
L_TNS.parameter_name   				= "L_TNS"
L_TNS.arg_number					= 63
L_TNS.input							= {0.0, 1.0}
L_TNS.output						= {0.0, 1.0}

L_SMOKE								= CreateGauge("parameter")
L_SMOKE.parameter_name   			= "L_SMOKE"
L_SMOKE.arg_number					= 62
L_SMOKE.input						= {0.0, 1.0}
L_SMOKE.output						= {0.0, 1.0}

L_WBRAKE							= CreateGauge("parameter")
L_WBRAKE.parameter_name   			= "L_WBRAKE"
L_WBRAKE.arg_number					= 15
L_WBRAKE.input						= {0.0, 1.0}
L_WBRAKE.output						= {0.0, 1.0}

L_250L								= CreateGauge("parameter")
L_250L.parameter_name   			= "L_250L"
L_250L.arg_number					= 20
L_250L.input						= {0.0, 1.0}
L_250L.output						= {0.0, 1.0}

L_WINGL								= CreateGauge("parameter")
L_WINGL.parameter_name   			= "L_WINGL"
L_WINGL.arg_number					= 21
L_WINGL.input						= {0.0, 1.0}
L_WINGL.output						= {0.0, 1.0}

L_WINGR								= CreateGauge("parameter")
L_WINGR.parameter_name   			= "L_WINGR"
L_WINGR.arg_number					= 22
L_WINGR.input						= {0.0, 1.0}
L_WINGR.output						= {0.0, 1.0}

L_FLAPS								= CreateGauge("parameter")
L_FLAPS.parameter_name   			= "L_FLAPS"
L_FLAPS.arg_number					= 64
L_FLAPS.input						= {0.0, 1.0}
L_FLAPS.output						= {0.0, 1.0}

L_VD_G								= CreateGauge("parameter")
L_VD_G.parameter_name   			= "L_VD_G"
L_VD_G.arg_number					= 65
L_VD_G.input						= {0.0, 1.0}
L_VD_G.output						= {0.0, 1.0}

L_VD_D								= CreateGauge("parameter")
L_VD_D.parameter_name   			= "L_VD_D"
L_VD_D.arg_number					= 66
L_VD_D.input						= {0.0, 1.0}
L_VD_D.output						= {0.0, 1.0}

PANEL_LIGHT_FRONT					= CreateGauge("parameter")
PANEL_LIGHT_FRONT.parameter_name   	= "PANEL-LIGHT-FRONT"
PANEL_LIGHT_FRONT.arg_number		= 555
PANEL_LIGHT_FRONT.input				= {0.0, 1.0}
PANEL_LIGHT_FRONT.output			= {0.0, 1.0}

-- L_NAV								= CreateGauge("parameter")
-- L_NAV.parameter_name   				= "T_NAVLIGHT"
-- L_NAV.arg_number					= 190
-- L_NAV.input							= {0.0, 1.0}
-- L_NAV.output						= {0.0, 1.0}

-- L_FORM							= CreateGauge("parameter")
-- L_FORM.parameter_name   			= "T_FORMLIGHT"
-- L_FORM.arg_number					= 204
-- L_FORM.input						= {0.0, 1.0}
-- L_FORM.output						= {0.0, 1.0}

-- L_STROBE							= CreateGauge("parameter")
-- L_STROBE.parameter_name   			= "T_STROBELIGHT"
-- L_STROBE.arg_number					= 195
-- L_STROBE.input						= {0.0, 1.0}
-- L_STROBE.output						= {0.0, 1.0}


--local controllers			= LoRegisterPanelControls()
-------------------------------------------------------------------------------------------
--        This is Essential don't delete
-------------------------------------------------------------------------------------------
--Smoke System
White_On_Off 					    = CreateGauge("parameter")
White_On_Off.arg_number		        = 703			
White_On_Off.input			        = { 0.0, 1.0}
White_On_Off.output			        = { 0.0, 1.0}
White_On_Off.parameter_name	        = "White_On_Off"

Color_On_Off 					    = CreateGauge("parameter")
Color_On_Off.arg_number		        = 704			
Color_On_Off.input			        = { 0.0, 1.0}
Color_On_Off.output			        = { 0.0, 1.0}
Color_On_Off.parameter_name	        = "Color_On_Off"
-------------------------------------------------------------------------------------------
--=========================================================================================
--dofile(LockOn_Options.common_script_path.."tools.lua")


need_to_be_closed = true -- close lua state after initialization 

Z_test =
{
	near = 0.05,
	far  = 4.0,
}

--[[ available functions 

 --base_gauge_RadarAltitude
 --base_gauge_BarometricAltitude
 --base_gauge_AngleOfAttack
 --base_gauge_AngleOfSlide
 --base_gauge_VerticalVelocity
 --base_gauge_TrueAirSpeed
 --base_gauge_IndicatedAirSpeed
 --base_gauge_MachNumber
 --base_gauge_VerticalAcceleration --Ny
 --base_gauge_HorizontalAcceleration --Nx
 --base_gauge_LateralAcceleration --Nz
 --base_gauge_RateOfRoll
 --base_gauge_RateOfYaw
 --base_gauge_RateOfPitch
 --base_gauge_Roll
 --base_gauge_MagneticHeading
 --base_gauge_Pitch
 --base_gauge_Heading
 --base_gauge_EngineLeftFuelConsumption
 --base_gauge_EngineRightFuelConsumption
 --base_gauge_EngineLeftTemperatureBeforeTurbine
 --base_gauge_EngineRightTemperatureBeforeTurbine
 --base_gauge_EngineLeftRPM
 --base_gauge_EngineRightRPM
 --base_gauge_WOW_RightMainLandingGear
 --base_gauge_WOW_LeftMainLandingGear
 --base_gauge_WOW_NoseLandingGear
 --base_gauge_RightMainLandingGearDown
 --base_gauge_LeftMainLandingGearDown
 --base_gauge_NoseLandingGearDown
 --base_gauge_RightMainLandingGearUp
 --base_gauge_LeftMainLandingGearUp
 --base_gauge_NoseLandingGearUp
 --base_gauge_LandingGearHandlePos
 --base_gauge_StickRollPosition
 --base_gauge_StickPitchPosition
 --base_gauge_RudderPosition
 --base_gauge_ThrottleLeftPosition
 --base_gauge_ThrottleRightPosition
 --base_gauge_HelicopterCollective
 --base_gauge_HelicopterCorrection
 --base_gauge_CanopyPos
 --base_gauge_CanopyState
 --base_gauge_FlapsRetracted
 --base_gauge_SpeedBrakePos
 --base_gauge_FlapsPos
 --base_gauge_TotalFuelWeight

--]]
