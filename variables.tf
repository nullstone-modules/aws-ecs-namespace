variable "override" {
  type    = string
  default = ""

  description = <<EOF
By default, a private domain is created using {{ NULLSTONE_ENV }}.
The override variable allows you to change the private domain.
This is helpful if you have multiple clusters and namespaces in a single stack.
EOF
}

variable "executions_retention_in_days" {
  type        = number
  default     = 90
  description = <<EOF
The number of days to keep ECS task state-change events for a preview cluster.
This is how far back Nullstone can show execution history for task apps.
Ignored outside preview environments; the connected cluster owns the setting there.
EOF

  validation {
    condition     = var.executions_retention_in_days >= 1
    error_message = "executions_retention_in_days must be at least 1 day"
  }
}
