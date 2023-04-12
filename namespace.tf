locals {
  namespace = local.env_name
}

resource "aws_service_discovery_private_dns_namespace" "service" {
  name = local.namespace
  vpc  = local.vpc_id
  tags = local.tags
}
