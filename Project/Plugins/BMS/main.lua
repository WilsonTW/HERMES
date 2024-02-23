mqtt = MQTTAPI()
daq = DAQAPI()
JSON = require("modules/JSON")

-- Used to check if the value has changed
-- do0 = nil
-- do1 = nil
-- do2 = nil
-- do3 = nil
-- do4 = nil
-- do5 = nil
-- do6 = nil
-- do7 = nil

local ems_prompt = "/AEGIS/rA"
local bms_prompt = "/AEGIS/rBMS"
local startTime = os.time()

local raid = "/RA000001"
local rbmsid = "/BMS54321"
local prop = "/report"
local con = "/control"
local prefix = bms_prompt .. rbmsid .. prop
local control = bms_prompt .. rbmsid .. con

local prefixEMS = ems_prompt .. raid .. con

local root = {}
local controls = {}
local errors = {}

local cell1 = {}
local cell2 = {}
local cellGroup = {}

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
	root["BMS_ID"] = "BMS54321"
    root["Timestamp"] = "2024-02-06T10:00:00Z"
    root["Status"] = "Charging"
    root["Battery_Capacity"] = "10000"
    root["Current_Charge"] = "7500"
    root["State_of_Charge"] = "75"
    root["Health_Status"] = "98"
    root["Pack_Current"] = "100"
    root["Pack_Total_Voltage"] = "400"
    root["Pack_Remaining_Capacity"] = "5000"
    root["Pack_Total_Capacity"] = "10000"
    root["Battery_Cycle"] = "500"
    root["Humidity"] = "60"

	cell1["Cell_ID"] = "Cell001"
	cell1["Voltage"] = "3.7"
	-- cell1["Temperature"] = "25"

	cell2["Cell_ID"] = "Cell002"
	cell2["Voltage"] = "3.6"
	cell2["Temperature"] = "26"
	
	cellGroup = {cell1, cell2}
	root["Cells"] = cellGroup

	if ((context.information.DeviceID == "advanioPcs103") and 
		(context.information.Connected == true)) then

		value = context.parameters["temp"].value
		cell1["Temperature"] = value

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
  
	-- if (topic == control) then
	-- 	if (value == 1) then
	-- 		daq:Write("advanioPcs403", "do0", value)
	-- 	elseif (value == 0) then
	-- 		daq:Write("advanioPcs403", "do0", value)
	-- 	end	
	-- end
end

daq:OnReport(on_report)

--Register Receive Message event
mqtt:OnMessage(on_message);

--Subscribe topic
-- mqtt:Subscribe("dy_emqx", control, 2);
