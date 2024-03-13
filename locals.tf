locals {
  aws_region   = "us-east-1"
  company      = "sbc"
  product      = "orbika"
  environment  = var.branch_name

  vpc_dev_id            = "vpc-00793d68bfdbc5afd"
  subnet_private_dev_a  = "subnet-08f74d75acbf0c94a"
  subnet_private_dev_b  = "subnet-028f9d7e02a452ed3"
  security_group_dev_id = "sg-0f5e93ac3ec6f4e9a"

  vpc_stg_id            = "vpc-06f95fd253c5daf4a"
  subnet_private_stg_a  = "subnet-037c8087ae7ea9288"
  subnet_private_stg_b  = "subnet-0d61f3e7ce378deab"
  security_group_stg_id = "sg-0409e3f3f41b9cd1c"

  vpc_pro_id            = "vpc-02f90d3b4b8934f49"
  subnet_private_pro_a  = "subnet-0f2ac161125f08e16"
  subnet_private_pro_b  = "subnet-0e34c140680c300a2"
  security_group_pro_id = "sg-08f5710091ac685c0"

  /*The CPU and Memory variables for task definitions should be the following defaults.
  Note: For FARGATE-hosted tasks, see for valid CPU and memory combinations (value in MB)
  Note: For the stage and production environment, 2 tasks will be executed in parallel.*/

  task_definition_cpu_dev    = 1024
  task_definition_memory_dev = 2048
  task_definition_cpu_stg    = 1024
  task_definition_memory_stg = 2048
  task_definition_cpu_pro    = 2048
  task_definition_memory_pro = 4096

  container_image_uri_dev = "994761427656.dkr.ecr.us-east-1.amazonaws.com/sbc-subocol-dev-purchase-notice-ecr:latest"
  container_image_uri_stg = "563265230469.dkr.ecr.us-east-1.amazonaws.com/sbc-subocol-stage-purchase-notice-ecr:latest"
  container_image_uri_pro = "383012975894.dkr.ecr.us-east-1.amazonaws.com/sbc-subocol-pro-purchase-notice-ecr:latest"

  id_account_dev = "994761427656"
  id_account_stg = "563265230469"
  id_account_pro = "383012975894"

  vpc_id                 = var.branch_name == "dev" ? local.vpc_dev_id : var.branch_name == "stg" ? local.vpc_stg_id : var.branch_name == "pro" ? local.vpc_pro_id : ""
  subnet_private_a       = var.branch_name == "dev" ? local.subnet_private_dev_a : var.branch_name == "stg" ? local.subnet_private_stg_a : var.branch_name == "pro" ? local.subnet_private_pro_a : ""
  subnet_private_b       = var.branch_name == "dev" ? local.subnet_private_dev_b : var.branch_name == "stg" ? local.subnet_private_stg_b : var.branch_name == "pro" ? local.subnet_private_pro_b : ""
  security_group_id      = var.branch_name == "dev" ? local.security_group_dev_id : var.branch_name == "stg" ? local.security_group_stg_id : var.branch_name == "pro" ? local.security_group_pro_id : ""
  task_definition_cpu    = var.branch_name == "dev" ? local.task_definition_cpu_dev : var.branch_name == "stg" ? local.task_definition_cpu_stg : var.branch_name == "pro" ? local.task_definition_cpu_pro : ""
  task_definition_memory = var.branch_name == "dev" ? local.task_definition_memory_dev : var.branch_name == "stg" ? local.task_definition_memory_stg : var.branch_name == "pro" ? local.task_definition_memory_pro : ""
  container_image_URI    = var.branch_name == "dev" ? local.container_image_uri_dev : var.branch_name == "stg" ? local.container_image_uri_stg : var.branch_name == "pro" ? local.container_image_uri_pro : ""
  id_account_aws         = var.branch_name == "dev" ? local.id_account_dev : var.branch_name == "stg" ? local.id_account_stg : var.branch_name == "pro" ? local.id_account_pro : ""


  tags = {
    origin     = "terraform"
    enviroment = var.branch_name
    project    = "orbika"
  }
}
