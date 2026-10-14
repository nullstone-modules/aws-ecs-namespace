// Preview envs run on a cluster owned by this namespace, so the task execution history log lives here too.
// See the cluster module for why this is per cluster: EventBridge needs a CloudWatch Logs resource policy
// and AWS allows only 10 per region per account.
resource "aws_cloudwatch_log_group" "executions" {
  count = local.is_preview_env ? 1 : 0

  name              = "${local.resource_name}-executions"
  retention_in_days = var.executions_retention_in_days
  tags              = local.tags
}

locals {
  // Provider versions differ on whether log group ARNs carry a trailing ":*"; normalize.
  executions_log_group_arn  = local.is_preview_env ? trimsuffix(aws_cloudwatch_log_group.executions[0].arn, ":*") : ""
  executions_log_group_name = local.is_preview_env ? aws_cloudwatch_log_group.executions[0].name : try(data.ns_connection.cluster.outputs.executions_log_group_name, "")
}

resource "aws_cloudwatch_event_rule" "executions" {
  count = local.is_preview_env ? 1 : 0

  name        = "${local.resource_name}-executions"
  description = "Task state changes for ECS cluster ${aws_ecs_cluster.namespace[count.index].name}"
  tags        = local.tags

  event_pattern = jsonencode({
    source        = ["aws.ecs"]
    "detail-type" = ["ECS Task State Change"]
    detail        = { clusterArn = [aws_ecs_cluster.namespace[count.index].arn] }
  })
}

resource "aws_cloudwatch_event_target" "executions" {
  count = local.is_preview_env ? 1 : 0

  rule = aws_cloudwatch_event_rule.executions[count.index].name
  arn  = local.executions_log_group_arn
}

resource "aws_cloudwatch_log_resource_policy" "executions" {
  count = local.is_preview_env ? 1 : 0

  policy_name     = "${local.resource_name}-executions"
  policy_document = data.aws_iam_policy_document.executions_log_policy[count.index].json
}

data "aws_iam_policy_document" "executions_log_policy" {
  count = local.is_preview_env ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${local.executions_log_group_arn}:*"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "delivery.logs.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudwatch_event_rule.executions[count.index].arn]
    }
  }
}
