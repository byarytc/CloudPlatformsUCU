variable "location" {
    type    =   string
    default =   "westeurope"
}

variable "prefix" {
    type    =   string
    default =   "azureproject"

}

variable "cosmos_db_account_name" {
  default = "ucucosmosacc"
}

variable "failover_location" {
  default = "australiasoutheast"
}


variable "spark_version" {
  description = "Spark Runtime Version for databricks clusters"
  default     = "7.3.x-scala2.12"
}

variable "node_type_id" {
  description = "Type of worker nodes for databricks clusters"
  default     = "Standard_DS3_v2"
}

variable "notebook_path" {
  description = "Path to a notebook"
  default     = "/python_notebook"
}






