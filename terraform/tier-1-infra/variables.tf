variable "ipa_password" {
  type        = string
  description = "FreeIPA Admin Password"
  sensitive   = true
}

variable "proxmox_api_token" {
  type        = string
  description = "Proxmox API Token"
  sensitive   = true
}
