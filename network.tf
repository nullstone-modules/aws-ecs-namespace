data "ns_connection" "network" {
  name     = "network"
  contract = "network/aws/vpc"
  via      = data.ns_connection.cluster.name
}

locals {
  vpc_id = data.ns_connection.network.outputs.vpc_id
}
