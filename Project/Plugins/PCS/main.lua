mqtt = MQTTAPI()
daq = DAQAPI()
JSON = require("modules/JSON")

-- Used to check if the value has changed
-- di0 = nil
-- do1 = nil
-- do2 = nil
-- do3 = nil
-- do4 = nil
-- do5 = nil
-- do6 = nil
-- do7 = nil

local ems_prompt = "/AEGIS/rA"
local pcs_prompt = "/AEGIS/rPCS"
local startTime = os.time()

local raid = "/RA000001"
local rpcsid = "/PCS67890"
local prop = "/report"
local con = "/control"
local prefix = pcs_prompt .. rpcsid .. prop
local control = pcs_prompt .. rpcsid .. con

local prefixEMS = ems_prompt .. raid .. con

local root = {}
local controls = {}
local errors = {}

-- local date_list = {}
-- local today = os.date("*t")
-- date_list.day = today.day
-- date_list.month = today.month
-- date_list.year = today.year

-- local function is_today()
-- 	if not date_list.day then
-- 		return false
-- 	end
-- 	local timestamp = os.time()
-- 	local sToday = os.time({day = date_list.day, month = date_list.month, year = date_list.year, hour = 0, min = 0, sec = 0 })
-- 	if timestamp > sToday and timestamp <= sToday + 24 * 60 * 60 then
-- 		return true
-- 	else
-- 		return false
-- 	end
-- end

function on_report(context)
	local value = nil
	
	-- local root = {}
	-- local controls = {}
	-- local errors = {}

	root["PCS_ID"] = "PCS67890"
    root["Timestamp"] = "2024-02-06T10:00:00Z"
    -- root["Status"] = "Active"
    root["Power_Output"] = "500"
    root["Power_Input"] = "480"
    root["Efficiency"] = "96"
    root["Operating_Mode"] = "Grid-Tied"
    root["Battery_Voltage"] = "48"
    root["External_Battery_Temperature"] = "25"
    root["AC_Input_Active_Power_R"] = "460"
    root["AC_Output_Voltage_R"] = "230"
    root["AC_Output_Active_Power_R"] = "500"
    root["AC_Output_Frequency"] = "50"
    root["AC_Output_Current_R"] = "2.17"
    root["Battery_Capacity"] = "10000"
    root["Solar_Input_Power_1"] = "1500"
    root["Battery_Current"] = "100"
    root["Solar_Input_Voltage_1"] = "150"
    root["Component_Max_Temperature"] = "40"
    root["AC_Input_Total_Active_Power"] = "460"
    root["AC_Input_Current_R"] = "2"
    root["Solar_Input_Current_1"] = "6.5"
    root["AC_Output_Apparent_Power_R"] = "520"
    root["AC_Input_Voltage_R"] = "220"
    root["AC_Input_Frequency"] = "50"
    root["AC_Output_Power_Percentage"] = "90"
    root["Inner_Temperature"] = "30"
    root["AC_Output_Total_Power"] = "500"
    root["Battery_Power"] = "480"
    root["Total_Generated_Energy"] = "10000"
    root["Generated_Energy_Of_Hour"] = "500"
    root["Generated_Energy_Of_Day"] = "120"
    root["Generated_Energy_Of_Month"] = "3000"
    root["Generated_Energy_Of_Year"] = "12000"
    root["First_Generated_Energy_Saved_Time"] = "2024-02-06T00:00:00Z"
    root["The_Date_Of_The_Hourly_Energy"] = "2024-02-06T10:00:00Z"
    root["The_Date_Of_The_Daily_Energy"] = "2024-02-06"
    root["The_Date_Of_The_Monthly_Energy"] = "2024-02"
    root["The_Date_Of_The_Yearly_Energy"] = "2024"
	
	controls["Generator_as_AC_Input"] =  "true"
	controls["Wide_AC_Input_Range"] = "true"
	controls["Charge_Battery"] = "true"
	controls["AC_Charge_Battery"] = "true"
	controls["Feed_Power_To_Utility"] = "true"
	controls["Battery_Discharge_To_Loads_When_Solar_Input_Normal"] = "true"
	controls["Battery_Discharge_To_Loads_When_Solar_Input_Loss"] = "true"
	controls["Battery_Discharge_To_Feed_Power_To_Utility_When_Solar_Input_Normal"] = "true"
	controls["Battery_Discharge_To_Feed_Power_To_Utility_When_Solar_Input_Loss"] = "true"
	controls["Auto_Adjust_PF_According_To_Feed_Power"] = "true"
	controls["Machine_Supply_Power_To_The_Loads"] = "true"
	controls["Charger_Keep_Battery_Voltage_Function"] = "true"
	root["Controls"] = controls

	errors["AC_Input_Over_Voltage"] = "false"
	errors["AC_Input_Under_Voltage"] = "false"
	errors["Battery_Over_Temperature"] = "false"
	errors["Battery_Under_Temperature"] = "false"
	errors["Battery_Over_Voltage"] = "false"
	errors["Battery_Under_Voltage"] = "false"
	-- errors["Over_Load"] = "false"
	errors["Short_Circuit"] = "false"
	root["Errors"] = errors
	
	if ((context.information.DeviceID == "advanioPcs403") and 
		(context.information.Connected == true)) then

		value = context.parameters["do0"].value
		root["Status"] = value

	end

	if ((context.information.DeviceID == "advanioPcs501") and 
		(context.information.Connected == true)) then

		value = context.parameters["di0"].value
		errors["Over_Load"] = value
		daq:Write("advanioPcs501", "do0", value)
		if(value == 0) then
			daq:Write("advanioPcs403", "do0", value)
		end
	end

	local root_text = JSON:encode(root)
	mqtt:Publish("dy_emqx", prefix, root_text, 2, false)
end

function on_message(context)
	local topic = context.topic
	local value = tonumber(context.payload)
 
	print("topic=" .. context.topic)
	print("value=" .. context.payload)

  	--if (value == nil) then
   		--value is not a number
    --	return;
  	--end
  
	if (topic == control) then
		if (value == 1) then
			daq:Write("advanioPcs403", "do0", value)
			-- mqtt:Publish("dy_emqx", prefixEMS, 1, 2, false)
		elseif (value == 0) then
			daq:Write("advanioPcs403", "do0", value)
			-- mqtt:Publish("dy_emqx", prefixEMS, 0, 2, false)
		end	
	end
end

daq:OnReport(on_report)

--Register Receive Message event
mqtt:OnMessage(on_message);

--Subscribe topic
mqtt:Subscribe("dy_emqx", control, 2);
