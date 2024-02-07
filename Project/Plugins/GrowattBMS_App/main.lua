JSON = require("modules/JSON")
rs232 = require("luars232")
inspect = require("modules/inspect")
mqtt = MQTTAPI()

local bms_prompt = "/BOFI/growatt_bms/1/"
local port_name = "/dev/serial1"
local out = io.stderr
local Port = nil

function GetCheckSum(buf, start, len)
	local checksum = 0;

	for idx = start, start + len - 1 do
		checksum = checksum + buf:byte(idx)
	end

	checksum = checksum & 0xFF
	return checksum
end

function GetCANID(buf)
	return tonumber(string.sub(buf, 1, 3), 16)
end

function GetDLC(buf)
	return tonumber(string.sub(buf, 4, 1), 16)
end

function ReceivePacket(canid)
	local err, buf, len
	local packet = ""
	local i
	local state = 0
	local ch

	while (true) do
		state = 0
		packet = ""
		for i = 1, 10 do
			err, buf, len = Port:read(1, 100)    
			if (err ~= 0 and err ~= 9) then
				print("serial port error, " .. tostring(err) .. "\n")
				return -4, 0, nil
			end

			if (len > 0) then
				i = 0
			
				for idx = 1, len do
					ch = buf:byte(idx)
					if (state == 0) then
						if (ch == 't') then
							state = 1
						end
					elseif (state == 1) then
						if (ch == 0x0D) then
							state = 2
							break;
						end
						packet = packet .. string.char(ch)
					end
				end      
			end

			if (state == 2) then
				break;
			end
		end

		if (#packet == 0) then
			return -1, 0, nil  -- Timeout
		end


		if (#packet < 6) then
			return -2, 0, nil -- 封包不完整
		end

		local checksum1 = string.format("%02X", GetCheckSum(packet, 1, #packet - 2))
		local checksum2 = string.upper(string.sub(packet, #packet - 1))
		if (checksum1 ~= checksum2) then
			print(checksum1 .. "  " .. checksum2)
			print("Check Sum Error\n")
			return -3, 0, nil
		end

		if (canid == GetCANID(packet)) then
			break	
		end
		print("Skip Receive : " .. packet .. "\n")
	end

	print("Receive : " .. packet .. "\n")
	return 0, #packet, packet
end

function ReadParameter(id, dlc)
	local value = {}

	local tx, rx
	local checksum
	local err, len
	-- build i-7530 message format
	-- T + id + dlc + check + <cr>
	tx = "T" .. string.format("%03X", id & 0x3FF) .. string.format("%01X", dlc)

	checksum = string.format("%02X", GetCheckSum(tx, 1, #tx))
	tx = tx .. checksum .. string.char(0x0D)

	print("Send : " .. tx .. "\n")

	err, len = Port:write(tx)
	if (err ~= 0) then
		print("Send Error " .. tostring(err))
		return 0, nil
	end	

	err, len, rx = ReceivePacket(id)

	if (err ~= 0) then
	  -- Receive Error
	  print("Error " .. tostring(err))
	  return 0, nil
	end	

	dlc = GetDLC(rx)
	if (dlc == 0) then
		return 0, nil
	end
	
	for i = 1, dlc do
		value[i] = tonumber(string.sub(rx, i * 2 + 5, 2) 16)
	end

	return dlc, value
end

function ReadReport()
	local data, len
	local report = {}

	report.Timestamp = os.date("!%Y-%m-%dT%H:%M:%S") .. "+0000"

	len, data = ReadParameter(0x311, 8)	
	len, data = ReadParameter(0x312, 8)
	len, data = ReadParameter(0x313, 8)
	len, data = ReadParameter(0x314, 8)
	len, data = ReadParameter(0x319, 8)
	len, data = ReadParameter(0x320, 8)
	len, data = ReadParameter(0x322, 8)
	len, data = ReadParameter(0x323, 8)

	return report
end


function on_process()
	local report = nil
	local e


	if (Port == nil) then
		e, Port = rs232.open(port_name)
		if e ~= rs232.RS232_ERR_NOERROR then
			-- handle error
			out:write(string.format("can't open serial port '%s', error: '%s'\n",
					port_name, rs232.error_tostring(e)))
			return
		end
	
		-- set port settings
		assert(Port:set_baud_rate(rs232.RS232_BAUD_115200) == rs232.RS232_ERR_NOERROR)
		assert(Port:set_data_bits(rs232.RS232_DATA_8) == rs232.RS232_ERR_NOERROR)
		assert(Port:set_parity(rs232.RS232_PARITY_NONE) == rs232.RS232_ERR_NOERROR)
		assert(Port:set_stop_bits(rs232.RS232_STOP_1) == rs232.RS232_ERR_NOERROR)
		assert(Port:set_flow_control(rs232.RS232_FLOW_OFF)  == rs232.RS232_ERR_NOERROR)
	end

	if (Port == nil) then
		return
	end
	

	report = ReadReport()

	if report ~= nil then
		local text = JSON:encode(report)
		mqtt:Publish("mqtt2", bms_prompt .. "report", text, 1, false)	
	end

	Port:close()
	Port = nil
end




