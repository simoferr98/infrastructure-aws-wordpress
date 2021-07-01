# _Infrastructure-aws-WordPress_
Creating an infrastructure to host Wordpress on AWS that must be scalable and highly reliable using the Infrastructure as Code (IaC) approach. All the components that compose it are managed by AWS, the effort to configure and manage the application is minimal.

## Infrastructure consists of the following components:
![infrastructure-aws-wordpres](infrastructure-aws-wordpres.png)
- **VPC**
  *Amazon Virtual Private Cloud (Amazon VPC) is a service that lets you launch AWS resources in a logically isolated virtual network.*
- **Security-Group**
 *Security group acts as a virtual firewall for your instance to control inbound and outbound traffic.*
- **IAM**
  *The AWS Identity and Access Management system*
- **Application Elastic Load Balancer**
  *Elastic Load Balancing (Amazon ALB) automatically distributes incoming application.*
- **Elastic File System**
  *Amazon Elastic File System (Amazon EFS) offre un file system semplice, serverless, impostabile in maniera permanente ed elastico che consente di condividere i dati dei file senza occuparsi del provisioning o della gestione dello storage.*
- **Systems Manager Parameter Store**
  *Parameter Store, a capability of AWS Systems Manager, provides secure, hierarchical storage for configuration data management and secrets management.*
- **RDS Amazon Aurora**
  *Amazon Aurora is a MySQL compatible relational database built for the cloud, that combines the performance and availability of traditional enterprise databases with the simplicity and cost-effectiveness of open source databases.*
- **Cloudwatch**
  *The managed AWS Service to monitor the infrastructure components and automate some aspect (eg. Autoscaling) of them*
- **Elastic Container Service** 
  *Amazon Elastic Container Service (Amazon ECS) is a fully managed container orchestration service that helps you easily deploy, manage, and scale containerized applications.*

## Deployment method:
[***Terraform***](https://www.terraform.io/) is used to create infrastructure using the IaC allows developers to use a configuration language called HCL (HashiCorp Configuration Language) to describe the infrastructure using different [module Terraform](https://registry.terraform.io/browse/modules?provider=aws)  tested to optimize the amount of code needed to provision the infrastructure. [***Terragrunt***](https://terragrunt.gruntwork.io/) was  used as a wrapper to add various functions.

In the Repository each single component is declared inside a dedicated folder which contains the files needed by terraform to create the resource. Using Terragrunt we can manage the dependencies between the various components and create all the necessary resources (S3 buckets and DynamoDB tables) to use a [remote state](https://www.terraform.io/docs/language/state/remote.html) for Terraform.

---
## Configure environment:

### System requirements

- AWS IAM user credentials to access the account with sufficient permissions to create, update and destroy the AWS resources defined in this infrastructure. 
- [AWS CLI (v2)](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Terraform](https://www.terraform.io/downloads.html) (1.0+)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) (0.31+)

### Secret
The code contains the following sensitive input variables which must not be versioned in the repository. 
They can be entered manually before Terraform / Terragrunt is started or they can be passed to Terraform using a local .tfvars

|Name|Description|Type|
|----|-----------|----|
|usernamedb|The username of admin user of Aurora database|string|
|passwordb|The password of admin user of Aurora database|string|

### Environment Variables
Several variables are used to parameterize the architecture. The variables are defined in varriable/common.sh

|Name|Description|Type|Default|
|----|-----------|----|-----------------------|
|project_name|The name of the project|string|wordpress|
|region|The AWS Region to create the infrastructure|string|eu-central-1|
|vpc_azs|A list of availability zones names or ids in the region|list of strings|["eu-central-1a", "eu-central-1b", "eu-central-1c"]|
|database_name|Name of the database hosted on the RDS instance|string|["eu-central-1a", "eu-central-1b","eu-central-1c"]|
|container_port|The container port on which expose the service|number|80
|container_name|The name of the container|string|wp-app
|vpc_01_vpc_cidr|The CIDR block of your VPC|string|13.0.0.0/16|
|vpc_01_public_subnets_value|The CIDR of public subnets|list of strings|["13.0.0.0/22","13.0.8.0/22","13.0.4.0/22"]|
|vpc_01_private_subnets_value|The CIDR of private subnets|list of strings|["13.0.32.0/21","13.0.40.0/21","13.0.48.0/21"]|
|vpc_01_database_subnets_value|The CIDR of private subnets|list of strings|["13.0.64.0/23","13.0.66.0/23","13.0.68.0/23"]|
|rds_01_family|The family of the DB parameter group|string|aurora-mysql5.7
|rds_01_engine|Aurora database engine type, currently aurora|string|aurora-mysql
|rds_01_replica_scale_enabled|Whether to enable autoscaling for RDS Aurora (MySQL) read replicas|bool|false
|rds_01_replica_count|Number of reader nodes to create|number|0
|rds_01_scaling_configuration_db_autopause|Enabled automatic pause Aurora DB cluster if idle|boolean|false
|rds_01_scaling_configuration_db_min_capacity|Minimum ACU (Aurora Capacity Unit) for Aurora Cluster|number|2
|rds_01_scaling_configuration_db_max_capacity|Maximum ACU (Aurora Capacity Unit) for Aurora Cluster|number|4
|rds_01_scaling_configuration_db_autopause_after_seconds|Amount of time (in seconds) with no activity before the Aurora DB cluster is paused|number|3600
|rds_01_timeout_action|The action to take when the timeout is reached|string|RollbackCapacityChange
|rds_01_deletion_protection|The DB instance should have deletion protection enabled|bool|true
|rds_01_storage_encrypted|Specifies whether the underlying storage layer should be encrypted|bool|true
|cloudwatch_log_group_01_log_retention_in_days|The default retention of Cloudwatch log groups used by some service|number|7
|task_definition_01_task_cpu|[The CPU size of each ECS task|number|1024|
|task_definition_01_task_memory|[The memory size of each ECS task|number|2048|
|task_definition_01_container_image_url|The Image to use in ECS tasks|string|wordpress:5.7.2-php7.3-apache|
|service_ecs_01_desired_count|[The initial desired number of tasks of ECS Service|number|2|
|appautoscaling_target_01_min_capacity|The minimum capacity of ECS Service Autoscaling|number|2|
|appautoscaling_target_01_max_capacit|The minimum capacity of ECS Service Autoscaling|number|10|
|appautoscaling_target_01_ecs_service_autoscaling_cpu_average_utilization_target|The average % of CPU utilization used in Target Tracking Scaling Policy of ECS Service|number|50|
|appautoscaling_target_01_ecs_service_autoscaling_scale_in_cooldown|Cooldown (in seconds) to scale in for ECS Service Autoscaling|number|500|
|appautoscaling_target_01_ecs_service_autoscaling_scale_out_cooldown|Cooldown (in seconds) to scale out for ECS Service Autoscaling|number|500|

### Authentication
Set up an AWS CLI profile, it will be used by Terraform to authenticate with your AWS account
An example of configuring a profile
```
$ aws configure --profile simoneferraro
AWS Access Key ID [None]: ***
AWS Secret Access Key [None]: ***
Default region name [None]: eu-central-1
Default output format [None]: json
```
Export the AWS_PROFILE environment variable, enhancing it with the profile name
```
$ export AWS_PROFILE=simoneferraro
```
---

## Create Environment

1. Export the environment variables `infrastructure-aws-wordpress/variables/common.sh` path to your console:
```
$ source infrastructure-aws-wordpress/variables/common.sh
```
2. Move to the folder of the component we want to create Example:`infrastructure-aws-wordpress/common/name_resource`
```
$ cd infrastructure-aws-wordpress/common/vpc
```
3. Run `terragrunt init`  is used to initialize working directory containing Terraform configuration files.
Perform the same procedure for all resource of the project
Example of output:
```
$  terragrunt init
Remote state S3 bucket 813082851861-wordpress-eu-central-1-terraform-state does not exist or you don't have permissions to access it. Would you like Terragrunt to create it? (y/n) y
Initializing modules...
Downloading terraform-aws-modules/vpc/aws 3.1.0 for vpc_01...
- vpc_01 in .terraform/modules/vpc_01

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Installing hashicorp/aws v3.47.0...
- Installed hashicorp/aws v3.47.0 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```
4. Run the `terragrunt plan` command which creates an execution plan.
Perform the same procedure for all resource of the project
Example of output:
```
$ terragrunt plan

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.vpc_01.aws_eip.nat[0] will be created
  + resource "aws_eip" "nat" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = (known after apply)
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
      + tags_all             = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
      + vpc                  = true
    }

  # module.vpc_01.aws_eip.nat[1] will be created
  + resource "aws_eip" "nat" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = (known after apply)
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
      + tags_all             = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
      + vpc                  = true
    }

  # module.vpc_01.aws_eip.nat[2] will be created
  + resource "aws_eip" "nat" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = (known after apply)
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
      + tags_all             = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
      + vpc                  = true
    }

  # module.vpc_01.aws_internet_gateway.this[0] will be created
  + resource "aws_internet_gateway" "this" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc"
          + "Progetto"  = "wordpress"
        }
      + tags_all = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc"
          + "Progetto"  = "wordpress"
        }
      + vpc_id   = (known after apply)
    }

  # module.vpc_01.aws_nat_gateway.this[0] will be created
  + resource "aws_nat_gateway" "this" {
      + allocation_id        = (known after apply)
      + connectivity_type    = "public"
      + id                   = (known after apply)
      + network_interface_id = (known after apply)
      + private_ip           = (known after apply)
      + public_ip            = (known after apply)
      + subnet_id            = (known after apply)
      + tags                 = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
      + tags_all             = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
    }

  # module.vpc_01.aws_nat_gateway.this[1] will be created
  + resource "aws_nat_gateway" "this" {
      + allocation_id        = (known after apply)
      + connectivity_type    = "public"
      + id                   = (known after apply)
      + network_interface_id = (known after apply)
      + private_ip           = (known after apply)
      + public_ip            = (known after apply)
      + subnet_id            = (known after apply)
      + tags                 = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
      + tags_all             = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
    }

  # module.vpc_01.aws_nat_gateway.this[2] will be created
  + resource "aws_nat_gateway" "this" {
      + allocation_id        = (known after apply)
      + connectivity_type    = "public"
      + id                   = (known after apply)
      + network_interface_id = (known after apply)
      + private_ip           = (known after apply)
      + public_ip            = (known after apply)
      + subnet_id            = (known after apply)
      + tags                 = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
      + tags_all             = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
    }

  # module.vpc_01.aws_route.private_nat_gateway[0] will be created
  + resource "aws_route" "private_nat_gateway" {
      + destination_cidr_block = "0.0.0.0/0"
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + nat_gateway_id         = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)

      + timeouts {
          + create = "5m"
        }
    }

  # module.vpc_01.aws_route.private_nat_gateway[1] will be created
  + resource "aws_route" "private_nat_gateway" {
      + destination_cidr_block = "0.0.0.0/0"
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + nat_gateway_id         = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)

      + timeouts {
          + create = "5m"
        }
    }

  # module.vpc_01.aws_route.private_nat_gateway[2] will be created
  + resource "aws_route" "private_nat_gateway" {
      + destination_cidr_block = "0.0.0.0/0"
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + nat_gateway_id         = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)

      + timeouts {
          + create = "5m"
        }
    }

  # module.vpc_01.aws_route.public_internet_gateway[0] will be created
  + resource "aws_route" "public_internet_gateway" {
      + destination_cidr_block = "0.0.0.0/0"
      + gateway_id             = (known after apply)
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)

      + timeouts {
          + create = "5m"
        }
    }

  # module.vpc_01.aws_route_table.private[0] will be created
  + resource "aws_route_table" "private" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
      + tags_all         = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc_01.aws_route_table.private[1] will be created
  + resource "aws_route_table" "private" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
      + tags_all         = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc_01.aws_route_table.private[2] will be created
  + resource "aws_route_table" "private" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
      + tags_all         = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc_01.aws_route_table.public[0] will be created
  + resource "aws_route_table" "public" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-public"
          + "Progetto"  = "wordpress"
        }
      + tags_all         = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-public"
          + "Progetto"  = "wordpress"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc_01.aws_route_table_association.database[0] will be created
  + resource "aws_route_table_association" "database" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc_01.aws_route_table_association.database[1] will be created
  + resource "aws_route_table_association" "database" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc_01.aws_route_table_association.database[2] will be created
  + resource "aws_route_table_association" "database" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc_01.aws_route_table_association.private[0] will be created
  + resource "aws_route_table_association" "private" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc_01.aws_route_table_association.private[1] will be created
  + resource "aws_route_table_association" "private" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc_01.aws_route_table_association.private[2] will be created
  + resource "aws_route_table_association" "private" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc_01.aws_route_table_association.public[0] will be created
  + resource "aws_route_table_association" "public" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc_01.aws_route_table_association.public[1] will be created
  + resource "aws_route_table_association" "public" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc_01.aws_route_table_association.public[2] will be created
  + resource "aws_route_table_association" "public" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc_01.aws_subnet.database[0] will be created
  + resource "aws_subnet" "database" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1a"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "13.0.64.0/23"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + tags                            = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-db-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
      + tags_all                        = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-db-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
      + vpc_id                          = (known after apply)
    }

  # module.vpc_01.aws_subnet.database[1] will be created
  + resource "aws_subnet" "database" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1b"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "13.0.66.0/23"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + tags                            = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-db-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
      + tags_all                        = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-db-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
      + vpc_id                          = (known after apply)
    }

  # module.vpc_01.aws_subnet.database[2] will be created
  + resource "aws_subnet" "database" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1c"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "13.0.68.0/23"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + tags                            = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-db-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
      + tags_all                        = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-db-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
      + vpc_id                          = (known after apply)
    }

  # module.vpc_01.aws_subnet.private[0] will be created
  + resource "aws_subnet" "private" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1a"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "13.0.32.0/21"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + tags                            = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
      + tags_all                        = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
      + vpc_id                          = (known after apply)
    }

  # module.vpc_01.aws_subnet.private[1] will be created
  + resource "aws_subnet" "private" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1b"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "13.0.40.0/21"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + tags                            = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
      + tags_all                        = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
      + vpc_id                          = (known after apply)
    }

  # module.vpc_01.aws_subnet.private[2] will be created
  + resource "aws_subnet" "private" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1c"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "13.0.48.0/21"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + tags                            = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
      + tags_all                        = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-private-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
      + vpc_id                          = (known after apply)
    }

  # module.vpc_01.aws_subnet.public[0] will be created
  + resource "aws_subnet" "public" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1a"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "13.0.0.0/22"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + tags                            = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-public-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
      + tags_all                        = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-public-eu-central-1a"
          + "Progetto"  = "wordpress"
        }
      + vpc_id                          = (known after apply)
    }

  # module.vpc_01.aws_subnet.public[1] will be created
  + resource "aws_subnet" "public" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1b"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "13.0.8.0/22"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + tags                            = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-public-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
      + tags_all                        = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-public-eu-central-1b"
          + "Progetto"  = "wordpress"
        }
      + vpc_id                          = (known after apply)
    }

  # module.vpc_01.aws_subnet.public[2] will be created
  + resource "aws_subnet" "public" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1c"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "13.0.4.0/22"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + tags                            = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-public-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
      + tags_all                        = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc-public-eu-central-1c"
          + "Progetto"  = "wordpress"
        }
      + vpc_id                          = (known after apply)
    }

  # module.vpc_01.aws_vpc.this[0] will be created
  + resource "aws_vpc" "this" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "13.0.0.0/16"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = true
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
      + tags                             = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc"
          + "Progetto"  = "wordpress"
        }
      + tags_all                         = {
          + "ManagedBy" = "terraform"
          + "Name"      = "wordpress-vpc"
          + "Progetto"  = "wordpress"
        }
    }

Plan: 34 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + vpc_01_database_subnets = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
  + vpc_01_id               = (known after apply)
  + vpc_01_name             = "wordpress-vpc"
  + vpc_01_private_subnets  = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
  + vpc_01_public_subnets   = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
```
5. Run the `terragrunt apply` command to create the resources and answer" yes "to confirm the operation.
Take note of the output values ​​after the `terragrunt apply`.
Perform the same procedure for all resource of the project
Example of output:
```
$ Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.vpc_01.aws_eip.nat[1]: Creating...
module.vpc_01.aws_eip.nat[0]: Creating...
module.vpc_01.aws_eip.nat[2]: Creating...
module.vpc_01.aws_vpc.this[0]: Creating...
module.vpc_01.aws_eip.nat[0]: Creation complete after 0s [id=eipalloc-3a485205]
module.vpc_01.aws_eip.nat[2]: Creation complete after 0s [id=eipalloc-ed405ad2]
module.vpc_01.aws_eip.nat[1]: Creation complete after 0s [id=eipalloc-97475da8]
module.vpc_01.aws_vpc.this[0]: Still creating... [10s elapsed]
module.vpc_01.aws_vpc.this[0]: Creation complete after 13s [id=vpc-0b74fbb24c65cc15e]
module.vpc_01.aws_subnet.public[2]: Creating...
module.vpc_01.aws_route_table.private[0]: Creating...
module.vpc_01.aws_subnet.public[0]: Creating...
module.vpc_01.aws_subnet.database[0]: Creating...
module.vpc_01.aws_route_table.private[2]: Creating...
module.vpc_01.aws_subnet.database[1]: Creating...
module.vpc_01.aws_subnet.public[1]: Creating...
module.vpc_01.aws_route_table.public[0]: Creating...
module.vpc_01.aws_subnet.database[2]: Creating...
module.vpc_01.aws_subnet.private[2]: Creating...
module.vpc_01.aws_route_table.public[0]: Creation complete after 0s [id=rtb-0f41c4c9272218451]
module.vpc_01.aws_route_table.private[1]: Creating...
module.vpc_01.aws_route_table.private[2]: Creation complete after 0s [id=rtb-0e8b941ec2953d6a1]
module.vpc_01.aws_subnet.private[0]: Creating...
module.vpc_01.aws_route_table.private[0]: Creation complete after 0s [id=rtb-06829c415640cff41]
module.vpc_01.aws_internet_gateway.this[0]: Creating...
module.vpc_01.aws_subnet.database[1]: Creation complete after 1s [id=subnet-0eea3207f130881f8]
module.vpc_01.aws_subnet.private[1]: Creating...
module.vpc_01.aws_subnet.database[0]: Creation complete after 1s [id=subnet-0abcfc1f162d347fc]
module.vpc_01.aws_subnet.database[2]: Creation complete after 1s [id=subnet-03cd8af0de7a0ad55]
module.vpc_01.aws_subnet.private[2]: Creation complete after 1s [id=subnet-033520456041e76c4]
module.vpc_01.aws_route_table.private[1]: Creation complete after 1s [id=rtb-0ea88f2457ecdcb1e]
module.vpc_01.aws_route_table_association.database[0]: Creating...
module.vpc_01.aws_route_table_association.database[2]: Creating...
module.vpc_01.aws_route_table_association.database[1]: Creating...
module.vpc_01.aws_subnet.private[0]: Creation complete after 1s [id=subnet-08cf88c66aa61ec38]
module.vpc_01.aws_internet_gateway.this[0]: Creation complete after 1s [id=igw-0973ea1f94fb1ab14]
module.vpc_01.aws_route.public_internet_gateway[0]: Creating...
module.vpc_01.aws_subnet.private[1]: Creation complete after 0s [id=subnet-070b1efc2da1f9a24]
module.vpc_01.aws_route_table_association.database[2]: Creation complete after 0s [id=rtbassoc-00f1db1710f1fb8c5]
module.vpc_01.aws_route_table_association.database[1]: Creation complete after 0s [id=rtbassoc-0eea2c3c40d0782a3]
module.vpc_01.aws_route_table_association.private[1]: Creating...
module.vpc_01.aws_route_table_association.private[2]: Creating...
module.vpc_01.aws_route_table_association.private[0]: Creating...
module.vpc_01.aws_route_table_association.database[0]: Creation complete after 0s [id=rtbassoc-027036699413d205a]
module.vpc_01.aws_route_table_association.private[1]: Creation complete after 1s [id=rtbassoc-0564d635d39dd5d7b]
module.vpc_01.aws_route_table_association.private[0]: Creation complete after 1s [id=rtbassoc-089a7dd80c06526f8]
module.vpc_01.aws_route_table_association.private[2]: Creation complete after 1s [id=rtbassoc-0f0799de4c1fb6f05]
module.vpc_01.aws_route.public_internet_gateway[0]: Creation complete after 1s [id=r-rtb-0f41c4c92722184511080289494]
module.vpc_01.aws_subnet.public[2]: Still creating... [10s elapsed]
module.vpc_01.aws_subnet.public[0]: Still creating... [10s elapsed]
module.vpc_01.aws_subnet.public[1]: Still creating... [10s elapsed]
module.vpc_01.aws_subnet.public[0]: Creation complete after 11s [id=subnet-05190f61dab750923]
module.vpc_01.aws_subnet.public[1]: Creation complete after 11s [id=subnet-04b2d54a3104eb29f]
module.vpc_01.aws_subnet.public[2]: Creation complete after 11s [id=subnet-095bc73e7f59a2c4d]
module.vpc_01.aws_route_table_association.public[0]: Creating...
module.vpc_01.aws_route_table_association.public[1]: Creating...
module.vpc_01.aws_nat_gateway.this[0]: Creating...
module.vpc_01.aws_nat_gateway.this[2]: Creating...
module.vpc_01.aws_route_table_association.public[2]: Creating...
module.vpc_01.aws_nat_gateway.this[1]: Creating...
module.vpc_01.aws_route_table_association.public[2]: Creation complete after 1s [id=rtbassoc-016d6bf02ec0c65b8]
module.vpc_01.aws_route_table_association.public[0]: Creation complete after 1s [id=rtbassoc-005d710a5fe2bd1a2]
module.vpc_01.aws_route_table_association.public[1]: Creation complete after 1s [id=rtbassoc-01d98cb226c9b6f06]
module.vpc_01.aws_nat_gateway.this[0]: Still creating... [10s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still creating... [10s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still creating... [10s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still creating... [20s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still creating... [20s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still creating... [20s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still creating... [30s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still creating... [30s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still creating... [30s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still creating... [40s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still creating... [40s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still creating... [40s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still creating... [50s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still creating... [50s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still creating... [50s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still creating... [1m0s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still creating... [1m0s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still creating... [1m0s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still creating... [1m10s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still creating... [1m10s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still creating... [1m10s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still creating... [1m20s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still creating... [1m20s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still creating... [1m20s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still creating... [1m30s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still creating... [1m30s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still creating... [1m30s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Creation complete after 1m36s [id=nat-05ae28ab99a36c110]
module.vpc_01.aws_nat_gateway.this[1]: Still creating... [1m40s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still creating... [1m40s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Creation complete after 1m47s [id=nat-07ab6ec49b341f51a]
module.vpc_01.aws_nat_gateway.this[1]: Still creating... [1m50s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Creation complete after 1m57s [id=nat-00bac53d4ef94afac]
module.vpc_01.aws_route.private_nat_gateway[2]: Creating...
module.vpc_01.aws_route.private_nat_gateway[1]: Creating...
module.vpc_01.aws_route.private_nat_gateway[0]: Creating...
module.vpc_01.aws_route.private_nat_gateway[0]: Creation complete after 1s [id=r-rtb-06829c415640cff411080289494]
module.vpc_01.aws_route.private_nat_gateway[2]: Creation complete after 1s [id=r-rtb-0e8b941ec2953d6a11080289494]
module.vpc_01.aws_route.private_nat_gateway[1]: Creation complete after 1s [id=r-rtb-0ea88f2457ecdcb1e1080289494]

Apply complete! Resources: 34 added, 0 changed, 0 destroyed.

Outputs:

vpc_01_database_subnets = [
  "subnet-0abcfc1f162d347fc",
  "subnet-0eea3207f130881f8",
  "subnet-03cd8af0de7a0ad55",
]
vpc_01_id = "vpc-0b74fbb24c65cc15e"
vpc_01_name = "wordpress-vpc"
vpc_01_private_subnets = [
  "subnet-08cf88c66aa61ec38",
  "subnet-070b1efc2da1f9a24",
  "subnet-033520456041e76c4",
]
vpc_01_public_subnets = [
  "subnet-05190f61dab750923",
  "subnet-04b2d54a3104eb29f",
  "subnet-095bc73e7f59a2c4d",
]
```

---

## Access the Wordpress installation
Let's try to invoke Wordpress by opening a browser and pointing the retrieved url through the output values `alb_01_lb_dns_name` *http://\<public_dns\>*(wordpres-install.png)

---
## Delete Environment
1. Export the environment variables `infrastructure-aws-wordpress/variables/common.sh` path to your console:
```
$ source infrastructure-aws-wordpress/variables/common.sh
```
2. Move to the folder of the component we want to delete Example:`infrastructure-aws-wordpress/common/name_resource`:
```
$ cd infrastructure-aws-wordpress/common/vpc
```
3. Run `terragrunt destroy` from the root dir of this repository, and answer "yes" to confirm the operation.
Perform the same procedure for all resource of the project

```
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

module.vpc_01.aws_route_table_association.private[0]: Destroying... [id=rtbassoc-089a7dd80c06526f8]
module.vpc_01.aws_route_table_association.database[2]: Destroying... [id=rtbassoc-00f1db1710f1fb8c5]
module.vpc_01.aws_route_table_association.private[2]: Destroying... [id=rtbassoc-0f0799de4c1fb6f05]
module.vpc_01.aws_route_table_association.database[0]: Destroying... [id=rtbassoc-027036699413d205a]
module.vpc_01.aws_route_table_association.public[2]: Destroying... [id=rtbassoc-016d6bf02ec0c65b8]
module.vpc_01.aws_route.private_nat_gateway[1]: Destroying... [id=r-rtb-0ea88f2457ecdcb1e1080289494]
module.vpc_01.aws_route.private_nat_gateway[0]: Destroying... [id=r-rtb-06829c415640cff411080289494]
module.vpc_01.aws_route.private_nat_gateway[2]: Destroying... [id=r-rtb-0e8b941ec2953d6a11080289494]
module.vpc_01.aws_route.public_internet_gateway[0]: Destroying... [id=r-rtb-0f41c4c92722184511080289494]
module.vpc_01.aws_route_table_association.private[1]: Destroying... [id=rtbassoc-0564d635d39dd5d7b]
module.vpc_01.aws_route_table_association.database[2]: Destruction complete after 1s
module.vpc_01.aws_route_table_association.public[1]: Destroying... [id=rtbassoc-01d98cb226c9b6f06]
module.vpc_01.aws_route_table_association.public[2]: Destruction complete after 1s
module.vpc_01.aws_route_table_association.public[0]: Destroying... [id=rtbassoc-005d710a5fe2bd1a2]
module.vpc_01.aws_route_table_association.database[0]: Destruction complete after 1s
module.vpc_01.aws_route_table_association.database[1]: Destroying... [id=rtbassoc-0eea2c3c40d0782a3]
module.vpc_01.aws_route_table_association.private[2]: Destruction complete after 1s
module.vpc_01.aws_route_table_association.private[0]: Destruction complete after 1s
module.vpc_01.aws_route_table_association.private[1]: Destruction complete after 1s
module.vpc_01.aws_subnet.private[2]: Destroying... [id=subnet-033520456041e76c4]
module.vpc_01.aws_subnet.private[0]: Destroying... [id=subnet-08cf88c66aa61ec38]
module.vpc_01.aws_subnet.private[1]: Destroying... [id=subnet-070b1efc2da1f9a24]
module.vpc_01.aws_route.private_nat_gateway[1]: Destruction complete after 1s
module.vpc_01.aws_route.private_nat_gateway[0]: Destruction complete after 1s
module.vpc_01.aws_route.private_nat_gateway[2]: Destruction complete after 1s
module.vpc_01.aws_nat_gateway.this[1]: Destroying... [id=nat-00bac53d4ef94afac]
module.vpc_01.aws_nat_gateway.this[2]: Destroying... [id=nat-05ae28ab99a36c110]
module.vpc_01.aws_nat_gateway.this[0]: Destroying... [id=nat-07ab6ec49b341f51a]
module.vpc_01.aws_route.public_internet_gateway[0]: Destruction complete after 1s
module.vpc_01.aws_route_table_association.public[0]: Destruction complete after 0s
module.vpc_01.aws_route_table_association.public[1]: Destruction complete after 0s
module.vpc_01.aws_route_table_association.database[1]: Destruction complete after 0s
module.vpc_01.aws_route_table.private[1]: Destroying... [id=rtb-0ea88f2457ecdcb1e]
module.vpc_01.aws_route_table.public[0]: Destroying... [id=rtb-0f41c4c9272218451]
module.vpc_01.aws_subnet.database[2]: Destroying... [id=subnet-03cd8af0de7a0ad55]
module.vpc_01.aws_subnet.database[0]: Destroying... [id=subnet-0abcfc1f162d347fc]
module.vpc_01.aws_subnet.private[0]: Destruction complete after 0s
module.vpc_01.aws_route_table.private[2]: Destroying... [id=rtb-0e8b941ec2953d6a1]
module.vpc_01.aws_subnet.private[2]: Destruction complete after 0s
module.vpc_01.aws_subnet.database[1]: Destroying... [id=subnet-0eea3207f130881f8]
module.vpc_01.aws_subnet.private[1]: Destruction complete after 0s
module.vpc_01.aws_route_table.private[0]: Destroying... [id=rtb-06829c415640cff41]
module.vpc_01.aws_route_table.public[0]: Destruction complete after 1s
module.vpc_01.aws_subnet.database[0]: Destruction complete after 1s
module.vpc_01.aws_route_table.private[1]: Destruction complete after 1s
module.vpc_01.aws_subnet.database[2]: Destruction complete after 1s
module.vpc_01.aws_route_table.private[2]: Destruction complete after 1s
module.vpc_01.aws_subnet.database[1]: Destruction complete after 1s
module.vpc_01.aws_route_table.private[0]: Destruction complete after 1s
module.vpc_01.aws_nat_gateway.this[0]: Still destroying... [id=nat-07ab6ec49b341f51a, 10s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still destroying... [id=nat-00bac53d4ef94afac, 10s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still destroying... [id=nat-05ae28ab99a36c110, 10s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still destroying... [id=nat-05ae28ab99a36c110, 20s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still destroying... [id=nat-07ab6ec49b341f51a, 20s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still destroying... [id=nat-00bac53d4ef94afac, 20s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still destroying... [id=nat-00bac53d4ef94afac, 30s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still destroying... [id=nat-07ab6ec49b341f51a, 30s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still destroying... [id=nat-05ae28ab99a36c110, 30s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still destroying... [id=nat-07ab6ec49b341f51a, 40s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still destroying... [id=nat-05ae28ab99a36c110, 40s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still destroying... [id=nat-00bac53d4ef94afac, 40s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still destroying... [id=nat-00bac53d4ef94afac, 50s elapsed]
module.vpc_01.aws_nat_gateway.this[2]: Still destroying... [id=nat-05ae28ab99a36c110, 50s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Still destroying... [id=nat-07ab6ec49b341f51a, 50s elapsed]
module.vpc_01.aws_nat_gateway.this[0]: Destruction complete after 51s
module.vpc_01.aws_nat_gateway.this[2]: Destruction complete after 51s
module.vpc_01.aws_nat_gateway.this[1]: Still destroying... [id=nat-00bac53d4ef94afac, 1m0s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Still destroying... [id=nat-00bac53d4ef94afac, 1m10s elapsed]
module.vpc_01.aws_nat_gateway.this[1]: Destruction complete after 1m12s
module.vpc_01.aws_subnet.public[2]: Destroying... [id=subnet-095bc73e7f59a2c4d]
module.vpc_01.aws_internet_gateway.this[0]: Destroying... [id=igw-0973ea1f94fb1ab14]
module.vpc_01.aws_subnet.public[0]: Destroying... [id=subnet-05190f61dab750923]
module.vpc_01.aws_subnet.public[1]: Destroying... [id=subnet-04b2d54a3104eb29f]
module.vpc_01.aws_eip.nat[2]: Destroying... [id=eipalloc-ed405ad2]
module.vpc_01.aws_eip.nat[1]: Destroying... [id=eipalloc-97475da8]
module.vpc_01.aws_eip.nat[0]: Destroying... [id=eipalloc-3a485205]
module.vpc_01.aws_subnet.public[0]: Destruction complete after 0s
module.vpc_01.aws_subnet.public[2]: Destruction complete after 0s
module.vpc_01.aws_subnet.public[1]: Destruction complete after 0s
module.vpc_01.aws_eip.nat[1]: Destruction complete after 0s
module.vpc_01.aws_eip.nat[2]: Destruction complete after 0s
module.vpc_01.aws_eip.nat[0]: Destruction complete after 0s
module.vpc_01.aws_internet_gateway.this[0]: Still destroying... [id=igw-0973ea1f94fb1ab14, 10s elapsed]
module.vpc_01.aws_internet_gateway.this[0]: Destruction complete after 10s
module.vpc_01.aws_vpc.this[0]: Destroying... [id=vpc-0b74fbb24c65cc15e]
module.vpc_01.aws_vpc.this[0]: Destruction complete after 1s

Destroy complete! Resources: 34 destroyed.
```
4. Remove the S3 bucket of Terraform remote state (created automatically from Terragrunt).
5. Remove the DynamoDB Table for Terraform state locks (created automatically from Terragrunt). 
---

## Create and Delete environment using Terragrunt run-all
### Create Environment
1. Export the environment variables `infrastructure-aws-wordpress/variables/common.sh` path to your console:
```
$ source infrastructure-aws-wordpress/variables/common.sh
```
2. Move to the root folder Example:
```
$ cd infrastructure-aws-wordpress/common
```
3. Run the `terragrunt run-all apply` command to create the resources and answer" yes "to confirm the operation.

### Delete Environment
1. Export the environment variables `infrastructure-aws-wordpress/variables/common.sh` path to your console:
```
$ source infrastructure-aws-wordpress/variables/common.sh
```
2. Move to the root folder Example:
```
$ cd infrastructure-aws-wordpress/common
```
3. Run the `terragrunt run-all destroy` from the root dir of this repository, and answer "yes" to confirm the operation.
4. Remove the S3 bucket of Terraform remote state (created automatically from Terragrunt).
5. Remove the DynamoDB Table for Terraform state locks (created automatically from Terragrunt). 

---
