# CloudPlatformsUCU
Cloud Platforms project repo

# Team
Bohdan Yarychevskyi, Dmytro Voloshyniuk, Solomiya Synytsia, Khrystyna Hranishak

# Idea
The core concept for this project is tracking of selected cryptocurrencies price using coinmarketcap API (https://coinmarketcap.com/api/).
We will use Azure Cloud services to build the data pipeline.

# Services
- Azure Function
- Azure Strean Analytics
- Cosmos DB
- Azure BLOB
- Azure Databricks
- Event Hubs

# System Diagram
![image](https://user-images.githubusercontent.com/24934034/129438132-63d59820-5019-4ff7-a842-47597f23f625.png)

# Data flow Diagram
![image](https://user-images.githubusercontent.com/24934034/129438089-5111a451-d572-4891-a867-58f9469b53f4.png)

# How To Start Project
  1. Checkout on main branch and start the dev container
  2. Login to your Azure azzount following command: az login --use-device
  3. Set direction to 'terraform' and execute following command: terraform init, terraform plan, terraform apply
  4. Change working direction to coinmarketProducer, set valid API key for file coinmarketProducer/timerTriggerProducer/__init__.py, line 25
  5. Execute following command from console line: func azure functionapp publish ucucloudplatformsfunc -- python
  6. Manually create databriks cluster inside workspace using cluster_config.json file (check paste_cluster_config.png screenshot).
  7. Import ucu1_coindata_to_blob.ipynb notebook to your workspace and install library(use install_library.png faleas a tip). Run code in notebook.
  8. Output from ASA to Cosmos should be manually configured as terraform doesn't currently support such output:
      1. create Cosmos container with parttition key 'PartitionId'
      2. add ASA output to Cosmos with alias 'cosmos' (this alias is used in the transform query) 
