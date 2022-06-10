
locals {
  threshold_retained_bytes = var.monitoring_configuration.retained_bytes_above

  metrics = {
    "retained_bytes" = {
      metric   = "pubsub.googleapis.com/topic/retained_bytes"
      resource = "pubsub_topic"
    }
  }
}

module "topic_bytes_alarm" {
  count                          = var.monitoring_configuration.enabled ? 1 : 0
  source                         = "github.com/massdriver-cloud/terraform-modules//google-monitoring-utilization-threshold?ref=9201b9f"
  md_metadata                    = var.md_metadata
  message                        = "PubSub Topic ${var.md_metadata.name_prefix} is above retainedBytes threshold of ${local.threshold_retained_bytes}"
  alarm_notification_channel_grn = var.md_metadata.observability.alarm_channels.gcp.id
  alarm_name                     = "${google_pubsub_topic.main.id}-retainedBytes"
  metric_type                    = local.metrics["retained_bytes"].metric
  resource_type                  = local.metrics["retained_bytes"].resource
  threshold                      = local.threshold_retained_bytes
  period                         = 60
  duration                       = 60

  depends_on = [
    google_pubsub_topic.main
  ]
}
