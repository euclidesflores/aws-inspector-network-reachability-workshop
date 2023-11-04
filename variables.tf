variable "ip_addresses_for_env" {
  type = map(object({
    vpc = map(object({
      cidr_block              = string
      tags                    = map(string)
      map_public_ip_on_launch = bool
      public_subnet_az1       = string
      private_subnet_az1      = string
      web_subnet_az1          = string
      db_subnet_az1           = string
      public_subnet_az2       = string
      private_subnet_az2      = string
      web_subnet_az2          = string
      db_subnet_az2           = string
      on_prem_cidr_block      = string
    }))
  }))
  default = {
    "web_app" = {
      vpc = {
        values = {
          cidr_block              = "10.0.0.0/16"
          public_subnet_az1       = "10.0.0.0/24"
          private_subnet_az1      = "10.0.0.0/24"
          web_subnet_az1          = "10.0.1.0/24"
          db_subnet_az1           = "10.0.2.0/24"
          public_subnet_az2       = "10.0.128.0/24"
          private_subnet_az2      = "10.0.128.0/24"
          web_subnet_az2          = "10.0.129.0/24"
          db_subnet_az2           = "10.0.130.0/24"
          on_prem_cidr_block      = ""
          map_public_ip_on_launch = true
          tags = {
            Name = "Web Application VPC"
          }
        }
      }
    }
    "bastion" = {
      vpc = {
        values = {
          cidr_block              = "10.1.0.0/16"
          public_subnet_az1       = "10.1.0.0/24"
          private_subnet_az1      = ""
          web_subnet_az1          = ""
          db_subnet_az1           = ""
          public_subnet_az2       = "10.1.128.0/24"
          private_subnet_az2      = ""
          web_subnet_az2          = ""
          db_subnet_az2           = ""
          map_public_ip_on_launch = false
          on_prem_cidr_block      = "192.168.0.0/16"
          tags = {
            Name = "Bastion VP"
          }
        }
      }
    }
    "poc" = {
      vpc = {
        values = {
          cidr_block              = "10.250.0.0/16"
          public_subnet_az1       = "10.250.0.0/24"
          private_subnet_az1      = "10.250.1.0/24"
          web_subnet_az1          = ""
          db_subnet_az1           = ""
          public_subnet_az2       = "10.250.128.0/24"
          private_subnet_az2      = "10.250.129.0/24"
          web_subnet_az2          = ""
          db_subnet_az2           = ""
          map_public_ip_on_launch = false
          on_prem_cidr_block      = ""
          tags = {
            Name = "Proof of Concept VPC"
          }
        }
      }
    }
  }
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-2"
}
