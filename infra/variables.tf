variable "env" {
  type        = string
  description = "An environment created for this load test."
}

variable "region" {
  type        = string
  description = "Location to deploy infrastructure."
  default     = "lon1"
}
