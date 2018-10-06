variable "application_name" {
    default = "interview"
}

variable "region" {
    default = "eu-west-1"
}
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

variable "rolling_update_type" {
  default     = "Health"
  description = "Set it to Immutable to apply the configuration change to a fresh group of instances"
}
variable "updating_min_in_service" {
  default     = "1"
  description = "Minimum count of instances up during update"
}
variable "updating_max_batch" {
  default     = "1"
  description = "Maximum count of instances up during update"
}
