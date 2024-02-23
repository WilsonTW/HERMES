{
  "Parameters": {
    "temp": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "temp",
        "type": "UInt16",
        "rank": [],
        "source": 1,
        "address": {
          "address": "400518"
        },
        "properties": {},
        "memo": "",
        "linear": {
          "enable": false,
          "scale": 1.0,
          "base": 0
        },
        "reference": {
          "enable": false,
          "variable_id": "",
          "index": 0,
          "bit": 0,
          "length": 1
        }
      }
    }
  },
  "Properties": {
    "StationNo": 1,
    "Endian": "little",
    "CoilMaxNum": 2000,
    "InputMaxNum": 2000,
    "HoldingRegMaxNum": 125,
    "InputRegMaxNum": 125,
    "Timeout": 1000,
    "ResponseDelay": 0,
    "RequestDelay": 0
  },
  "Driver": {
    "drive_name": "device.modbus.master",
    "filename": "device.modbus.master.drv",
    "properties": {
      "protocol": "RTU"
    }
  },
  "Information": {
    "ID": "advanioPcs103",
    "Name": "advanioPcs103",
    "Model": "Modbus",
    "Description": "",
    "ModelVersion": "1.0"
  }
}
