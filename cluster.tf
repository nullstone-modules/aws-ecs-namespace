data "ns_connection" "cluster" {
  name     = "cluster"
  contract = "cluster/aws/ecs:ec2"
}

locals {
  capacity_provider_name = data.ns_connection.cluster.outputs.capacity_provider_name

  cluster_arn    = local.is_preview_env ? aws_ecs_cluster.namespace[0].arn : data.ns_connection.cluster.outputs.cluster_arn
  cluster_name   = local.is_preview_env ? aws_ecs_cluster.namespace[0].name : data.ns_connection.cluster.outputs.cluster_name
  deployers_name = local.is_preview_env ? aws_iam_group.deployers[0].name : data.ns_connection.cluster.outputs.deployers_name
}

resource "aws_ecs_cluster" "namespace" {
  count = local.is_preview_env ? 1 : 0

  name = local.resource_name
  tags = local.tags

  // TODO: Enable execute command with encryption configured on logging

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  count = local.is_preview_env ? 1 : 0

  cluster_name       = aws_ecs_cluster.namespace[count.index].name
  capacity_providers = [local.capacity_provider_name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = local.capacity_provider_name
  }
}
