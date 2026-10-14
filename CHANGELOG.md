# 0.3.0 (Oct 14, 2026)
* Recorded ECS task state-change events for preview clusters in a `<cluster>-executions` CloudWatch log group so Nullstone can show task-app execution history past ECS's one-hour retention.
* Added `executions_retention_in_days` (default 90, preview clusters only) and output `executions_log_group_name`, which passes through from the connected cluster outside preview environments.
* Granted preview deployers read access to the executions log group.

# 0.2.0 (Jun 25, 2026)
* Upgraded `ns` provider to `0.11.1`.
* Switched to `aws_tags` for proper resource attribution.

# 0.1.6 (Feb 10, 2026)
* Fixed syntax of deployers policy.

# 0.1.5 (Feb 10, 2026)
* Use cluster deployers policy if no preview env.

# 0.1.4 (Feb 10, 2026)
* Added deployers IAM policy.

# 0.1.3 (Aug 01, 2023)
* Fixed issue with count.

# 0.1.2 (Aug 01, 2023)
* Updated all the providers for all platforms.

# 0.1.1 (Aug 01, 2023)
* Updated the nullstone provider dependency.

# 0.1.0 (Jul 25, 2023)
* Initial release.
