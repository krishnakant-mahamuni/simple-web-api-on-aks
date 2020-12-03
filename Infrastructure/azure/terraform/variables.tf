variable "subscription_id" {
  default = ""
}
variable "resource_group_name"{
  default="simple-web-api-rg"
}
variable "tenant_id" {
  default = ""
}
variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}
variable "prefix" {
  default = "simple-web-api"
}
variable "location" {
  default = ""
}
variable "node_vm_size" {
  default = "Standard_B2s"
}
variable "node_count" {
  type    = number
  default = 1
}
variable "kubernetes_version"{
  default = "1.18.10"
}