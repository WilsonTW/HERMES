# Hermes(DER) JSON文件範例說明

## 引言

JSON（JavaScript Object Notation）是一種輕量級的數據交換格式，易於人閱讀和編寫，同時也易於機器解析和生成。此文檔旨在提供一份具體的Aggregator JSON文件範例說明，幫助理解其結構和用途。

## JSON文件結構

一個標準的JSON文件包含以下元素：

- **對象（Objects）**：由大括號包圍，表示為一組鍵值對（"key": value）。對象可以嵌套。
- **數組（Arrays）**：由方括號包圍，表示為值的有序集合（[value1, value2]）。
- **值（Values）**：可以是字符串（String）、數字（Number）、對象（Object）、數組（Array）、布爾值（true/false）或null。

## Hermes(DER) Data Structure

### MQTT **PUB** TOPIC
```json
/AEGIS/rA/RA000001/report
```
命名規則: /AEGIS **+** /rA **+** /**station ID** **+** /report

### MQTT **SUB** TOPIC
```json
/AEGIS/rA/RA000001/control
```
命名規則: /AEGIS **+** /rA **+** /**station ID** **+** /control

### Hermes(DER) JSON
```json
{
    "RA_ID": "RA000001",
    "Timestamp": "2024-02-06T10:00:00Z",
    "Status": "Operational",
    "PCS": [
    	{"ID": "PCS67890", "Status": "Active"}
    ],
    "BMS": [
    	{"ID": "BMS54321", "Status": "Charging"}
    ],
    "PV_Inverter": [
    	{"ID": "PV13579", "Status": "Operating"}
    ]
}
```

此JSON結構提供了一個聚合器的數據模型，用於描述相關的運行狀態和組件信息。以下是各主要字段的詳細說明：

### 根層級字段

- **RA_ID**: 聚合器的唯一識別碼，用於標識具體的聚合器實例。
- **Timestamp**: 記錄數據的時間戳記，遵循ISO 8601格式，表示數據被記錄的精確時間。
- **Status**: 聚合器的當前運行狀態，例如"Operational"表明聚合器目前處於運行狀態。

>- **Operational**: 表示聚合器目前處於運行狀態，正常執行其功能。
>- **Standby**: 聚合器處於待機模式，此時設備已就緒，但未進行積極的數據處理或控制操作。
>- **Maintenance**: 指聚合器正在進行維護。在此狀態下，設備可能不執行正常操作，以便進行硬件或軟件的更新、檢修等。
>- **Fault**: 聚合器出現故障。這表明設備遇到了一個或多個問題，可能影響其正常運行。
>- **Offline**: 聚合器處於離線狀態，可能由於網絡問題或其他外部因素，設備無法與系統其餘部分通信。
>- **Power Saving**: 聚合器處於節能模式。在此模式下，設備優化其運行以降低能耗，可能會降低處理能力或暫停某些非關鍵功能。
>- **Initializing**: 聚合器正在初始化。這是設備啟動過程中的一個階段，正在準備進入完全運行狀態。

### PCS (功率轉換系統) 數組

一個包含一個或多個PCS物件的數組，每個物件包含以下字段：

- **ID**: 功率轉換系統的唯一識別碼，用於標識特定的功率轉換單元。
- **Status**: 功率轉換系統的當前運行狀態，例如"Active"表明該系統目前處於啟動且運行狀態。

>- **Active**: 表示PCS處於活躍狀態，正在正常運行並執行其轉換功能。
>- **Idle**: PCS處於閒置狀態，雖然開機但不進行任何功率轉換。
>- **Fault**: 指示PCS遇到故障，可能是硬件問題、系統錯誤或外部因素導致無法正常工作。
>- **Maintenance**: PCS正在進行維護，可能因更新、校準或修理暫時不可用。
>- **Offline**: PCS處於離線狀態，未連接到電網或控制系統，不能進行功率轉換。
>- **Standby**: PCS準備就緒，可以迅速從此狀態切換到Active狀態進行功率轉換。
>- **Initializing**: PCS正在初始化階段，準備啟動其內部系統以進入正常運行狀態。
>- **Charging**: 特別適用於具備充電功能的PCS，表示當前正在為電池或儲能系統充電。
>- **Discharging**: 對於儲能系統，PCS正在放電狀態，將儲存的能量轉換為電網所需的電力。


### BMS (電池管理系統) 數組

一個包含一個或多個BMS物件的數組，每個物件包含以下字段：

- **ID**: 電池管理系統的唯一識別碼，用於標識特定的電池管理單元。
- **Status**: 電池管理系統的當前狀態，例如"Charging"表明電池正在充電中。

>- **Charging**: 表示BMS正處於充電模式，正在為連接的電池或電池組充電。
>- **Discharging**: 指示BMS正控制電池放電，將儲存的能量釋放給外部負載。
>- **Idle**: BMS處於閒置狀態，此時電池既不在充電也不在放電。
>- **Fault**: 表明BMS檢測到一個或多個故障，可能是由於電池過熱、過壓、欠壓或通訊問題等原因。
>- **Maintenance**: 指BMS正在進行維護作業，可能涉及硬件檢查、軟件更新或系統校準等。
>- **Balancing**: BMS正在進行電池平衡操作，以確保電池組中各個電池的電荷水平一致。
>- **Offline**: 表示BMS未與其它系統連接，或因網絡問題而無法通信。
>- **Initializing**: BMS處於啟動初始化階段，準備各項內部參數以進入正常運行模式。
>- **Standby**: BMS已準備好進行充電或放電操作，但當前未執行任何操作，等待進一步指令。


### PV Inverter (光伏逆變器) 數組

一個包含一個或多個PV_Inverter物件的數組，每個物件包含以下字段：

- **ID**: 光伏逆變器的唯一識別碼，用於標識特定的光伏逆變器單元。
- **Status**: 光伏逆變器的當前狀態，例如"Operating"表明光伏逆變器正常運作。

>- **Operating**: 表示逆變器正在正常轉換太陽能板產生的直流電為交流電
>- **Standby**: 當無太陽光或光照不足以產生電力時，逆變器會進入待機模式。
>- **Fault**: 如果逆變器檢測到任何內部問題，例如溫度過高、電路問題或通訊錯誤，它將顯示故障狀態。
>- **Warning**: 當逆變器運行中出現需要注意但不一定立即影響運行的問題時，會顯示警告狀態。
>- **Maintenance**: 指逆變器正在進行維護作業，可能涉及硬件檢查、軟件更新或系統校準等。
>- **Shutdown**: 逆變器可能因為外部指令或內部安全機制而進入關機狀態。


## PCS Data Structure

### MQTT **PUB** TOPIC
```json
/AEGIS/rPCS/PCS67890/report
```
命名規則: /AEGIS **+** /rPCS **+** /**station ID** **+** /report

### MQTT **SUB** TOPIC
```json
/AEGIS/rPCS/PCS67890/control
```
命名規則: /AEGIS **+** /rPCS **+** /**station ID** **+** /control

### PCS JSON
```json
{
	"PCS_ID": "PCS67890",
	"Timestamp": "2024-02-06T10:00:00Z",
	"Status": "Active",
	"Power_Output": "500",
	"Power_Input": "480",
	"Efficiency": "96",
	"Operating_Mode": "Grid-Tied",
	"Battery_Voltage": "48",
	"External_Battery_Temperature": "25",
	"AC_Input_Active_Power_R": "460",
	"AC_Output_Voltage_R": "230",
	"AC_Output_Active_Power_R": "500",
	"AC_Output_Frequency": "50",
	"AC_Output_Current_R": "2.17",
	"Battery_Capacity": "10000",
	"Solar_Input_Power_1": "1500",
	"Battery_Current": "100",
	"Solar_Input_Voltage_1": "150",
	"Component_Max_Temperature": "40",
	"AC_Input_Total_Active_Power": "460",
	"AC_Input_Current_R": "2",
	"Solar_Input_Current_1": "6.5",
	"AC_Output_Apparent_Power_R": "520",
	"AC_Input_Voltage_R": "220",
	"AC_Input_Frequency": "50",
	"AC_Output_Power_Percentage": "90",
	"Inner_Temperature": "30",
	"AC_Output_Total_Power": "500",
	"Battery_Power": "480",
	"Total_Generated_Energy": "10000",
	"Generated_Energy_Of_Hour": "500",
	"Generated_Energy_Of_Day": "120",
	"Generated_Energy_Of_Month": "3000",
	"Generated_Energy_Of_Year": "12000",
	"First_Generated_Energy_Saved_Time": "2024-02-06T00:00:00Z",
	"The_Date_Of_The_Hourly_Energy": "2024-02-06T10:00:00Z",
	"The_Date_Of_The_Daily_Energy": "2024-02-06",
	"The_Date_Of_The_Monthly_Energy": "2024-02",
	"The_Date_Of_The_Yearly_Energy": "2024",
	"Controls": {
		"Generator_as_AC_Input": "true",
		"Wide_AC_Input_Range": "true",
		"Charge_Battery": "true",
		"AC_Charge_Battery": "true",
		"Feed_Power_To_Utility": "true",
		"Battery_Discharge_To_Loads_When_Solar_Input_Normal": "true",
		"Battery_Discharge_To_Loads_When_Solar_Input_Loss": "true",
		"Battery_Discharge_To_Feed_Power_To_Utility_When_Solar_Input_Normal": "true",
		"Battery_Discharge_To_Feed_Power_To_Utility_When_Solar_Input_Loss": "true",
		"Auto_Adjust_PF_According_To_Feed_Power": "true",
		"Machine_Supply_Power_To_The_Loads": "true",
		"Charger_Keep_Battery_Voltage_Function": "true"
	},
	"Errors": {
		"Solar_Input_Loss": "false",
		"AC_Input_Over_Voltage": "false",
		"AC_Input_Under_Voltage": "false",
		"Battery_Over_Temperature": "false",
		"Battery_Under_Temperature": "false",
		"Battery_Over_Voltage": "false",
		"Battery_Under_Voltage": "false",
		"Over_Load": "false",
		"Short_Circuit": "false"
	}
}
```
此JSON結構提供了一個功率轉換系統（PCS）的詳細數據模型，用於描述其運行狀態、效率、控制設置等信息。以下是各主要字段的詳細說明：

### 根層級字段

- **PCS_ID**: 功率轉換系統的唯一識別碼。
- **Timestamp**: 數據記錄的時間戳記，遵循ISO 8601格式。
- **Status**: PCS的當前運行狀態，如"Active"表示系統正在運行。

>- **Active**: 表示PCS處於活躍狀態，正在正常運行並執行其轉換功能。
>- **Idle**: PCS處於閒置狀態，雖然開機但不進行任何功率轉換。
>- **Fault**: 指示PCS遇到故障，可能是硬件問題、系統錯誤或外部因素導致無法正常工作。
>- **Maintenance**: PCS正在進行維護，可能因更新、校準或修理暫時不可用。
>- **Offline**: PCS處於離線狀態，未連接到電網或控制系統，不能進行功率轉換。
>- **Standby**: PCS準備就緒，可以迅速從此狀態切換到Active狀態進行功率轉換。
>- **Initializing**: PCS正在初始化階段，準備啟動其內部系統以進入正常運行狀態。
>- **Charging**: 特別適用於具備充電功能的PCS，表示當前正在為電池或儲能系統充電。
>- **Discharging**: 對於儲能系統，PCS正在放電狀態，將儲存的能量轉換為電網所需的電力。


### 性能參數

- **Power_Output**: 系統輸出功率，單位為瓦(W)。
- **Power_Input**: 系統輸入功率，單位為瓦(W)。
- **Efficiency**: 系統效率，以百分比表示。
- **Operating_Mode**: 運行模式，如"Grid-Tied"表示與電網連接。
- **Battery_Voltage**: 電池電壓，單位為伏特(V)。
- **External_Battery_Temperature**: 外部電池溫度，單位為攝氏度(°C)。

### 輸入輸出參數

- **AC_Input_Active_Power_R**: 交流輸入的有效功率，單位為瓦(W)。這是系統從電網或任何外部交流源接收的實際功率量。
- **AC_Output_Voltage_R**: 交流輸出電壓，單位為伏特(V)。反映了PCS系統向負載或電網提供電能時的電壓水平。
- **AC_Output_Active_Power_R**: 交流輸出的有效功率，單位為瓦(W)。表示系統輸出到負載或電網的實際功率量。
- **AC_Output_Frequency**: 交流輸出頻率，單位為赫茲(Hz)。這是指系統輸出電能的頻率，對於與電網連接的系統來說，此參數非常重要，因為它需要與電網的頻率相匹配。
- **AC_Output_Current_R**: 交流輸出電流，單位為安培(A)。表示系統向負載或電網提供電能時的電流強度。
- **AC_Input_Total_Active_Power**: 交流輸入的總有效功率，單位為瓦(W)。這是系統從所有交流輸入源總共接收的有效功率量。
- **AC_Input_Current_R**: 交流輸入電流，單位為安培(A)。反映了系統從電網或任何外部交流源接收電能時的電流強度。
- **AC_Input_Voltage_R**: 交流輸入電壓，單位為伏特(V)。這是系統從外部交流源接收電能時的電壓水平。
- **AC_Input_Frequency**: 交流輸入頻率，單位為赫茲(Hz)。表示系統從外部交流源接收電能的頻率，對確保系統與電網頻率相匹配非常重要。
- **AC_Output_Apparent_Power_R**: 交流輸出的視在功率，單位為瓦(W)。這是系統輸出的總功率，包括有效功率和無效功率（如反映在電磁場中的能量）。
- **AC_Output_Power_Percentage**: 交流輸出功率的百分比，表示相對於最大輸出能力的功率輸出百分比。
- **AC_Output_Total_Power**: 交流輸出的總功率，單位為瓦(W)。這是系統總共向負載或電網提供的功率量，考慮了所有輸出通道。

### 電池參數

- **Battery_Capacity**: 表示電池的總儲能容量，單位為毫安時(mAh)。這是衡量電池能儲存多少電能的重要指標，10000mAh表示電池在標準狀態下能儲存的電量。
- **Battery_Current**: 電池電流，單位為安培(A)。反映了電池充放電時的電流大小，100A表示電池在該時刻的充放電電流。
- **Battery_Power**: 電池功率，單位為瓦(W)。這表示電池在特定時間內的輸出或輸入功率，480W指電池提供或接收的功率。

### 太陽能輸入參數

- **Solar_Input_Power_1**: 第一路太陽能輸入功率，單位為瓦(W)。這反映了從太陽能板接收到的功率，1500W表示太陽能板在該時刻向系統提供的功率。
- **Solar_Input_Voltage_1**: 第一路太陽能輸入電壓，單位為伏特(V)。150V表示太陽能板在該時刻的輸出電壓。
- **Solar_Input_Current_1**: 第一路太陽能輸入電流，單位為安培(A)。6.5A表示太陽能板在該時刻的輸出電流。

### 溫度參數

- **Component_Max_Temperature**: 系統內部組件的最大溫度，單位為攝氏度(°C)。40°C表示系統內部某個組件達到的最高溫度。
- **Inner_Temperature**: 系統內部溫度，單位為攝氏度(°C)。30°C表示PCS系統內部的平均溫度。

### 能源生成與記錄

- **Total_Generated_Energy**: 系統自安裝以來總共生成的能源量，單位為瓦時(Watt-hour, Wh)。這一度量衡提供了系統總體效能的一個指標。
- **Generated_Energy_Of_Hour**: 每小時生成的能源量，單位為瓦時(Wh)。這反映了系統在最近一個小時內的能源輸出表現。
- **Generated_Energy_Of_Day**: 每天生成的能源量，單位為瓦時(Wh)。這提供了系統日常運行效能的快照。
- **Generated_Energy_Of_Month**: 每月生成的能源量，單位為瓦時(Wh)。這有助於評估系統在月度周期內的表現和趨勢。
- **Generated_Energy_Of_Year**: 每年生成的能源量，單位為瓦時(Wh)。這有助於長期評估系統的效能和可靠性。
- **First_Generated_Energy_Saved_Time**: 首次記錄能源生成量的時間戳記，遵循ISO 8601格式。這標記了系統開始運行和產生能源的起始點。
- **The_Date_Of_The_Hourly_Energy**: 按小時記錄能源生成量的具體日期和時間，遵循ISO 8601格式。這有助於準確追蹤和分析系統在特定時間的表現。
- **The_Date_Of_The_Daily_Energy**: 按日記錄能源生成量的日期。這使得用戶能夠輕鬆查看系統在特定日子的能源產出。
- **The_Date_Of_The_Monthly_Energy**: 按月記錄能源生成量的日期。這有助於評估系統在不同月份的整體表現。
- **The_Date_Of_The_Yearly_Energy**: 按年記錄能源生成量的日期。這提供了一個宏觀的視角，用於分析系統隨時間的效能變化。

### 控制設置 (`Controls`)

此部分包含了一系列布爾值（1：true/0：false），用以指示PCS系統的各種控制選項和模式。

- **Generator_as_AC_Input**: 將發電機作為交流輸入。當設置為true時，表示系統允許從發電機接收交流輸入。
- **Wide_AC_Input_Range**: 寬交流輸入範圍。true表示系統能夠接受較寬範圍的交流輸入電壓，增加了系統的靈活性和適應性。
- **Charge_Battery**: 允許電池充電。當設為true時，系統可以從交流輸入或太陽能輸入對電池進行充電。
- **AC_Charge_Battery**: 允許交流電充電電池。true表示系統可以從交流輸入直接充電到電池。
- **Feed_Power_To_Utility**: 向電網馈電。設為true時，系統能將多餘的電力輸出到電網。
- **Battery_Discharge_To_Loads_When_Solar_Input_Normal**: 太陽能輸入正常時電池對負載放電。true表示在太陽能輸入正常時，系統允許電池向負載放電。
- **Battery_Discharge_To_Loads_When_Solar_Input_Loss**: 太陽能輸入丟失時電池對負載放電。true表示在太陽能輸入不可用時，系統依然允許電池向負載放電。
- **Battery_Discharge_To_Feed_Power_To_Utility_When_Solar_Input_Normal**: 太陽能輸入正常時電池向電網馈電。true表示系統允許在太陽能輸入正常時，從電池向電網輸出電力。
- **Battery_Discharge_To_Feed_Power_To_Utility_When_Solar_Input_Loss**: 太陽能輸入丟失時電池向電網馈電。true表示即使在太陽能輸入不可用時，系統也允許從電池向電網輸出電力。
- **Auto_Adjust_PF_According_To_Feed_Power**: 根據馈電量自動調整功率因數(PF)。true表示系統能自動調整功率因數，以優化馈電效率。
- **Machine_Supply_Power_To_The_Loads**: 機器向負載供電。true表示系統可以直接向負載提供電力。
- **Charger_Keep_Battery_Voltage_Function**: 充電器保持電池電壓功能。true表示系統中的充電器可以維持電池的電壓在一個安全範圍內。

### 錯誤狀態 (`Errors`)

此部分包含了一系列布爾值（1：true/0：false），用於指示PCS系統可能遇到的各種錯誤狀態。

- **Solar_Input_Loss**:接到逆變器的太陽能板輸入電壓低於正常運行所需的最小電壓門檻。
- **AC_Input_Over_Voltage**: AC輸入過壓。當設為true時，表示系統檢測到交流輸入電壓超出了正常範圍上限，可能對系統造成損害。
- **AC_Input_Under_Voltage**: AC輸入欠壓。true表示系統檢測到交流輸入電壓低於正常範圍下限，這可能影響系統性能。
- **Battery_Over_Temperature**: 電池過溫。當此值為true時，表示系統內電池的溫度超過了安全工作範圍，需要進行冷卻或其他措施以避免損害。
- **Battery_Under_Temperature**: 電池低溫。true表示電池的溫度低於最低工作溫度範圍，可能影響電池性能或壽命。
- **Battery_Over_Voltage**: 電池過壓。設為true時，表示電池電壓超過了允許的最大限值，可能導致電池損壞或系統不穩定。
- **Battery_Under_Voltage**: 電池欠壓。true表示電池電壓低於正常工作範圍，可能導致系統無法正常工作。
- **Over_Load**: 過載。當此值為true時，表示系統負載超出了最大容量，可能引起系統過熱或性能下降。
- **Short_Circuit**: 短路。true表示系統發生短路故障，這是一種嚴重的電氣故障，需要立即處理以避免進一步損壞。

## BMS Data Structure

### MQTT **PUB** TOPIC
```json
/AEGIS/rBMS/BMS54321/report
```
命名規則: /AEGIS **+** /rBMS **+** /**station ID** **+** /report

### MQTT **SUB** TOPIC
```json
/AEGIS/rBMS/BMS54321/control
```
命名規則: /AEGIS **+** /rBMS **+** /**station ID** **+** /control

### BMS JSON
```json
{
	"BMS_ID": "BMS54321",
	"Timestamp": "2024-02-06T10:00:00Z",
	"Status": "Charging",
	"Battery_Capacity": "10000",
	"Current_Charge": "7500",
	"State_of_Charge": "75",
	"Health_Status": "98",
	"Pack_Current": "100",
	"Pack_Total_Voltage": "400",
	"Pack_Remaining_Capacity": "5000",
	"Pack_Total_Capacity": "10000",
	"Battery_Cycle": "500",
	"Humidity": "60",
	"Cells": [
		{"Cell_ID": "Cell001", "Voltage": "3.7", "Temperature": "25"},
		{"Cell_ID": "Cell002", "Voltage": "3.6", "Temperature": "26"}
	]
}
```

此JSON結構提供了一個電池管理系統（BMS）的數據模型，用於描述電池的狀態、容量、健康狀況以及其他相關信息。

### 根層級字段

- **BMS_ID**: 電池管理系統的唯一識別碼，用於標識特定的BMS裝置。
- **Timestamp**: 數據記錄的時間戳記，遵循ISO 8601格式，表示數據被記錄的精確時間。
- **Status**: BMS的當前狀態，如"Charging"表示電池正在充電中。

>- **Charging**: 表示BMS正處於充電模式，正在為連接的電池或電池組充電。
>- **Discharging**: 指示BMS正控制電池放電，將儲存的能量釋放給外部負載。
>- **Idle**: BMS處於閒置狀態，此時電池既不在充電也不在放電。
>- **Fault**: 表明BMS檢測到一個或多個故障，可能是由於電池過熱、過壓、欠壓或通訊問題等原因。
>- **Maintenance**: 指BMS正在進行維護作業，可能涉及硬件檢查、軟件更新或系統校準等。
>- **Balancing**: BMS正在進行電池平衡操作，以確保電池組中各個電池的電荷水平一致。
>- **Offline**: 表示BMS未與其它系統連接，或因網絡問題而無法通信。
>- **Initializing**: BMS處於啟動初始化階段，準備各項內部參數以進入正常運行模式。
>- **Standby**: BMS已準備好進行充電或放電操作，但當前未執行任何操作，等待進一步指令。

### 電池信息

- **Battery_Capacity**: 電池的總容量，單位為毫安時(mAh)。
- **Current_Charge**: 電池當前的充電量，單位為毫安時(mAh)。
- **State_of_Charge**: 電池的充電狀態，以百分比表示。
- **Health_Status**: 電池的健康狀態，以百分比表示，反映電池性能相對於新電池的比例。
- **Pack_Current**: 電池包的當前電流，單位為安培(A)。
- **Pack_Total_Voltage**: 電池包的總電壓，單位為伏特(V)。
- **Pack_Remaining_Capacity**: 電池包的剩餘容量，單位為毫安時(mAh)。
- **Pack_Total_Capacity**: 電池包的總容量，單位為毫安時(mAh)。
- **Battery_Cycle**: 電池的充放電循環次數。
- **Humidity**: 環境濕度，以百分比表示。

### 單個電池單元信息 (Cells)

- **Cell_ID**: 單個電池單元的唯一識別碼。
- **Voltage**: 單個電池單元的電壓，單位為伏特(V)。
- **Temperature**: 單個電池單元的溫度，單位為攝氏度(°C)。

## PV_Inverter Data Structure

### MQTT **PUB** TOPIC
```json
/AEGIS/rPV/PV13579/report
```
命名規則: /AEGIS **+** /rPV **+** /**station ID** **+** /report

### MQTT **SUB** TOPIC
```json
/AEGIS/rPV/PV13579/control
```
命名規則: /AEGIS **+** /rPV **+** /**station ID** **+** /control

### PV_Inverter JSON
```json
{
	"PV_ID": "PV13579",
	"Timestamp": "2024-02-06T10:00:00Z",
	"Status": "Operating",
	"Input_Power: "8000",
	"Output_Power": "7650",
	"Irradiance": "1200",
	"Temperature": "27.5"
}
```

此JSON結構提供了一個光伏逆變器（PV Inverter）的數據模型，用於描述光伏逆變器的狀態以及其他相關信息。

### 根層級字段

- **PV_ID**: 光伏逆變器的唯一識別碼，用於標識特定的光伏逆變器單元。
- **Timestamp**: 數據記錄的時間戳記，遵循ISO 8601格式，表示數據被記錄的精確時間。
- **Status**: 光伏逆變器的當前狀態，例如"Operating"表明光伏逆變器正常運作。

>- **Operating**: 表示逆變器正在正常轉換太陽能板產生的直流電為交流電
>- **Standby**: 當無太陽光或光照不足以產生電力時，逆變器會進入待機模式。
>- **Fault**: 如果逆變器檢測到任何內部問題，例如溫度過高、電路問題或通訊錯誤，它將顯示故障狀態。
>- **Warning**: 當逆變器運行中出現需要注意但不一定立即影響運行的問題時，會顯示警告狀態。
>- **Maintenance**: 指逆變器正在進行維護作業，可能涉及硬件檢查、軟件更新或系統校準等。
>- **Shutdown**: 逆變器可能因為外部指令或內部安全機制而進入關機狀態。

### 設備信息

- **Input_Power**: 逆變器從太陽能板接收的DC電功率，單位為瓦(W)。
- **Output_Power**: 逆變器轉換後輸出到電網的AC電功率，單位為瓦(W)。
- **Irradiance**: 太陽光照射到太陽能板的強度，通常表示為瓦特每平方米 (W/m²)。
- **Temperature**: 環境溫度 (Ambient Temperature)：逆變器周圍的空氣溫度，通常表示為攝氏度 (°C)。

