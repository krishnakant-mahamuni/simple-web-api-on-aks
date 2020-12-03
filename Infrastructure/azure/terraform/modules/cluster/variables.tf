variable "resource_group_name" {
}
variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}
variable "location" {
  default = "australiaeast"
}
variable "kubernetes_version" {
    default = "1.18.10"
}
variable "prefix" {
  default = "simple-web-api"
}
variable "node_vm_size" {
  default = "Standard_B2s"
}
variable "node_count" {
  type    = number
  default = 1
}