variable "gcp_svc_key" {
  description = "Path to the GCP service account key file."
  type        = string
}

variable "gcp_project" {
  description = "The GCP project ID to deploy resources into."
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources into."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone to deploy the VM into."
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "The machine type for the VM instance."
  type        = string
  default     = "e2-micro"
}