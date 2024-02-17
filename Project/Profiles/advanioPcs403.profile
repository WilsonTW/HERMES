{
  "Parameters": {
    "do0": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "do0",
        "type": "UInt16",
        "rank": [],
        "source": 1,
        "address": {
          "address": "000257"
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
    },
    "do1": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "do1",
        "type": "UInt16",
        "rank": [],
        "source": 1,
        "address": {
          "address": "000258"
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
    },
    "do2": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "do2",
        "type": "UInt16",
        "rank": [],
        "source": 1,
        "address": {
          "address": "000259"
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
    },
    "do3": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "do3",
        "type": "UInt16",
        "rank": [],
        "source": 1,
        "address": {
          "address": "000260"
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
    },
    "do4": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "do4",
        "type": "UInt16",
        "rank": [],
        "source": 1,
        "address": {
          "address": "000261"
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
    },
    "do5": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "do5",
        "type": "UInt16",
        "rank": [],
        "source": 1,
        "address": {
          "address": "000262"
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
    },
    "do6": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "do6",
        "type": "UInt16",
        "rank": [],
        "source": 1,
        "address": {
          "address": "000263"
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
    },
    "do7": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "do7",
        "type": "UInt16",
        "rank": [],
        "source": 1,
        "address": {
          "address": "000264"
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
    "ID": "advanioPcs403",
    "Name": "advanioPcs403",
    "Model": "Modbus",
    "Description": "",
    "ModelVersion": "1.0"
  }
}
