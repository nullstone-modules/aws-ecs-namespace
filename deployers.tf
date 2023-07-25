resource "aws_iam_group" "deployers" {
  count = local.is_preview_env ? 1 : 0

  name = "deployers-${local.resource_name}"
}

resource "aws_iam_group_policy" "deployers" {
  count = local.is_preview_env ? 1 : 0

  name   = "deployers-${local.resource_name}"
  group  = aws_iam_group.deployers[count.index].id
  policy = data.aws_iam_policy_document.deployer[count.index].json
}

data "aws_iam_policy_document" "deployer" {
  count = local.is_preview_env ? 1 : 0

  statement {
    sid    = "AllowEditTaskDefinitions"
    effect = "Allow"

    actions = [
      "ecs:ListTaskDefinitions",
      "ecs:DescribeTaskDefinition",
      "ecs:RegisterTaskDefinition",
      "ecs:DeregisterTaskDefinition",
    ]

    resources = ["*"]
  }

  statement {
    sid       = "AllowHealthMonitor"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:Describe*"
    ]
  }

  #bridgecrew:skip=CKV_AWS_111: Skipping "Write IAM policies without constraints". False positive because the actions are constrained by cluster in the "condition"
  statement {
    sid    = "AllowClusterUpdates"
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "ecs:*Tasks",
      "ecs:RunTask",
      "ecs:ExecuteCommand",
    ]

    resources = ["*"]

    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"
      values   = [aws_ecs_cluster.namespace[count.index].arn]
    }
  }
}
