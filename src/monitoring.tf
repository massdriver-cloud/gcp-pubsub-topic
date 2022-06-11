
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
  source        = "github.com/massdriver-cloud/terraform-modules//gcp-monitoring-utilization-threshold?ref=3ec7921"
  md_metadata   = var.md_metadata
  message       = "PubSub Topic ${var.md_metadata.name_prefix} is above retainedBytes threshold of ${local.threshold_retained_bytes}"
  alarm_name    = "${google_pubsub_topic.main.id}-retainedBytes"
  metric_type   = local.metrics["retained_bytes"].metric
  resource_type = local.metrics["retained_bytes"].resource
  threshold     = local.threshold_retained_bytes
  period        = 60
  duration      = 60

  depends_on = [
    google_pubsub_topic.main
  ]
}
