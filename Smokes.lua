local dev 	    = GetSelf()
local update_time_ms 				= 1.0/20.0
local dt = update_time_ms
make_default_activity(update_time_ms)

local sensor_data 					= get_base_data()

local mColor_On_Off                 = get_param_handle("Color_On_Off")
local mWhite_On_Off                 = get_param_handle("White_On_Off")

local WhiteSmoke				= 10010		
local ColorSmoke		    		= 10011		

dev:listen_command(WhiteSmoke)	
dev:listen_command(ColorSmoke)

local mSmoke_White  = false
local mSmoke_Color  = false


function post_initialize()
	
end


function SetCommand(command, value)	

    -----------------------------------------------	
	--White Smoke
	-----------------------------------------------		    
	if command == WhiteSmoke then		
        

        if mSmoke_White then       
            mSmoke_White = false
        else
            mSmoke_White = true 
            if mSmoke_Color then
                mSmoke_Color = false
            end    
        end
    end    

    -----------------------------------------------
	--Color Smoke
	-----------------------------------------------
    if Rookie_Pilot then

        if command == ColorSmoke then
        
            if mSmoke_White then       
                mSmoke_White = false
            else
                mSmoke_White = true 
                if mSmoke_Color then
                    mSmoke_Color = false
                end    
            end
        end	
    
    else

        if command == ColorSmoke then
        
            if mSmoke_Color then
                mSmoke_Color = false
            else
                mSmoke_Color = true
                if mSmoke_White then
                    mSmoke_White = false
                end                
            end
        end	
    
    end
	
end    
    

function update()  


	anim_Smoke()
    
  
end


--Function
--=================================================
--Smoke
function anim_Smoke() 

    if mSmoke_White then
        mWhite_On_Off:set(1)
    else
        mWhite_On_Off:set(0)
    end
    if mSmoke_Color then 
        mColor_On_Off:set(1)
    else
        mColor_On_Off:set(0)
    end    
end                                                          
--=================================================
--=================================================
need_to_be_closed = false -- close lua state after initialization  do we need this