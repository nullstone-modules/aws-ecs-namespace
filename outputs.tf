output "cluster_arn" {
  value       = local.cluster_arn
  description = "string ||| AWS Arn for the Fargate cluster."
}

output "cluster_name" {
  value       = local.cluster_name
  description = "string ||| Name of the Fargate cluster."
}

output "deployers_name" {
  value       = local.deployers_name
  description = "string ||| Name of the deployers IAM Group that is allowed to deploy to the Fargate cluster."
}

output "namespace" {
  value       = local.namespace
  description = "string ||| The service discovery namespace"
}

output "service_discovery_id" {
  value       = aws_service_discovery_private_dns_namespace.service.id
  description = "string ||| "
}
