terraform {
  required_version = ">= 0.12.0"
  required_providers {
    # null = {
    #   version = "~> 2.1"
    # }
    # template = {
    #   version = "~> 2.1"
    # }
    kubernetes = {
      version = "~> 1.11"
    }
  }
}