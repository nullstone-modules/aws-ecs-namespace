variable "override" {
  type    = string
  default = ""

  description = <<EOF
By default, a private domain is created using {{ NULLSTONE_ENV }}.
The override variable allows you to change the private domain.
This is helpful if you have multiple clusters and namespaces in a single stack.
EOF
}
