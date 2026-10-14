# ECS Namespace

A Terraform module to create a Nullstone cluster namespace for containers running on AWS ECS.

Preview environments get their own cluster here, including the `<cluster>-executions` log group of ECS task
state-change events (`executions_retention_in_days`, default 30) that backs task-app execution history.
