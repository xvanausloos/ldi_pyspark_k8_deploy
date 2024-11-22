
terraform {
  required_version = ">= 1.8.5"
  required_providers {
    random = {
        source = "hashicorp/random"
        version = "~> 3.0"
    }
    local = {
         version = "~> 1.2"
    }
    template = {
        version = "~> 1.2"
    }
    aws = {        
      version = ">= 2.28.1"
    }
  } 
}
