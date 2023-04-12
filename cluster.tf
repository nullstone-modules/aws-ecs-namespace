data "ns_connection" "cluster" {
  name     = "cluster"
  contract = "cluster/aws/ecs:*"
}

locals {
  cluster_arn    = data.ns_connection.cluster.outputs.cluster_arn
  cluster_name   = data.ns_connection.cluster.outputs.cluster_name
  deployers_name = data.ns_connection.cluster.outputs.deployers_name
}
