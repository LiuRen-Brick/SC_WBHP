------------------------------------
-- 提示
-- 如果使用其他Lua编辑工具编辑此文档，请将VisualTFT软件中打开的此文件编辑器视图关闭，
-- 因为VisualTFT具有自动保存功能，其他软件修改时不能同步到VisualTFT编辑视图，
-- VisualTFT定时保存时，其他软件修改的内容将被恢复。
--
-- Attention
-- If you use other Lua Editor to edit this file, please close the file editor view 
-- opened in the VisualTFT, Because VisualTFT has an automatic save function, 
-- other Lua Editor cannot be synchronized to the VisualTFT edit view when it is modified.
-- When VisualTFT saves regularly, the content modified by other Lua Editor will be restored.
------------------------------------

--下面列出了常用的回调函数
--更多功能请阅读<<LUA脚本API.pdf>>
--------------------------------------------------------------
--页面定义
local mlu_home_page  = 0
local mlu_ask_page = 1
local self_inspection_page = 5
local set_page = 2


CMD_BOOT_UP = 0xB2
CMD_CONNECT = 0xB0
CMD_BOOT_DOWN = 0xB3
CMD_PRR = 0xB7
local btn_id = 0
local uart_send_counter = 0
---------------------------------
--Default  time
local def_min_timer = 10
local def_sec_timer = 00
local def_hour_timer = 00
--------------------------------------------------------------------
 chanel_1 =  {0,10,0,0,20,0}        -----------------------chanel one  下标1: hours 2: min 3: sec 4:保留 5:duty  6:保留---------------
 chanel_2 =  {0,20,0,0,20,0}
 chanel_3 =  {0,30,0,0,20,0}
 chanel_4 =  {0,40,0,0,20,0}
 chanel_5 =  {0,50,0,0,20,0}
 chanel_6 =  {0,60,0,0,20,0}

 temp= {A4,26.7,62.8,82.61,99.9,28.8,0}
 freq_chanel= {A5,700,800,900,1000,1100,0}
local chanel_sta ={2,2,2,2,2,2} 
local chanel_state = 0x00
local chanel_connect = 0x3F
   ---------------------chanel state array-----------------
-----------------------------------------
local preset_value_curr ={}
local  preset_value_1 = {}              -------------------duty&min of six chanel
  preset_value_1[1]={20,10}
  preset_value_1[2]={20,10}
  preset_value_1[3]={20,10}
  preset_value_1[4]={20,10}
  preset_value_1[5]={20,10}
  preset_value_1[6]={20,10} 

local  preset_value_2 = {}
  preset_value_2[1]={20,10}
  preset_value_2[2]={20,10}
  preset_value_2[3]={20,10}
  preset_value_2[4]={20,10}
  preset_value_2[5]={20,10}
  preset_value_2[6]={20,10} 
local  preset_value_3 = {}
  preset_value_3[1]={31,31}
  preset_value_3[2]={32,32}
  preset_value_3[3]={33,33}
  preset_value_3[4]={34,34}
  preset_value_3[5]={35,35}
  preset_value_3[6]={36,36} 
local  last_used = {}
  last_used[1]={20,10}
  last_used[2]={20,10}
  last_used[3]={20,10}
  last_used[4]={20,10}
  last_used[5]={20,10}
  last_used[6]={20,10} 

preset_value_1_addr = 0x00
preset_value_2_addr = 0x12
preset_value_3_addr = 0x24
last_used_addr = 0x36
---------------------------------------SIX chanel config read------------------------------
function flash_read_array(addr)
		local temp_array ={}
 	local  preset_value_id = {}
  preset_value_id[1]={}
  preset_value_id[2]={}
  preset_value_id[3]={}
  preset_value_id[4]={}
  preset_value_id[5]={}
  preset_value_id[6]={} 
		temp_array = read_flash(addr,18)
		if #temp_array  == 0 then

		else
		preset_value_id [1][1] = (temp_array[0])  & 0xFF
 		preset_value_id [1][2] =((temp_array[1] <<8 )| temp_array[2])&0xFFFF

		preset_value_id [2][1] = (temp_array[3])  & 0xFF
 		preset_value_id [2][2] =((temp_array[4] <<8 )| temp_array[5])&0xFFFF

 		preset_value_id [3][1] = (temp_array[6])  & 0xFF
 		preset_value_id [3][2] =((temp_array[7] <<8 )| temp_array[8])&0xFFFF

 		preset_value_id [4][1] = (temp_array[9])  & 0xFF
 		preset_value_id [4][2] =((temp_array[10] <<8 )| temp_array[11])&0xFFFF	

 		preset_value_id [5][1] = (temp_array[12])  & 0xFF
 		preset_value_id [5][2] =((temp_array[13] <<8 )| temp_array[14])&0xFFFF	

 		preset_value_id [6][1] = (temp_array[15])  & 0xFF
 		preset_value_id [6][2] =((temp_array[16] <<8 )| temp_array[17])&0xFFFF	
		return  preset_value_id
 		end
 
end
-----------------------------save	conf to	flash
function save_conf_chanel()
	local icon_code = get_value (mlu_home_page,2)
	if icon_code == 6 then         
	  preset_value_1[1]={get_value (mlu_home_page,55),get_value (mlu_home_page,49)}
	  preset_value_1[2]={get_value (mlu_home_page,56),get_value (mlu_home_page,50)}
      preset_value_1[3]={get_value (mlu_home_page,57),get_value (mlu_home_page,51)}
      preset_value_1[4]={get_value (mlu_home_page,58),get_value (mlu_home_page,52)}
      preset_value_1[5]={get_value (mlu_home_page,59),get_value (mlu_home_page,53)}
      preset_value_1[6]={get_value (mlu_home_page,60),get_value (mlu_home_page,54)}
 	 flash_write_array(preset_value_1,preset_value_1_addr ) 
	end
 if icon_code == 7 then          
	  preset_value_2[1]={get_value (mlu_home_page,55),get_value (mlu_home_page,49)}
	  preset_value_2[2]={get_value (mlu_home_page,56),get_value (mlu_home_page,50)}
      preset_value_2[3]={get_value (mlu_home_page,57),get_value (mlu_home_page,51)}
      preset_value_2[4]={get_value (mlu_home_page,58),get_value (mlu_home_page,52)}
      preset_value_2[5]={get_value (mlu_home_page,59),get_value (mlu_home_page,53)}
      preset_value_2[6]={get_value (mlu_home_page,60),get_value (mlu_home_page,54)}
 	 flash_write_array(preset_value_2,preset_value_2_addr )  
	end
	if icon_code == 8 then          
	  preset_value_3[1]={get_value (mlu_home_page,55),get_value (mlu_home_page,49)}
	  preset_value_3[2]={get_value (mlu_home_page,56),get_value (mlu_home_page,50)}
      preset_value_3[3]={get_value (mlu_home_page,57),get_value (mlu_home_page,51)}
      preset_value_3[4]={get_value (mlu_home_page,58),get_value (mlu_home_page,52)}
      preset_value_3[5]={get_value (mlu_home_page,59),get_value (mlu_home_page,53)}
      preset_value_3[6]={get_value (mlu_home_page,60),get_value (mlu_home_page,54)}
 	 flash_write_array(preset_value_3,preset_value_3_addr )  
	end	


end
---------------------------------------    SIX chanel config write      ------------------------------
function flash_write_array(preset_value_id,addr)
		local temp_array ={}
		temp_array[0] = preset_value_id [1][1] & 0xFF
		temp_array[1] = preset_value_id [1][2]>> 8 & 0xFF
 	    temp_array[2] = preset_value_id [1][2] & 0xFF
		temp_array[3] = preset_value_id [2][1] & 0xFF
		temp_array[4] = preset_value_id [2][2]>> 8 & 0xFF
 	    temp_array[5] = preset_value_id [2][2] & 0xFF
		temp_array[6] = preset_value_id [3][1] & 0xFF
		temp_array[7] = preset_value_id [3][2]>> 8 & 0xFF
 	    temp_array[8] = preset_value_id [3][2] & 0xFF
		temp_array[9] = preset_value_id [4][1] & 0xFF
		temp_array[10] = preset_value_id [4][2]>> 8 & 0xFF
 	    temp_array[11] = preset_value_id [4][2] & 0xFF
 		temp_array[12] = preset_value_id [5][1] & 0xFF
		temp_array[13] = preset_value_id [5][2]>> 8 & 0xFF
 	    temp_array[14] = preset_value_id [5][2] & 0xFF
		temp_array[15] = preset_value_id [6][1] & 0xFF
		temp_array[16] = preset_value_id [6][2]>> 8 & 0xFF
 	    temp_array[17] = preset_value_id [6][2] & 0xFF	
		-------------------------------------------------------------------------------------
 		flush_flash() 	
		write_flash(addr,temp_array)
end
function  get_last_used_conf()
  last_used[1]={get_value(mlu_home_page,37),get_value(mlu_home_page,12)*60+get_value(mlu_home_page,13)}
  last_used[2]={get_value(mlu_home_page,38),get_value(mlu_home_page,15)*60+get_value(mlu_home_page,16)}
  last_used[3]={get_value(mlu_home_page,39),get_value(mlu_home_page,18)*60+get_value(mlu_home_page,19)}
  last_used[4]={get_value(mlu_home_page,40),get_value(mlu_home_page,21)*60+get_value(mlu_home_page,22)}
  last_used[5]={get_value(mlu_home_page,41),get_value(mlu_home_page,24)*60+get_value(mlu_home_page,25)}
  last_used[6]={get_value(mlu_home_page,42),get_value(mlu_home_page,27)*60+get_value(mlu_home_page,28)}
  flash_write_array( last_used,last_used_addr) 
  return  last_used
end


--初始化函数
function on_init()
	 set_enable(mlu_home_page,48,0)
	 home_icon_2_proces_six(0)
	  start_timer(6,100,0,0)
	  start_timer(7,200,0,0)
	  if  get_current_screen() == self_inspection_page then
		  start_timer(8,1500,0,0)
	  end

end

--定时回调函数，系统每隔1秒钟自动调用。
--function on_systick()


--end

--定时器超时回调函数，当设置的定时器超时时，执行此回调函数，timer_id为对应的定时器ID
-------------------last used config or curr config ------------------------\----------estimate_two_array_same


function   estimate_two_array_same(array1,array2)
	local val=0
	if array1[1][1] ~= array2[1][1]  then
		val= 1
	end
	if array1[1][2] ~= array2[1][2]  then
		val= 1
	end
----------------------------------------------
 	if array1[2][1] ~= array2[2][1]  then
		val= 1
	end
	if array1[2][2] ~= array2[2][2]  then
		val= 1
	end	
----------------------------------------------------
  	if array1[3][1] ~= array2[3][1]  then
		val= 1
	end

	if array1[3][2] ~= array2[3][2]  then
		val= 1
	end		
-----------------------------------------------------
 	if array1[4][1] ~= array2[4][1]  then
		val= 1
	end
	if array1[4][2] ~= array2[4][2]  then
		val= 1
	end	
-------------------------------------------------
   if array1[5][1] ~= array2[5][1]  then
		val= 1
	end
	if array1[5][2] ~= array2[5][2]  then
		val= 1
	end	
	-------------------------------------
	 if array1[6][1] ~= array2[6][1]  then
		val= 1
	end
	if array1[6][2] ~= array2[6][2]  then
		val= 1
	end	

	-------------------------------
	return  val 
end


function last_or_curr()

	local home_icon_2 =get_value(mlu_home_page,2)
	if home_icon_2 == 1 or home_icon_2 == 0 or home_icon_2 == 2 or home_icon_2== 3 or home_icon_2 == 4 or home_icon_2 == 5 then
		chanel_1[1] = get_value(mlu_home_page,3)
		chanel_1[2] = get_value(mlu_home_page,4)   
 		chanel_1[3] = get_value(mlu_home_page,5) 
		chanel_1[5] = get_value(mlu_home_page,36) 
 		chanel_2[1] = get_value(mlu_home_page,3)   
		chanel_2[2] = get_value(mlu_home_page,4)
 		chanel_2[3] = get_value(mlu_home_page,5)	
 		chanel_2[5] = get_value(mlu_home_page,36) 	
		chanel_3[1] = get_value(mlu_home_page,3)
		chanel_3[2] = get_value(mlu_home_page,4)
 		chanel_3[3] = get_value(mlu_home_page,5)	
 		chanel_3[5] = get_value(mlu_home_page,36) 		
 		chanel_4[1] = get_value(mlu_home_page,3)
		chanel_4[2] = get_value(mlu_home_page,4)
 		chanel_4[3] = get_value(mlu_home_page,5)
 		chanel_4[5] = get_value(mlu_home_page,36) 		
		chanel_5[1] = get_value(mlu_home_page,3)
		chanel_5[2] = get_value(mlu_home_page,4)
 		chanel_5[3] = get_value(mlu_home_page,5)
 		chanel_5[5] = get_value(mlu_home_page,36) 		
		chanel_6[1] = get_value(mlu_home_page,3)
		chanel_6[2] = get_value(mlu_home_page,4)
 		chanel_6[3] = get_value(mlu_home_page,5)
		chanel_6[5] = get_value(mlu_home_page,36)	
        	set_value(mlu_home_page,12,chanel_1[1])
 			set_value(mlu_home_page,13,chanel_1[2])	
 		    set_value(mlu_home_page,14,chanel_1[3])	
			show_zero_fill(12)
 		    set_value(mlu_home_page,15,chanel_1[1])
 			set_value(mlu_home_page,16,chanel_1[2])	
 		    set_value(mlu_home_page,17,chanel_1[3])	
			show_zero_fill(15)	
 		    set_value(mlu_home_page,18,chanel_1[1])
 			set_value(mlu_home_page,19,chanel_1[2])	
 		    set_value(mlu_home_page,20,chanel_1[3])	
			show_zero_fill(18)	
 		     set_value(mlu_home_page,21,chanel_1[1])
 			set_value(mlu_home_page,22,chanel_1[2])	
 		    set_value(mlu_home_page,23,chanel_1[3])	
			show_zero_fill(21)	
 		    set_value(mlu_home_page,24,chanel_1[1])
 			set_value(mlu_home_page,25,chanel_1[2])	
 		    set_value(mlu_home_page,26,chanel_1[3])	
			show_zero_fill(24)	
 		     set_value(mlu_home_page,27,chanel_1[1])
 			set_value(mlu_home_page,28,chanel_1[2])	
 		    set_value(mlu_home_page,29,chanel_1[3])	
			show_zero_fill(27)	
 			set_value(mlu_home_page,37,chanel_1[5])
 			set_value(mlu_home_page,38,chanel_2[5])	
 		    set_value(mlu_home_page,39,chanel_3[5])
			set_value(mlu_home_page,40,chanel_4[5])
 			set_value(mlu_home_page,41,chanel_5[5])	
 		    set_value(mlu_home_page,42,chanel_6[5])		

	end
	 if home_icon_2 == 6 or home_icon_2 == 7 or home_icon_2 == 8  then
	 	
				preset_value_curr[1]={get_value (mlu_home_page,55),get_value (mlu_home_page,49)}
				preset_value_curr[2]={get_value (mlu_home_page,56),get_value (mlu_home_page,50)}
				preset_value_curr[3]={get_value (mlu_home_page,57),get_value (mlu_home_page,51)}
				preset_value_curr[4]={get_value (mlu_home_page,58),get_value (mlu_home_page,52)}
				preset_value_curr[5]={get_value (mlu_home_page,59),get_value (mlu_home_page,53)}
				preset_value_curr[6]={get_value (mlu_home_page,60),get_value (mlu_home_page,54)}	
			if  home_icon_2 == 6  then
			local  val1 = estimate_two_array_same( preset_value_curr, preset_value_1)
 						
						if val1 == 1	then
 					   set_value(0,202,val1+3)		
						change_screen(mlu_ask_page)
						--set_value(0,201,val1+3)
 							val1 = 100	
					end
			end
			if  home_icon_2 == 7  then
			local    val1	= estimate_two_array_same( preset_value_curr, preset_value_2)
						if val1 == 1	then
							change_screen(mlu_ask_page)
							val1 = 100	
				end
			end
 			if  home_icon_2 == 8  then
			 local  val1 = estimate_two_array_same( preset_value_curr, preset_value_3)
						if val1 == 1	then
						change_screen(mlu_ask_page)
 						val1 = 100		
				end
			end	
		
			---------------------------chanel_1-----------------------
 			
 			 chanel_1[1] =preset_value_curr[1][2]//60
 			 chanel_1[2] =preset_value_curr[1][2]%60 
			 chanel_1[3] = 0 
			 set_value(mlu_home_page,12,preset_value_curr[1][2]//60) 
 			set_value(mlu_home_page,13,preset_value_curr[1][2]%60)	
 		    set_value(mlu_home_page,14,0)	
 			chanel_1[5] = preset_value_curr[1][1]
			set_value(mlu_home_page,37,preset_value_curr[1][1])	
			show_zero_fill(12)
------------------------------------chanel_2-------------
 			
 			 chanel_2[1] =preset_value_curr[2][2]//60
 			 chanel_2[2] =preset_value_curr[2][2]%60 
			 chanel_2[3] = 0 
			 set_value(mlu_home_page,15,preset_value_curr[2][2]//60) 
 			set_value(mlu_home_page,16,preset_value_curr[2][2]%60)	
 		    set_value(mlu_home_page,17,0)	
 		chanel_2[5] = preset_value_curr[2][1]
			set_value(mlu_home_page,38,preset_value_curr[2][1])		
			show_zero_fill(15)
			----------------------------------chanel_3--------------------------
 		 			
 			 chanel_3[1] =preset_value_curr[3][2]//60
 			 chanel_3[2] =preset_value_curr[3][2]%60 
			 chanel_3[3] = 0 
			 set_value(mlu_home_page,18,preset_value_curr[3][2]//60) 
 			set_value(mlu_home_page,19,preset_value_curr[3][2]%60)	
 		    set_value(mlu_home_page,20,0)	
 		chanel_3[5] = preset_value_curr[3][1]
			set_value(mlu_home_page,39,preset_value_curr[3][1])		
			show_zero_fill(18)	
			--------------------------------chanel_4-----------------------------------
				 chanel_4[1] =preset_value_curr[4][2]//60
 			 chanel_4[2] =preset_value_curr[4][2]%60 
			 chanel_4[3] = 0 
			 set_value(mlu_home_page,21,preset_value_curr[4][2]//60 )                          
 			set_value(mlu_home_page,22, preset_value_curr[4][2]%60 )	                        
 		    set_value(mlu_home_page,23,0)	
 		    chanel_4[5] = preset_value_curr[4][1]
			set_value(mlu_home_page,40,preset_value_curr[4][1])		
			show_zero_fill(21)	
			----------------------------------------------------------------
 			 chanel_5[1] =preset_value_curr[5][2]//60
 			 chanel_5[2] =preset_value_curr[5][2]%60 
			 chanel_5[3] = 0 
			 set_value(mlu_home_page,24,chanel_5[1]) 
 			set_value(mlu_home_page,25, chanel_5[2])	
 		    set_value(mlu_home_page,26,0)	
 		   chanel_5[5] = preset_value_curr[5][1]
			set_value(mlu_home_page,41, chanel_5[5] )		
			show_zero_fill(24)		
			-------------------------------------------------------
 			 chanel_6[1] =preset_value_curr[6][2]//60
 			 chanel_6[2] =preset_value_curr[6][2]%60 
			 chanel_6[3] = 0 

 		   chanel_6[5] = preset_value_curr[6][1]
 		  	 set_value(mlu_home_page,27, chanel_6[1] ) 
 			set_value(mlu_home_page,28, chanel_6[2] )	
 		    set_value(mlu_home_page,29,0)	 
			set_value(mlu_home_page,42, chanel_6[5] )		
			show_zero_fill(27)		
	end


end



------------------------preset_value--------------------
function preset_value_show(control)
	if    control==43       then
		set_value(mlu_home_page,49,preset_value_1[1][2])
 	    set_value(mlu_home_page,50,preset_value_1[2][2])
 	    set_value(mlu_home_page,51,preset_value_1[3][2])
 	    set_value(mlu_home_page,52,preset_value_1[4][2])
 	    set_value(mlu_home_page,53,preset_value_1[5][2])
 	    set_value(mlu_home_page,54,preset_value_1[6][2])

		set_value(mlu_home_page,63,preset_value_1[1][2])
 	    set_value(mlu_home_page,64,preset_value_1[2][2])
 	    set_value(mlu_home_page,65,preset_value_1[3][2])
 	    set_value(mlu_home_page,66,preset_value_1[4][2])
 	    set_value(mlu_home_page,67,preset_value_1[5][2])
 	    set_value(mlu_home_page,68,preset_value_1[6][2])


 	  	set_value(mlu_home_page,55,preset_value_1[1][1])
 	    set_value(mlu_home_page,56,preset_value_1[2][1])
 	    set_value(mlu_home_page,57,preset_value_1[3][1])
 	    set_value(mlu_home_page,58,preset_value_1[4][1])	
 	    set_value(mlu_home_page,59,preset_value_1[5][1])
 	    set_value(mlu_home_page,60,preset_value_1[6][1])	  

	end
	if     control==44      then
	   	set_value(mlu_home_page,49,preset_value_2[1][2])
 	    set_value(mlu_home_page,50,preset_value_2[2][2])
 	    set_value(mlu_home_page,51,preset_value_2[3][2])
 	    set_value(mlu_home_page,52,preset_value_2[4][2])
 	    set_value(mlu_home_page,53,preset_value_2[5][2])
 	    set_value(mlu_home_page,54,preset_value_2[6][2])
		set_value(mlu_home_page,63,preset_value_2[1][2])
 	    set_value(mlu_home_page,64,preset_value_2[2][2])
 	    set_value(mlu_home_page,65,preset_value_2[3][2])
 	    set_value(mlu_home_page,66,preset_value_2[4][2])
 	    set_value(mlu_home_page,67,preset_value_2[5][2])
 	    set_value(mlu_home_page,68,preset_value_2[6][2])
 	  	set_value(mlu_home_page,55,preset_value_2[1][1])
 	    set_value(mlu_home_page,56,preset_value_2[2][1])
 	    set_value(mlu_home_page,57,preset_value_2[3][1])
 	    set_value(mlu_home_page,58,preset_value_2[4][1])	
 	    set_value(mlu_home_page,59,preset_value_2[5][1])
 	    set_value(mlu_home_page,60,preset_value_2[6][1])	 
	end
	if    control==45      then
		set_value(mlu_home_page,49,preset_value_3[1][2])
 	    set_value(mlu_home_page,50,preset_value_3[2][2])
 	    set_value(mlu_home_page,51,preset_value_3[3][2])
 	    set_value(mlu_home_page,52,preset_value_3[4][2])
 	    set_value(mlu_home_page,53,preset_value_3[5][2])
 	    set_value(mlu_home_page,54,preset_value_3[6][2])
		set_value(mlu_home_page,63,preset_value_3[1][2])
 	    set_value(mlu_home_page,64,preset_value_3[2][2])
 	    set_value(mlu_home_page,65,preset_value_3[3][2])
 	    set_value(mlu_home_page,66,preset_value_3[4][2])
 	    set_value(mlu_home_page,67,preset_value_3[5][2])
 	    set_value(mlu_home_page,68,preset_value_3[6][2])
 	  	set_value(mlu_home_page,55,preset_value_3[1][1])
 	    set_value(mlu_home_page,56,preset_value_3[2][1])
 	    set_value(mlu_home_page,57,preset_value_3[3][1])
 	    set_value(mlu_home_page,58,preset_value_3[4][1])	
 	    set_value(mlu_home_page,59,preset_value_3[5][1])
 	    set_value(mlu_home_page,60,preset_value_3[6][1])	 
	end
end



--------------------------------------------计时开启状态显示---------------------------------------------
function my_set_chanel(chanel_id,sta)
	if  (chanel_id & 0x01) == 0x01 and (sta& 0x01) == 0x01 then
		   start_timer(0,993,0,0)	 
		   set_enable(mlu_home_page,30,0) 
	end
 	if  (chanel_id & 0x02) == 0x02 and (sta& 0x02) == 0x02 then
		   start_timer(1,993,0,0) 
 		  set_enable(mlu_home_page,31,0)  
	end
	if  (chanel_id & 0x04) == 0x04 and (sta& 0x04) == 0x04 then
 		  start_timer(2,993,0,0) 
 		 set_enable(mlu_home_page,32,0)  
	end
	if  (chanel_id & 0x08) == 0x08 and (sta& 0x08) == 0x08 then
		   start_timer(3,993,0,0) 
 		  set_enable(mlu_home_page,33,0)  
	end
	if  (chanel_id & 0x10) == 0x10 and (sta& 0x10) == 0x10 then	
 		  start_timer(4,993,0,0) 
 		 set_enable(mlu_home_page,34,0)  
	end	
 	if  (chanel_id & 0x20) == 0x20 and (sta& 0x20) == 0x20 then
 		  start_timer(5,993,0,0)
		  set_enable(mlu_home_page,35,0)  
	end	
end
----------------Duty cycle display  function--------------------------
function  Duty_cycle_display()
	set_value(mlu_home_page,37,chanel_1[5]) 
	set_value(mlu_home_page,38,chanel_2[5]) 
    set_value(mlu_home_page,39,chanel_3[5]) 	
    set_value(mlu_home_page,40,chanel_4[5]) 	
	set_value(mlu_home_page,41,chanel_5[5]) 		
    set_value(mlu_home_page,42,chanel_6[5]) 		
	if get_value(mlu_home_page,2) == 0 then
		set_value(mlu_home_page,36,chanel_1[5]) 
	end
   if get_value(mlu_home_page,2) == 1 then
		set_value(mlu_home_page,36,chanel_2[5]) 
	end
	
	if get_value(mlu_home_page,2) == 2 then
		set_value(mlu_home_page,36,chanel_3[5]) 
	end
	
	if get_value(mlu_home_page,2) == 3 then
		set_value(mlu_home_page,36,chanel_4[5]) 
	end
	
	if get_value(mlu_home_page,2) == 4 then
		set_value(mlu_home_page,36,chanel_5[5]) 
	end
	
	if get_value(mlu_home_page,2) == 5 then
		set_value(mlu_home_page,36,chanel_6[5]) 
	end	
end


-----------------timer------------------------------------------------------
function myui_timer_fuc(chanel_id)
     local hour  = chanel_id[1]
		local min  = chanel_id[2]
		local sec  =chanel_id[3]

	 	if hour == 0 and  min ==0 and sec == 0 then

		elseif hour >0 and  min == 0 and sec == 0 then
			hour = hour-1
			min = 59
        	sec =59	 
			chanel_id[1]	= hour	
 			chanel_id[2]	= min	
 		    chanel_id[3]	= sec	
		elseif  min > 0 and sec == 0 then
			min = min - 1
        	sec = 59	
			chanel_id[1]	= hour	
 			chanel_id[2]	= min	
 		    chanel_id[3]	= sec			
 		   
		else
			sec = sec - 1
 	    	chanel_id[1]	= hour	
 			chanel_id[2]	= min	
 		    chanel_id[3]	= sec	
	end

	

end

----------------------------------First fill zero When it's less than 10 ---------------------------
function show_zero_fill(show_chanel_control)
    local  hours = get_text (mlu_home_page,show_chanel_control)
    local  mins= get_text (mlu_home_page,show_chanel_control+1)
    local secs = get_text (mlu_home_page,show_chanel_control+2)
	
	if string.len(get_text (mlu_home_page,show_chanel_control)) == 1 or string.len(get_text (mlu_home_page,show_chanel_control+1)) == 1  or string.len(get_text (mlu_home_page,show_chanel_control+2)) == 1then
		
		if string.len(get_text (mlu_home_page,show_chanel_control)) == 1 then  
		 set_text(mlu_home_page,show_chanel_control,"0"..hours)
		end
		if string.len(get_text (mlu_home_page,show_chanel_control+1)) == 1 then
		  set_text(mlu_home_page,show_chanel_control+1,"0"..mins)
		  end
		  if string.len(get_text (mlu_home_page,show_chanel_control+2)) == 1 then
		 set_text(mlu_home_page,show_chanel_control+2,"0"..secs)
		end 
  end
end
---------------------------------------------------------------------------------------
-----------First fill zero-----------------------------------------------------------
function show_timer()

		if (get_value(mlu_home_page,2)) == 0  then		-----------显示通道1时间及其首位补0
			set_value(mlu_home_page,3,chanel_1[1])
 			set_value(mlu_home_page,4,chanel_1[2])	
 		    set_value(mlu_home_page,5,chanel_1[3])	
			show_zero_fill(3)   
		end
		if (get_value(mlu_home_page,2)) == 1  then		-----------显示通道2时间及其首位补0
			set_value(mlu_home_page,3,chanel_2[1])
 			set_value(mlu_home_page,4,chanel_2[2])	
 		    set_value(mlu_home_page,5,chanel_2[3])	
			show_zero_fill(3)
		end
 		if (get_value(mlu_home_page,2)) == 2  then		-----------显示通道3时间及其首位补0
			set_value(mlu_home_page,3,chanel_3[1])
 			set_value(mlu_home_page,4,chanel_3[2])	
 		    set_value(mlu_home_page,5,chanel_3[3])	
			show_zero_fill(3)
		end
		if (get_value(mlu_home_page,2)) == 3  then		-----------显示通道4时间及其首位补0
			set_value(mlu_home_page,3,chanel_4[1])
 			set_value(mlu_home_page,4,chanel_4[2])	
 		    set_value(mlu_home_page,5,chanel_4[3])	
			show_zero_fill(3)
		end
		if (get_value(mlu_home_page,2)) == 4  then		-----------显示通道5时间及其首位补0
			set_value(mlu_home_page,3,chanel_5[1])
 			set_value(mlu_home_page,4,chanel_5[2])	
 		    set_value(mlu_home_page,5,chanel_5[3])	
			show_zero_fill(3)
		end
		if (get_value(mlu_home_page,2)) == 5  then		-----------显示通道6时间及其首位补0
			set_value(mlu_home_page,3,chanel_6[1])
 			set_value(mlu_home_page,4,chanel_6[2])	
 		    set_value(mlu_home_page,5,chanel_6[3])	
			show_zero_fill(3)
		end	
 	
end





-----------------------------------------------------------------------------------------------
function on_timer(timer_id)
	if  timer_id == 0 or timer_id == 1 or timer_id == 2  or timer_id == 3 or timer_id == 4 or timer_id == 5 then
		if timer_id == 0  then              ------------时间定时器
	         myui_timer_fuc(chanel_1)
 				------------下方通道1时间---------
			set_value(mlu_home_page,12,chanel_1[1])
 			set_value(mlu_home_page,13,chanel_1[2])	
 		    set_value(mlu_home_page,14,chanel_1[3])	
			show_zero_fill(12)
 			if chanel_1[1] == 0 and chanel_1[2] == 0 and chanel_1[3] == 0 then
					chanel_state =~(1 <<  (timer_id) ) & chanel_state
 					mlu_led(chanel_state,chanel_connect)		
					stop_timer (timer_id)
 				set_enable(mlu_home_page,30,1)	
 				uart_doorbuff(CMD_BOOT_DOWN ) 
								
				end	

		 end       
		if timer_id == 1  then              ------------时间定时器
				myui_timer_fuc(chanel_2)
 			------------下方通道2时间---------
			set_value(mlu_home_page,15,chanel_2[1])
 			set_value(mlu_home_page,16,chanel_2[2])	
 		    set_value(mlu_home_page,17,chanel_2[3])	
 		    show_zero_fill(15)	
 			if chanel_2[1] == 0 and chanel_2[2] == 0 and chanel_2[3] == 0  then
 					chanel_state =~(1 <<  (timer_id) ) & chanel_state
 					mlu_led(chanel_state,chanel_connect)			
					stop_timer (timer_id)
 				set_enable(mlu_home_page,31,1)	
 			uart_doorbuff(CMD_BOOT_DOWN ) 	
				end	
		end
 		if timer_id == 2  then              ------------时间定时器
				myui_timer_fuc(chanel_3)			
				 ------------下方通道3时间---------
			set_value(mlu_home_page,18,chanel_3[1])
 			set_value(mlu_home_page,19,chanel_3[2])	
 		    set_value(mlu_home_page,20,chanel_3[3])	
			show_zero_fill(18)	
			if chanel_3[1] == 0 and chanel_3[2] == 0 and chanel_3[3] == 0  then
					chanel_state =~(1 <<  (timer_id) ) & chanel_state
 					mlu_led(chanel_state,chanel_connect)	
						set_enable(mlu_home_page,32,1)
 						uart_doorbuff(CMD_BOOT_DOWN ) 		
					stop_timer (timer_id)
			
			end	
		end	
 		if timer_id == 3  then              ------------时间定时器
				 	myui_timer_fuc(chanel_4)
					------------下方通道4时间---------
			set_value(mlu_home_page,21,chanel_4[1])
 			set_value(mlu_home_page,22,chanel_4[2])	
 		    set_value(mlu_home_page,23,chanel_4[3])	
 			show_zero_fill(21)	
			if chanel_4[1] == 0 and chanel_4[2] == 0 and chanel_4[3] == 0  then
					chanel_state =~(1 <<  (timer_id) ) & chanel_state
 					mlu_led(chanel_state,chanel_connect)		
					stop_timer (timer_id)
 				set_enable(mlu_home_page,33,1)
 			uart_doorbuff(CMD_BOOT_DOWN ) 	
			end	
		 end	
 		if timer_id == 4  then              ------------时间定时器
				myui_timer_fuc(chanel_5)
				
				 ------------下方通道5时间---------
			set_value(mlu_home_page,24,chanel_5[1])
 			set_value(mlu_home_page,25,chanel_5[2])	
 		    set_value(mlu_home_page,26,chanel_5[3])		
 		  show_zero_fill(24)	
		  	if chanel_5[1] == 0 and chanel_5[2] == 0 and chanel_5[3] == 0  then
					chanel_state =~(1 <<  (timer_id) ) & chanel_state
 					mlu_led(chanel_state,chanel_connect)		
					stop_timer (timer_id)
					set_enable(mlu_home_page,34,1)
 				uart_doorbuff(CMD_BOOT_DOWN ) 	
			end		

		end 
 		if timer_id == 5  then              ------------时间定时器
				 	
					myui_timer_fuc(chanel_6)
					------------下方通道6时间---------
			set_value(mlu_home_page,27,chanel_6[1])
 			set_value(mlu_home_page,28,chanel_6[2])	
 		    set_value(mlu_home_page,29,chanel_6[3])		
 			show_zero_fill(27)		
 			if chanel_6[1] == 0 and chanel_6[2] == 0 and chanel_6[3] == 0  then
					chanel_state =~(1 <<  (timer_id) ) & chanel_state
 					mlu_led(chanel_state,chanel_connect)		
					stop_timer (timer_id)
 				set_enable(mlu_home_page,35,1)
 			uart_doorbuff(CMD_BOOT_DOWN ) 	

			end		
		end	
 		if  chanel_state == 0x00 then
			set_value(mlu_home_page,100,0)
		end
end
		if timer_id == 6  then   
 		last_used=flash_read_array(last_used_addr)
		chanel_1[1] = last_used[1][2]//60
		chanel_1[2] = last_used[1][2]%60
 		chanel_1[3] = 0
		chanel_1[5] = last_used[1][1]
 		chanel_2[1] = last_used[2][2]//60     
		chanel_2[2] = last_used[2][2]%60      
 		chanel_2[3] = 0                       
 		chanel_2[5] = last_used[2][1] 
		        
		chanel_3[1] = last_used[3][2]//60 
		chanel_3[2] = last_used[3][2]%60  
 		chanel_3[3] =  0                   
 		chanel_3[5] = last_used[3][1]  
		  
 		chanel_4[1] = last_used[4][2]//60 
		chanel_4[2] = last_used[4][2]%60  
 		chanel_4[3] = 0                   
 		chanel_4[5] = last_used[4][1]  
		   
		chanel_5[1] =last_used[5][2]//60 
		chanel_5[2] =last_used[5][2]%60  
 		chanel_5[3] =0                   
 		chanel_5[5] =last_used[5][1]   
		  
		chanel_6[1] =last_used[6][2]//60 
		chanel_6[2] =last_used[6][2]%60  
 		chanel_6[3] =0                   
		chanel_6[5] =last_used[6][1]     
		 preset_value_1 =   flash_read_array(preset_value_1_addr)
		 preset_value_2 =   flash_read_array(preset_value_2_addr)
		 preset_value_3 =   flash_read_array(preset_value_3_addr)
		 --------------------------------1-------------------------
			set_value(mlu_home_page,12,chanel_1[1]) 
 			set_value(mlu_home_page,13,chanel_1[2])	
 		    set_value(mlu_home_page,14,chanel_1[3])	 
			set_value(mlu_home_page,37,chanel_1[5])	
 			 show_zero_fill(12)		
--------------------------------2-------------------------
			set_value(mlu_home_page,15,chanel_2[1]) 
 			set_value(mlu_home_page,16,chanel_2[2])	
 		    set_value(mlu_home_page,17,chanel_2[3])	 
			set_value(mlu_home_page,38,chanel_2[5])	
 			 show_zero_fill(15)		
           --------------------------------3-------------------------
			set_value(mlu_home_page,18,chanel_3[1]) 
 			set_value(mlu_home_page,19,chanel_3[2])	
 		    set_value(mlu_home_page,20,chanel_3[3])	 
			set_value(mlu_home_page,39,chanel_3[5])	
 			show_zero_fill(18)		
			--------------------------------4-------------------------
			set_value(mlu_home_page,21,chanel_4[1]) 
 			set_value(mlu_home_page,22,chanel_4[2])	
 		    set_value(mlu_home_page,23,chanel_4[3])	 
			set_value(mlu_home_page,40,chanel_4[5])	
 			 show_zero_fill(21)		
			--------------------------------5-------------------------
			set_value(mlu_home_page,24,chanel_5[1]) 
 			set_value(mlu_home_page,25,chanel_5[2])	
 		    set_value(mlu_home_page,26,chanel_5[3])	 
			set_value(mlu_home_page,41,chanel_5[5])
			  show_zero_fill(24)			
---------------------------------------6------------------------------
		 	set_value(mlu_home_page,27,chanel_6[1]) 
 			set_value(mlu_home_page,28,chanel_6[2])	
 		    set_value(mlu_home_page,29,chanel_6[3])	 
			set_value(mlu_home_page,42,chanel_6[5])		
			  show_zero_fill(27)			
	 	stop_timer(6)
	 end	
 		  show_timer()	
		if timer_id == 7  then 
                     
					   if btn_id == 01001 then
								uart_doorbuff(CMD_BOOT_UP) 
 								uart_send_counter = uart_send_counter+1		
								if  uart_send_counter == 1	then
									uart_send_counter  = 0	
 									 btn_id = 00000	
									stop_timer( timer_id) 
								end
					   end
					   if btn_id == 01000 then---------------------------------------------------------------------------------------------
							uart_doorbuff(CMD_BOOT_DOWN ) 
							uart_send_counter = uart_send_counter+1		
							if  uart_send_counter == 1	then
									uart_send_counter  = 0
 									 btn_id = 00000	
									stop_timer( timer_id) 
								end
 							
					   end
 					 if btn_id == 10000 then
						uart_doorbuff(CMD_CONNECT)
						uart_send_counter = uart_send_counter+1	 	
						if  uart_send_counter == 1	then
									uart_send_counter  = 0
									stop_timer( timer_id) 
 									btn_id = 00000	
								end						
					   end 
 					   	 if btn_id == 00460 then
						uart_doorbuff(CMD_PRR)
						uart_send_counter = uart_send_counter+1	 
						if  uart_send_counter == 1	then
									uart_send_counter  = 0
 									btn_id = 00000		
									stop_timer( timer_id) 
 									
								end
 							
					   end  

 							
	  end	
 	 	if timer_id == 8  then   
 			--EE	B5	B0	00	63	DD	DD	DD	DD	DD	DD	DD	FF	FC	FF	FF
			uart_doorbuff(CMD_CONNECT)
	  end	 
		

end

-----------------------------------------proces&chanel change fuc ---------------------------------
function home_page_change(home_icon_2)
		home_icon_2 =get_value(mlu_home_page,2)
		if home_icon_2 ==1 or home_icon_2 == 0  or home_icon_2 == 2 or home_icon_2 == 3 or home_icon_2 == 4 or home_icon_2 == 5  then
			 home_icon_2_proces_six(0)

		end
 	if home_icon_2 ==6 or home_icon_2 == 7  or home_icon_2 == 8 then
		 home_icon_2_proces_six(6)
	end	

end

-----------------------------------------proces&chanel change fuc operation---------------------------------
function home_icon_2_proces_six(icon_value)
		if icon_value==6 then
		set_visiable(mlu_home_page,3,0)
		set_visiable(mlu_home_page,4,0)
 		set_visiable(mlu_home_page,5,0)
		set_visiable(mlu_home_page,36,0)
		set_visiable(mlu_home_page,46,0)	
 		 set_visiable(mlu_home_page,47,0)		

		set_visiable(mlu_home_page,48,1)
		set_visiable(mlu_home_page,49,1)
 		set_visiable(mlu_home_page,50,1)
		set_visiable(mlu_home_page,51,1)
		set_visiable(mlu_home_page,52,1)	
 		 set_visiable(mlu_home_page,53,1)	
 		 set_visiable(mlu_home_page,54,1)
		 set_visiable(mlu_home_page,55,1)
	 	 set_visiable(mlu_home_page,56,1)	
 		 set_visiable(mlu_home_page,57,1)	 
		 set_visiable(mlu_home_page,58,1)
		set_visiable(mlu_home_page,59,1)
		set_visiable(mlu_home_page,60,1)	
 		set_visiable(mlu_home_page,61,1)
		set_visiable(mlu_home_page,62,1)	
 	
		end
		if icon_value== 0 then
		set_visiable(mlu_home_page,3,1)
		set_visiable(mlu_home_page,4,1)
 		set_visiable(mlu_home_page,5,1)
		set_visiable(mlu_home_page,36,1)
		set_visiable(mlu_home_page,46,1)	
 		 set_visiable(mlu_home_page,47,1)		

		set_visiable(mlu_home_page,48,0)
		set_visiable(mlu_home_page,49,0)
 		set_visiable(mlu_home_page,50,0)
		set_visiable(mlu_home_page,51,0)
		set_visiable(mlu_home_page,52,0)	
 		 set_visiable(mlu_home_page,53,0)	
 		 set_visiable(mlu_home_page,54,0)
		 set_visiable(mlu_home_page,55,0)
	 	 set_visiable(mlu_home_page,56,0)	
 		 set_visiable(mlu_home_page,57,0)	 
		 set_visiable(mlu_home_page,58,0)
		set_visiable(mlu_home_page,59,0)
		set_visiable(mlu_home_page,60,0)	
 		set_visiable(mlu_home_page,61,0)
		set_visiable(mlu_home_page,62,0)	
		end

end
----------------------------------------------------3 4 5 36 同步幅值
function  unchanged_icon_six(control)
	
	local icon_2_value = get_value(mlu_home_page,2)
		if							control ~= 36						then
			if icon_2_value == 0 then
		
					chanel_1[control-2]	= get_value(mlu_home_page,control)
					chanel_1[control-2] = get_value(mlu_home_page,control)
					chanel_1[control-2] = get_value(mlu_home_page,control)
		
					set_value(mlu_home_page,12,chanel_1[1])
		 			set_value(mlu_home_page,13,chanel_1[2])	
		 		    set_value(mlu_home_page,14,chanel_1[3])	
					show_zero_fill(12)	
			end
		
			if icon_2_value == 1 then
					chanel_2[control-2]	= get_value(mlu_home_page,control)
					chanel_2[control-2] = get_value(mlu_home_page,control)
					chanel_2[control-2] = get_value(mlu_home_page,control)
		
					set_value(mlu_home_page,15,chanel_2[1])
		 			set_value(mlu_home_page,16,chanel_2[2])	
		 		    set_value(mlu_home_page,17,chanel_2[3])	
					show_zero_fill(15)	
		
			end
			
			if icon_2_value == 2 then
					chanel_3[control-2]	= get_value(mlu_home_page,control)
					chanel_3[control-2] = get_value(mlu_home_page,control)
					chanel_3[control-2] = get_value(mlu_home_page,control)
		
					set_value(mlu_home_page,18,chanel_3[1])
		 			set_value(mlu_home_page,19,chanel_3[2])	
		 		    set_value(mlu_home_page,20,chanel_3[3])	
					show_zero_fill(18)
		
			end	
			if icon_2_value == 3 then
					chanel_4[control-2]	= get_value(mlu_home_page,control)
					chanel_4[control-2] = get_value(mlu_home_page,control)
					chanel_4[control-2] = get_value(mlu_home_page,control)
		
					set_value(mlu_home_page,21,chanel_4[1])
		 			set_value(mlu_home_page,22,chanel_4[2])	
		 		    set_value(mlu_home_page,23,chanel_4[3])	
					show_zero_fill(21)
		
			end		
			if icon_2_value == 4 then
					chanel_5[control-2]	= get_value(mlu_home_page,control)
					chanel_5[control-2] = get_value(mlu_home_page,control)
					chanel_5[control-2] = get_value(mlu_home_page,control)
		
					set_value(mlu_home_page,24,chanel_5[1])
		 			set_value(mlu_home_page,25,chanel_5[2])	
		 		    set_value(mlu_home_page,26,chanel_5[3])	
					show_zero_fill(24)
		
			end			
		 	if icon_2_value == 5 then
					chanel_6[control-2]	= get_value(mlu_home_page,control)
					chanel_6[control-2] = get_value(mlu_home_page,control)
					chanel_6[control-2] = get_value(mlu_home_page,control)
		
					set_value(mlu_home_page,27,chanel_6[1])
		 			set_value(mlu_home_page,28,chanel_6[2])	
		 		    set_value(mlu_home_page,29,chanel_6[3])	
					show_zero_fill(27)
		
			end		
		else
				if icon_2_value == 0 then
		
					chanel_1[5]	= get_value(mlu_home_page,control)
					set_value(mlu_home_page,37,chanel_1[5])
				
			end
			if icon_2_value == 1 then
				   chanel_2[5]	= get_value(mlu_home_page,control)
					set_value(mlu_home_page,38,chanel_2[5])
		
			end
			
			if icon_2_value == 2 then
					   chanel_3[5]	= get_value(mlu_home_page,control)
					   set_value(mlu_home_page,39,chanel_3[5])
		
			end	
			if icon_2_value == 3 then
					   chanel_4[5]	= get_value(mlu_home_page,control)
					set_value(mlu_home_page,40,chanel_4[5])
		
			end		
			if icon_2_value == 4 then
					   chanel_5[5]	= get_value(mlu_home_page,control)
					set_value(mlu_home_page,41,chanel_5[5])
		
			end			
		 	if icon_2_value == 5 then
					   chanel_6[5]	= get_value(mlu_home_page,control)
					set_value(mlu_home_page,42,chanel_6[5])
			end		
		end
 end

function mlu_led(sta,link)

	if (link & 0x01) == 0x00 then
		set_value(mlu_home_page,6,0)
		set_enable(mlu_home_page,30,0)
		
	end
	if (link & 0x01) == 0x01 then
		set_enable(mlu_home_page,30,1)
		 if  (sta & 0x01) == 0 then
 			set_value(mlu_home_page,6,1)
			else 	
 			set_value(mlu_home_page,6,2)	
		end
	end
----------------------------------------
 	if (link & 0x02) == 0x00 then
		set_value(mlu_home_page,7,0)
 		set_enable(mlu_home_page,31,0)	
	end
	if (link & 0x02) == 0x02 then
		set_enable(mlu_home_page,31,1)		
		 if  (sta & 0x02) == 0 then
 			set_value(mlu_home_page,7,1)
			else 	
 			set_value(mlu_home_page,7,2)	
		end
	end	

	------------------------------------------------
  	if (link & 0x04) == 0x00 then
		set_value(mlu_home_page,8,0)
 	set_enable(mlu_home_page,32,0)		
	end
	if (link & 0x04) == 0x04 then
		set_enable(mlu_home_page,32,1)		
		 if  (sta & 0x04) == 0 then
 			set_value(mlu_home_page,8,1)
			else 	
 			set_value(mlu_home_page,8,2)	
		end
	end	
	--------------------------------------------	
   	if (link & 0x08) == 0x00 then
		set_value(mlu_home_page,9,0)
 	set_enable(mlu_home_page,33,0)		
	end
	if (link & 0x08) == 0x08 then
	set_enable(mlu_home_page,33,1)		
		 if  (sta & 0x08) == 0 then
 			set_value(mlu_home_page,9,1)
			else 	
 			set_value(mlu_home_page,9,2)	
		end
	end	
	--------------------------------------------
	  	if (link & 0x10) == 0x00 then
		set_value(mlu_home_page,10,0)
 		set_enable(mlu_home_page,34,0)		
	end
	if (link & 0x10) == 0x10 then
		set_enable(mlu_home_page,34,1)		
		 if  (sta & 0x10) == 0 then
 			set_value(mlu_home_page,10,1)
			else 	
 			set_value(mlu_home_page,10,2)	
		end
	end	
	--------------------------------------------	
	  	if (link & 0x20) == 0x00 then
		set_value(mlu_home_page,11,0)
 		set_enable(mlu_home_page,35,0)		
	end
	if (link & 0x20) == 0x20 then
		set_enable(mlu_home_page,35,1)		
		 if  (sta & 0x20) == 0 then
 			set_value(mlu_home_page,11,1)
			else 	
 			set_value(mlu_home_page,11,2)	
		end
	end	
	--------------------------------------------
end

function on_control_notify(screen,control,value)
	----------------------------------------mlu_home_page-------------------------------------------------------------
	if screen == mlu_home_page then
			if control == 3  or control == 4  or control == 5  or control == 36 then				
						unchanged_icon_six(control)
			end			
 		if control ==46 then				
					btn_id = 00460	
					start_timer(7,200,0,0)
			end			
 		   if control == 30 or control == 31 or control == 32 or control == 33 or control == 34 or control == 35 then       ----------------chanel btn
				 set_value(mlu_home_page,2,control-30)
 				 set_value(mlu_home_page,44,0)
 				 set_value(mlu_home_page,45,0)	
				 set_value(mlu_home_page,43,0)	
 				 home_icon_2_proces_six(0) 
				 if value ==1	then
					chanel_state = value <<  (control - 30) | chanel_state
 				
					
				end
 				 if value == 0	then
					chanel_state =~(1 <<  (control - 30) ) & chanel_state
 				
				end	
				 mlu_led(chanel_state,chanel_connect)
 				
				set_value(0,200,chanel_state)
 			set_value(0,201,chanel_connect)	
			end		

			
				
			if control == 56 or control == 57 or control == 58 or control == 59 or control == 60 or control ==55 or 
			control == 49 or control == 50 or control == 51 or control == 52 or control == 53 or control ==54 then    
				if control == 56   or control == 49  then 
				preset_value_curr[1]={get_value (mlu_home_page,55),get_value (mlu_home_page,49)}
				elseif control == 50   or control == 57  then 	
				preset_value_curr[2]={get_value (mlu_home_page,56),get_value (mlu_home_page,50)}
 			    elseif control == 51  or control == 58  then 	
				preset_value_curr[3]={get_value (mlu_home_page,57),get_value (mlu_home_page,51)}
 				elseif control == 52  or control == 59  then 	
				preset_value_curr[4]={get_value (mlu_home_page,58),get_value (mlu_home_page,52)}
 				elseif control == 53  or control == 60  then 	
				preset_value_curr[5]={get_value (mlu_home_page,59),get_value (mlu_home_page,53)}
 				elseif control == 54  or control == 61  then 	
				preset_value_curr[6]={get_value (mlu_home_page,60),get_value (mlu_home_page,54)}	
				end		
			end	
			if control == 43 or control == 44  or control == 45 then
					set_value(mlu_home_page,2,control-37)
					if control ~=43 then
					set_value(mlu_home_page,43,0)
					end
 			 		if control ~=44 then
					set_value(mlu_home_page,44,0)
					end
					if control ~=45 then
					set_value(mlu_home_page,45,0)
					end	
 					
 				   preset_value_show(control)	
 				    home_icon_2_proces_six(6)	 
			
			  end		

 			  if control ==	61 then
				 save_conf_chanel()		
			  end		 
 			   if control ==	100  then   ---------------------start
 					if value ==1 then
					my_set_chanel(chanel_connect,chanel_state)
 					 last_used  =  get_last_used_conf() 	
					flash_write_array(last_used,last_used_addr)
						set_enable(mlu_home_page,30,0)
 						set_enable(mlu_home_page,31,0)
						set_enable(mlu_home_page,32,0)
						set_enable(mlu_home_page,33,0)
						set_enable(mlu_home_page,34,0)
						set_enable(mlu_home_page,35,0)
						set_enable(mlu_home_page,36,0)	
						btn_id = 01001	
 						start_timer(7,200,0,0)
						

					end
 				 	if value ==0 then
 						btn_id = 01000	
						 mlu_led(0,chanel_connect)
 				
						 start_timer(7,200,0,0)
						 if (chanel_state&0x01) == 0x01 then
							stop_timer(0)
						 end
 						 if (chanel_state&0x02) == 0x02 then
							stop_timer(1)
						 end 
 						 if (chanel_state&0x04) == 0x04 then
							stop_timer(2)
						 end  
 						 if (chanel_state&0x08) == 0x08 then
							stop_timer(3)
						 end   
 						 if (chanel_state&0x10) == 0x10 then
							stop_timer(4)
						 end  
					    if (chanel_state&0x20) == 0x20 then
							stop_timer(5)
 							
						 end 
 							chanel_state = 0 	 
					end	
  
			  end		
			     if control ==	101 then           ------------------------  One-key 
					last_or_curr()
 				-- start_timer(7,1000,0,0)
				--stop_timer(8)
			  end	 
			  		
 				  if control ==	2 then
					last_or_curr()
 				-- start_timer(8,1000,0,0)
				-- stop_timer(7)
			  end	 	
	end
-----------------------------------------------
		if screen == mlu_ask_page then

			if  control  ==  1  then
				if get_value(mlu_home_page,2) == 6 then

					flash_write_array(preset_value_curr,preset_value_1_addr)
				end
 					if get_value(mlu_home_page,2) == 7 then 

					flash_write_array(preset_value_curr,preset_value_2_addr)
				end	
 			 	if get_value(mlu_home_page,2) == 8	then

					flash_write_array(preset_value_curr,preset_value_3_addr)
				end		
 				change_screen(mlu_home_page)	
			end

 			if  control  ==  2  then

				change_screen(mlu_home_page)
			end	


		end
 		
		if screen == 2 then
				if  control  ==  1  then
					local val_1	=estimate_two_array_same(preset_value_1 ,last_used)
					set_value(2,203,val_1)
				end

				if  control  ==  2  then
		   local val_1	=	estimate_two_array_same(preset_value_3,last_used)
 				set_value(2,203,val_1) 
 			end

		end
return 1
		
end

--当画面切换时，执行此回调函数，screen为目标画面。
--function on_screen_change(screen)
--end



function on_uart_recv_data(packet)					----接受数据
 local recv_packet_size = (#(packet))
 local cmd_length=0
 local door_buff={}
	for i = 0, recv_packet_size 
	do
			door_buff[i] = packet[i]
			cmd_length = cmd_length + 1
		if cmd_length==recv_packet_size then 
			cmd_length=0
		end
	end 
 	if door_buff[2]==0xA1 then
		-------------------通道接通指令------------------


		chanel_connect  = door_buff[4]
		change_screen(mlu_home_page)
 		--_btn_chanel_endble(chanel_connect)	
		mlu_led(chanel_state,chanel_connect)
		stop_timer(8)


	end		
		
 	if door_buff[2]==0xA4 then
		-----------------温度
 	  temp_chanel[1] =  string.format('%X',door_buff[3])..'.'..string.format('%X',door_buff[4]>>4)
 	  temp_chanel[2] =  string.format('%X',((door_buff[4]&0x0F) <<4)|(door_buff[5]>>4))..'.'..string.format('%X',door_buff[5]&0x0F)
 	  temp_chanel[3] =   string.format('%X',door_buff[6])..'.'..string.format('%X',door_buff[7]>>4)                                 
 	  temp_chanel[4] =   string.format('%X',((door_buff[7]&0x0F) <<4)|(door_buff[8]>>4))..'.'..string.format('%X',door_buff[8]&0x0F)
 	  temp_chanel[5] =   string.format('%X',door_buff[9])..'.'..string.format('%X',door_buff[10]>>4)                                 
 	  temp_chanel[6] =   string.format('%X',((door_buff[10]&0x0F) <<4)|(door_buff[11]>>4))..'.'..string.format('%X',door_buff[11]&0x0F)
	end	
	if door_buff[2]==0xA5 then -------------------频率
		freq_chanel[1] = (door_buff[3]<<4) | (door_buff[4] >> 4)
 		freq_chanel[2] = ((door_buff[4]&0x0F)<<8) | (door_buff[5])	
 		freq_chanel[3] = (door_buff[6]<<4) | (door_buff[7] >> 4)
 		freq_chanel[4] = ((door_buff[7]&0x0F)<<8) | (door_buff[8])	
		freq_chanel[5] = (door_buff[9]<<4) | (door_buff[10] >> 4)
 		freq_chanel[6] = ((door_buff[10]&0x0F)<<8) | (door_buff[11])		
	end	
 	if door_buff[2]==0xA6 then
		-----------------SN
	end		
	------------------接收的指令
 		set_text(mlu_home_page,210,string.format('%X',door_buff[0])..'  '..string.format('%X',door_buff[1])..'  '..string.format('%X',door_buff[2])..'  '..string.format('%X',door_buff[3])..'  '..string.format('%X',door_buff[4])..'  '..string.format('%X',door_buff[5])..'  '..string.format('%X',door_buff[6])..'  '..string.format('%X',door_buff[7])..'  '..string.format('%X',door_buff[8])..'  '..string.format('%X',door_buff[9])
	..'  '..string.format('%X',door_buff[10])..'  '..string.format('%X',door_buff[11])..'  '..string.format('%X',door_buff[12])..'  '..string.format('%X',door_buff[13])..'  '..string.format('%X',door_buff[14])..'  '..string.format('%X',door_buff[15]))

end

--function on_press(state,x,y)
	--if state == 1 then
	
--
--end
function uart_doorbuff(cmd)
	---CMD_BOOT_UP = 0xB2  start
   ---CMD_CONNECT = 0xB0  cunnect ask
	--CMD_BOOT_DOWN = 0xB3  stop
	--CMD_PRR = 0xB7 脉冲重复频率

    local door_buff = {} 
	if cmd == CMD_BOOT_UP then
		door_buff = boot_up(1)
	end   
	if cmd == CMD_BOOT_DOWN then
		door_buff = boot_up(0)
	end   	
	if cmd == CMD_CONNECT then
		_ask_chanel_cmd()
	end 
 	if cmd == CMD_PRR then
	door_buff=set_prr(get_value(0,46)%3)
	end 	
	
end

function boot_up(val)
----------------***  开机 ***---------------------
    local door_buff = {}    
    door_buff[0] = 0xEE
    door_buff[1] = 0xB5
    door_buff[2] = 0xB2
    door_buff[3] = 0xDD
    door_buff[4] = chanel_state 
    door_buff[5] =  get_value(mlu_home_page,37)&0xff
    door_buff[6] =  get_value(mlu_home_page,38)&0xff
    door_buff[7] =  get_value(mlu_home_page,39)&0xff
    door_buff[8] =  get_value(mlu_home_page,40)&0xff
    door_buff[9] =  get_value(mlu_home_page,41)&0xff
    door_buff[10] =get_value(mlu_home_page,42)&0xff
    door_buff[11] =  0xDD
	door_buff[12] =  0xFF
    door_buff[13] =  0xFC
    door_buff[14] =  0xFF
    door_buff[15] =  0xFF
	
	

	if val==1 then
		door_buff[2] =0xB2
	end
	
	if val==0 then
		door_buff[2] = 0xB3
	end
	
	set_text(mlu_home_page,211,string.format('%X',door_buff[0])..'  '..string.format('%X',door_buff[1])..'  '..string.format('%X',door_buff[2])..'  '..string.format('%X',door_buff[3])..'  '..string.format('%X',door_buff[4])..'  '..string.format('%X',door_buff[5])..'  '..string.format('%X',door_buff[6])..'  '..string.format('%X',door_buff[7])..'  '..string.format('%X',door_buff[8])..'  '..string.format('%X',door_buff[9])
	..'  '..string.format('%X',door_buff[10])..'  '..string.format('%X',door_buff[11])..'  '..string.format('%X',door_buff[12])..'  '..string.format('%X',door_buff[13])..'  '..string.format('%X',door_buff[14])..'  '..string.format('%X',door_buff[15]))
    uart_send_data(door_buff)
	return door_buff 
end

function set_prr(val)
----------------***  开机 ***---------------------
    local door_buff = {}    
    door_buff[0] = 0xEE
    door_buff[1] = 0xB5
    door_buff[2] = 0xB7
    door_buff[3] = 0xDD
    door_buff[4] = val & 0xFF
    door_buff[5] = 0xDD
    door_buff[6] = 0xDD
    door_buff[7] = 0xDD
    door_buff[8] = 0xDD
    door_buff[9] =  0xDD
    door_buff[10] =0xDD
    door_buff[11] =0xDD
	door_buff[12] = 0xFF
    door_buff[13] = 0xFC
    door_buff[14] = 0xFF
    door_buff[15] = 0xFF
 
	set_text(mlu_home_page,211,string.format('%X',door_buff[0])..'  '..string.format('%X',door_buff[1])..'  '..string.format('%X',door_buff[2])..'  '..string.format('%X',door_buff[3])..'  '..string.format('%X',door_buff[4])..'  '..string.format('%X',door_buff[5])..'  '..string.format('%X',door_buff[6])..'  '..string.format('%X',door_buff[7])..'  '..string.format('%X',door_buff[8])..'  '..string.format('%X',door_buff[9])
	..'  '..string.format('%X',door_buff[10])..'  '..string.format('%X',door_buff[11])..'  '..string.format('%X',door_buff[12])..'  '..string.format('%X',door_buff[13])..'  '..string.format('%X',door_buff[14])..'  '..string.format('%X',door_buff[15]))
    uart_send_data(door_buff)	
	return door_buff
end

function _uart_temp(buff)
	temp_array[1] = buff[3]+(buff[4]>>4)/10




end


function _ask_chanel_cmd()
	local door_buff = {}    
    door_buff[0] = 0xEE
    door_buff[1] = 0xB5
    door_buff[2] = 0xB0
    door_buff[3] = 0x00
    door_buff[4] = 0x63
    door_buff[5] = 0xDD
    door_buff[6] = 0xDD
    door_buff[7] = 0xDD
    door_buff[8] = 0xDD
    door_buff[9] =  0xDD
    door_buff[10] =0xDD
    door_buff[11] =0xDD
	door_buff[12] = 0xFF
    door_buff[13] = 0xFC
    door_buff[14] = 0xFF
    door_buff[15] = 0xFF

 uart_send_data(door_buff)	

end





