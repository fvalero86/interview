variable "update_level" {
  default     = "minor"
  description = "The highest level of update to apply with managed platform updates"
}
variable "preferred_start_time" {
  default     = "Sun:10:00"
  description = "Configure a maintenance window for managed actions in UTC"
}
variable "instance_refresh_enabled" {
  default     = "true"
  description = "Enable weekly instance replacement."
}

variable "application_environment" {
    default = "stg"
}

variable "application_name" {
    default = "interview"
}

variable "region" {
    default = "eu-west-1"
}