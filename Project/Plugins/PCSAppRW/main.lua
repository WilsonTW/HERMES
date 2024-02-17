mqtt = MQTTAPI()
daq = DAQAPI()
JSON = require("modules/JSON")

-- Used to check if the value has changed
do0 = nil
do1 = nil
do2 = nil
do3 = nil
do4 = nil
do5 = nil
do6 = nil
do7 = nil

local ems_prompt = "/AEGIS/RA/"
local startTime = os.time()

local date_list = {}
local today = os.date("*t")
date_list.day = today.day
date_list.month = today.month
date_list.year = today.year

local function is_today()
	if not date_list.day then
		return false
	end
	local timestamp = os.time()
	local sToday = os.time({day = date_list.day, month = date_list.month, year = date_list.year, hour = 0, min = 0, sec = 0 })
	if timestamp > sToday and timestamp <= sToday + 24 * 60 * 60 then
		return true
	else
		return false
	end
end

function on_report(context)
	local value = nil
	local endTime = nil
	local pcs= {}
	local bits
	local prefix = ems_prompt

	if ((context.information.DeviceID == "advanioPcs403") and 
		(context.information.Connected == true)) then

		if (context.information.DeviceID == "advanioPcs403") then
			prefix = ems_prompt .. "1/"
		end

		value = context.parameters["do0"].value
		pcs["do0"] = value

		value = context.parameters["do1"].value
		pcs["do1"] = value

		value = context.parameters["do2"].value
		pcs["do2"] = value

		value = context.parameters["do3"].value
		pcs["do3"] = value

		value = context.parameters["do4"].value
		pcs["do4"] = value

		value = context.parameters["do5"].value
		pcs["do5"] = value

		value = context.parameters["do6"].value
		pcs["do6"] = value

		value = context.parameters["do7"].value
		pcs["do7"] = value

		local pcs_text = JSON:encode(pcs)
		mqtt:Publish("aws_emqx", prefix .. "report", pcs_text, 2, false)

	end
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
  
	if (topic == ems_prompt .. "1/do0/w") then
		if (value == 1) then
			daq:Write("advanioPcs403", "do0", value)
		elseif (value == 0) then
			daq:Write("advanioPcs403", "do0", value)
		end	
	elseif (topic == ems_prompt .. "1/do1/w") then
		if (value == 1) then
			daq:Write("advanioPcs403", "do1", value)
		elseif (value == 0) then
			daq:Write("advanioPcs403", "do1", value)
		end	
	end
end

daq:OnReport(on_report)

--Register Receive Message event
mqtt:OnMessage(on_message);

--Subscribe topic
mqtt:Subscribe("aws_emqx", ems_prompt .. "1/do0/w", 2);
mqtt:Subscribe("aws_emqx", ems_prompt .. "1/do1/w", 2);
