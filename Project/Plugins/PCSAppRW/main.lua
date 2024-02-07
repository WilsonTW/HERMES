mqtt = MQTTAPI()
daq = DAQAPI()
JSON = require("modules/JSON")

-- Used to check if the value has changed
error0 = nil
error1 = nil
wMode = nil
bV = nil
bT = nil
acInAcP = nil
acOutV = nil
acOutAcP = nil
acOutF = nil
acOutC = nil
bCap = nil
sInP1 = nil
bC = nil
sInV1 = nil
maxT = nil
acInToAcP = nil
acInC = nil
sInC1 = nil
acOutAppPP = nil
acInV = nil
acInF = nil
acOutPP = nil
innT = nil
status0 = nil
status1 = nil
acOutToP = nil
bP = nil
totGenE = nil
genEnH = nil
genEnD = nil
genEnM = nil
genEnY = nil
saveT = nil
dateHourE = nil
dateDayE = nil
dateMonE = nil
dateYearE = nil
con1 = nil
con2 = nil
con3 = nil
con4 = nil
greenPer = nil
dayCount = 0
sliceGreenE = 0
sliceGreyE = 0
calAcInP = nil
endTime = nil
acOutAcTmpP = 0
sumGreenE = 0
sumGreyE = 0
lastGreenE = 0
lastGreyE = 0
acOutAcRetP = 0

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

	if ((context.information.DeviceID == "advanioPcs403" or context.information.DeviceID == "advanioPcs501") and 
		(context.information.Connected == true)) then

		if (context.information.DeviceID == "advanioPcs403") then
			prefix = ems_prompt .. "1/"
		elseif (context.information.DeviceID == "advanioPcs501") then
			prefix = ems_prompt .. "2/"
		end
		
		value = context.parameters["error0"].value
		for i = 0, 15, 1 do
			pcs["err0_b" .. tostring(i)] = (value >> i) & 0x01;
		end

		value = context.parameters["error1"].value
		for i = 0, 15, 1 do
			pcs["err1_b" .. tostring(i)] = (value >> i) & 0x01;
		end

		value = context.parameters["wMode"].value
		if (value == 0) then
			pcs["wMode"] = "Power On"
		elseif (value == 1) then
			pcs["wMode"] = "Standby"
		elseif (value == 2) then
			pcs["wMode"] = "Bypass"
		elseif (value == 3) then
			pcs["wMode"] = "Battery"
		elseif (value == 4) then
			pcs["wMode"] = "Fault"
		elseif (value == 5) then
			pcs["wMode"] = "Hybrid"
		elseif (value == 6) then
			pcs["wMode"] = "Charge"
		else
			pcs["wMode"] = "Unknown"
		end

		value = context.parameters["bV"].value * 0.1
		pcs["bV"] = value

		value = context.parameters["bT"].value
		pcs["bT"] = value

		value = context.parameters["acOutV"].value * 0.1
		pcs["acOutV"] = value		

		value = context.parameters["acOutAcP"].value
		pcs["acOutAcP"] = value		

		value = context.parameters["acOutF"].value * 0.01
		pcs["acOutF"] = value		

		value = context.parameters["acOutC"].value * 0.1
		pcs["acOutC"] = value		

		value = context.parameters["bCap"].value
		pcs["bCap"] = value		

		value = context.parameters["sInP1"].value
		pcs["sInP1"] = value		

		value = context.parameters["bC"].value * 0.1
		pcs["bC"] = value		

		value = context.parameters["sInV1"].value * 0.1
		pcs["sInV1"] = value		

		value = context.parameters["maxT"].value
		pcs["maxT"] = value		

		value = context.parameters["acInC"].value * 0.1
		pcs["acInC"] = value		

		value = context.parameters["sInC1"].value * 0.01
		pcs["sInC1"] = value		

		value = context.parameters["acOutAppP"].value
		pcs["acOutAppP"] = value		

		value = context.parameters["acInV"].value * 0.1
		pcs["acInV"] = value		

		value = context.parameters["acInF"].value * 0.01
		pcs["acInF"] = value		

		value = context.parameters["acOutPP"].value
		pcs["acOutPP"] = value		

		value = context.parameters["innT"].value
		pcs["innT"] = value		

		value = context.parameters["status0"].value
		pcs["status0"] = value		

		bits = (value & 0x0F00) >> 8
		if (bits == 0) then
			pcs["acOutConnectStatus"] = "NO"
		else
			pcs["acOutConnectStatus"] = "EN"
		end

		bits = value & 0x000F
		if (bits == 0) then
			pcs["sIn1Status"] = "Idle"
		else
			pcs["sIn1Status"] = "Work"
		end		

		value = context.parameters["status1"].value
		pcs["status1"] = value		

		bits = (value & 0x000F)
		if (bits == 0) then
			pcs["batteryStatus"] = "Do nothing"
		elseif (bits == 1) then
			pcs["batteryStatus"] = "Charge"
		else
			pcs["batteryStatus"] = "Discharge"
		end	

		bits = (value & 0x0F000000) >> 24
		if (bits == 0) then
			pcs["dc2acStatus"] = "Do nothing"
		elseif (bits == 1) then
			pcs["dc2acStatus"] = "AC-DC"
		else
			pcs["dc2acStatus"] = "DC-AC"
		end	

		bits = (value & 0x0F0000) >> 16
		if (bits == 0) then
			pcs["mainLineStatus"] = "Do nothing"
		elseif (bits == 1) then
			pcs["mainLineStatus"] = "Input"
		else
			pcs["mainLineStatus"] = "Output"
		end		

		value = context.parameters["acOutToP"].value
		pcs["acOutToP"] = value		

		value = context.parameters["bP"].value
		pcs["bP"] = value		

		value = context.parameters["totGenE"].value
		pcs["totGenE"] = value		

		value = context.parameters["genEnH"].value
		pcs["genEnH"] = value		

		value = context.parameters["genEnD"].value
		pcs["genEnD"] = value		

		value = context.parameters["genEnM"].value
		pcs["genEnM"] = value		

		value = context.parameters["genEnY"].value
		pcs["genEnY"] = value		

		value = context.parameters["con1"].value
		pcs["con1"] = value		

		pcs["con1_b11"] = (value & 0x0800) >> 11
		pcs["con1_b12"] = (value & 0x1000) >> 12

		value = context.parameters["con2"].value
		pcs["con2"] = value		
		for i = 8, 15, 1 do
			pcs["con2_b" .. tostring(i)] = (value >> i) & 0x01;
		end

		value = context.parameters["con3"].value
		pcs["con3"] = value		

		value = context.parameters["con4"].value
		pcs["con4"] = value		
		
		calAcInP = context.parameters["acOutAcP"].value - context.parameters["sInP1"].value - (-1 * context.parameters["bV"].value * 0.1 * context.parameters["bC"].value * 0.1 )
		if (calAcInP < 0) and (context.parameters["sInP1"].value == 0) then
			calAcInP = 0.0001
		end
		if (calAcInP < 0) and (context.parameters["sInP1"].value > 0) then
			calAcInP = 0
		end

		pcs["acInAcP"] = calAcInP		
		pcs["acInToAcP"] = calAcInP		

		greenPer = context.parameters["sInP1"].value / (context.parameters["sInP1"].value + calAcInP)

		pcs["greenPer"] = greenPer		
		
		-- Calculate dayCount, lastGreenE, lastGreyE, sumGreenE, sumGreyE
		endTime = os.time()

		sliceGreenE = greenPer * (acOutAcTmpP + context.parameters["acOutAcP"].value) * (endTime - startTime) / 2 / 3600000
		sumGreenE = sumGreenE + sliceGreenE
		sliceGreyE = (1 - greenPer) * (acOutAcTmpP + context.parameters["acOutAcP"].value) * (endTime - startTime) / 2 / 3600000 
		sumGreyE = sumGreyE + sliceGreyE



		if (context.parameters["acOutAcP"].value >= 100) then
			if (acOutAcRetP < 100) then
				dayCount = dayCount + 1
				acOutAcRetP = context.parameters["acOutAcP"].value
				lastGreenE = 0
				lastGreyE = 0
			end
			pcs["dayCount"] = dayCount
			mqtt:Publish("aws_emqx", prefix .. "dayCount", dayCount, 1, true)
			lastGreenE = lastGreenE + sliceGreenE
			lastGreyE = lastGreyE + sliceGreyE
			pcs["lastGreenE"] = lastGreenE
			pcs["lastGreyE"] = lastGreyE
		elseif (context.parameters["acOutAcP"].value < 100) then
			acOutAcRetP = context.parameters["acOutAcP"].value
		end

		acOutAcTmpP = context.parameters["acOutAcP"].value
		startTime = endTime

		pcs["eTime"] = endTime - startTime
		pcs["sliceGreenE"] = sliceGreenE
		pcs["sliceGreyE"] = sliceGreyE

		pcs["dayCount"] = dayCount
		pcs["lastGreenE"] = lastGreenE
		pcs["lastGreyE"] = lastGreyE

		pcs["sumGreenE"] = sumGreenE
		pcs["sumGreyE"] = sumGreyE		

		local pcs_text = JSON:encode(pcs)
		mqtt:Publish("aws_emqx", prefix .. "report", pcs_text, 2, false)

		if not is_today() then
			sumGreenE = 0
			sumGreyE = 0
			dayCount = 0
			lastGreenE = 0
			lastGreyE = 0
			today = os.date("*t")
			date_list.day = today.day
			date_list.month = today.month
			date_list.year = today.year
		end
	end
end

function on_message(context)
	local topic = context.topic
	local value = tonumber(context.payload)
 
	print("topic=" .. context.topic)
	print("value=" .. context.payload)

  	if (value == nil) then
   		--value is not a number
    	return;
  	end
  
	if (topic == ems_prompt .. "1/con3/w") and (value == 0) then
		daq:Write("advanioPcs403", con3, value)
	elseif (topic == ems_prompt .. "2/con3/w") and (value == 0) then
		daq:Write("advanioPcs501", con3, value)
	elseif (topic == ems_prompt .. "1/con4/w") then
		if (value == 1) then
			daq:Write("advanioPcs403", con4, value)
		elseif (value == 0) then
			daq:Write("advanioPcs403", con4, value)
		end	
	elseif (topic == ems_prompt .. "2/con4/w") then
		if (value == 1) then
			daq:Write("advanioPcs501", con4, value)
		elseif (value == 0) then
			daq:Write("advanioPcs501", con4, value)
		end	
	end
end

daq:OnReport(on_report)

--Register Receive Message event
mqtt:OnMessage(on_message);

--Subscribe topic
mqtt:Subscribe("aws_emqx", ems_prompt .. "1/con3/w", 2);
mqtt:Subscribe("aws_emqx", ems_prompt .. "1/con4/w", 2);
mqtt:Subscribe("aws_emqx", ems_prompt .. "2/con3/w", 2);
mqtt:Subscribe("aws_emqx", ems_prompt .. "2/con4/w", 2);
