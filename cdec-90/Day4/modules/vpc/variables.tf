variable "vpc_cidr" {
    default     = "10.0.0.0/16"
}
variable "project" {
    default     = "cbz"
}
variable "env" {
    default     = "dev"
}
variable "pri_sub_cidr" {
    default     = "10.0.1.0/20"
}
variable "pub_sub_cidr" {
    default     = "10.0.2.0/20"
}