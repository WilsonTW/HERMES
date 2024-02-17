# 目錄

- [技術筆記01：MQTT傳輸JSON資料優化策略](#技術筆記01：MQTT傳輸JSON資料優化策略)

# 技術筆記01：MQTT傳輸JSON資料優化策略

在使用MQTT傳輸JSON資料時，考量到payload的大小並進行優化是非常重要的。以下是一些可以採取的程式設計手段來縮小payload：

## 簡化鍵值名稱

- **描述**：JSON物件中的鍵值名稱可以簡化，例如使用縮寫或更短的名稱。這可以大幅減少每條消息的大小。

## 移除非必要的空格和換行

- **描述**：JSON編碼默認包含了許多空格和換行符號以增加可讀性，但在傳輸時這些都不是必需的。使用工具或程式庫最小化JSON，移除這些非必要的字符。

## 使用數據壓縮

- **描述**：對JSON進行壓縮可以顯著減少其大小。常見的壓縮算法包括GZIP。在客戶端壓縮資料後發送，並在接收端解壓縮。

## 數據序列化

- **描述**：使用如MessagePack這樣的二進位序列化格式代替純文本的JSON，可以減少數據大小並提高處理速度。MessagePack是一種高效的二進位序列化格式，它允許您在JSON和二進位格式之間進行轉換，通常比純JSON格式更小。

## 字段值編碼

- **描述**：對於預定義的或可預測的字段值，可以使用編碼技術。例如，將長字符串映射到預定義的短代碼。

## 選擇性字段

- **描述**：只包含必要的資料字段。如果某些資料可以從其他資料推導出來，或者在特定應用場景中不是必需的，則不應該包括這些資料。

## 分段傳輸

- **描述**：對於非常大的資料集，考慮將其分割成多個較小的消息進行傳輸，而不是一次性傳送整個大資料集。

採取上述措施可以有效減少MQTT消息的大小，提高網絡傳輸效率並降低延遲。在實際應用中，可以根據實際情況選擇一種或多種方法結合使用，以達到最佳的效能優化。

## 簡化鍵值名稱的範例代碼
簡化鍵值名稱主要是手動進行的，但你可以透過一些自動化工具或腳本來幫助這個過程。這裡提供簡單的Python/Lua/TavaScript示例，展示如何將較長的JSON鍵值名稱簡化為較短的名稱。這個程序會將一個包含長鍵值名稱的JSON物件轉換成使用簡化鍵值名稱的新物件：

**Python**

```python
import json

# 原始JSON物件
original_json = {
    "temperatureInCelsius": 25,
    "humidityPercentage": 60,
    "deviceLocation": {
        "latitude": 35.6895,
        "longitude": 139.6917
    }
}

# 鍵值對應表，用於簡化名稱
key_mapping = {
    "temperatureInCelsius": "tempC",
    "humidityPercentage": "hum%",
    "deviceLocation": "loc",
    "latitude": "lat",
    "longitude": "lon"
}

def simplify_keys(obj, key_map):
    """遞迴函數來簡化JSON物件中的鍵值名稱"""
    if isinstance(obj, dict):
        return {key_map.get(k, k): simplify_keys(v, key_map) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [simplify_keys(element, key_map) for element in obj]
    else:
        return obj

# 簡化JSON物件的鍵值名稱
simplified_json = simplify_keys(original_json, key_mapping)

# 輸出簡化後的JSON物件
print(json.dumps(simplified_json, indent=4))

```

**Lua**

```lua
luarocks install lua-cjson
```

```lua
local cjson = require "cjson"

-- 原始JSON字符串
local json_str = [[
{
    "temperatureInCelsius": 25,
    "humidityPercentage": 60,
    "deviceLocation": {
        "latitude": 35.6895,
        "longitude": 139.6917
    }
}
]]

-- 將JSON字符串解碼為Lua表格
local original_data = cjson.decode(json_str)

-- 鍵值映射表
local key_mapping = {
    temperatureInCelsius = "tempC",
    humidityPercentage = "hum%",
    deviceLocation = "loc",
    latitude = "lat",
    longitude = "lon"
}

-- 函數：簡化鍵值名稱
local function simplify_keys(tbl)
    local simplified = {}
    for k, v in pairs(tbl) do
        local new_key = key_mapping[k] or k
        if type(v) == "table" then
            simplified[new_key] = simplify_keys(v) -- 遞迴處理子表格
        else
            simplified[new_key] = v
        end
    end
    return simplified
end

-- 簡化原始數據的鍵值名稱
local simplified_data = simplify_keys(original_data)

-- 將簡化後的數據編碼為JSON字符串並輸出
local simplified_json_str = cjson.encode(simplified_data)
print(simplified_json_str)
```

**JavaScript**

```javascript
const originalJson = {
  temperatureInCelsius: 25,
  humidityPercentage: 60,
  deviceLocation: {
    latitude: 35.6895,
    longitude: 139.6917,
  },
};

// 鍵值映射表
const keyMapping = {
  temperatureInCelsius: 'tempC',
  humidityPercentage: 'hum%',
  deviceLocation: 'loc',
  latitude: 'lat',
  longitude: 'lon',
};

function simplifyKeys(obj) {
  const simplifiedObject = {};
  for (const key in obj) {
    const newKey = keyMapping[key] || key; // 獲取新鍵值名稱或使用原始名稱
    if (obj[key] !== null && typeof obj[key] === 'object') {
      // 如果值是對象，遞迴調用以簡化嵌套對象的鍵值
      simplifiedObject[newKey] = simplifyKeys(obj[key]);
    } else {
      simplifiedObject[newKey] = obj[key];
    }
  }
  return simplifiedObject;
}

const simplifiedJson = simplifyKeys(originalJson);

console.log(JSON.stringify(simplifiedJson, null, 2));
```