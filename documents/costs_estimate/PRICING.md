# Azure Functions

The function is invoked every 2 minutes, we have 43600 minutes in month, so 43200/2= 21600 executions per 30 days.
Avg execution time ~ 300 ms.

![image](https://user-images.githubusercontent.com/24934034/130317590-381325c0-0cdd-4a2a-9f18-f9174bd424bc.png)

# App Services

![image](https://user-images.githubusercontent.com/24934034/130317634-01e42b12-03c7-4f76-851f-3a361309d3d7.png)

# Event Hubs

1 Throughput unit is able to handle is able to handle Up to 1 MB per second or 1000 events per second. 
Current load creating 1 event per 2 minutes with approximate size 0.0089 MB

![image](https://user-images.githubusercontent.com/24934034/130317646-cde84f8b-284d-45ad-ba3b-4b5e93714dbd.png)

# Stream Analytics

Microsoft suggests to start with 6 SU, but for our load it will be obviously more that is needed. Using https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-parallelization I found another suggestions about scaling,so if we have Ingestion Rate (events per second) = 1K messages, we can use only 1 Streaming Unit in ASA.
Ingestion rate = 0.5 msg/sec

![image](https://user-images.githubusercontent.com/24934034/130317738-3a896c39-bcd8-40a3-a600-0d0c16c70502.png)

# Cosmos DB

We used https://cosmos.azure.com/capacitycalculator/ to extimate CosmosDB price. 400 RU is the minimum RU quantity for cosmos instance, and storage cost is pretty low for Cosmos (the account with same load but only 1 GB of storage will cost 23.61 USD per month, so I decided to book more storage quantity). Avg message size ~ 0.00076294 MB, ingestion rate - 1 message/5 minutes

![image](https://user-images.githubusercontent.com/24934034/130317781-e6348299-76f8-464c-940d-846dedf1145e.png)

![image](https://user-images.githubusercontent.com/24934034/130317805-0fc97d00-d937-4f4c-a4e4-44c7651a11d4.png)

# Storage Account

Average row size for delta lake table will be 0.006 MB (bronze table), if we add silver tables for data cleansing, 1 ingestion could generate up to 0.01 MB for Storage Account. 0.01 MB * 21600 ingestiong per month = 216 MB, so we can book 1 GB. Write Operation = 21600, Read Operations = 432000 (will be read intensive).

![image](https://user-images.githubusercontent.com/24934034/130318163-000ca672-b600-4f5a-91a0-19d7e63a24ec.png)
