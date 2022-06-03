resource "google_pubsub_topic" "main" {
  name                       = var.md_metadata.name_prefix
  labels                     = var.md_metadata.default_tags
  message_retention_duration = "${var.message_retention_duration_seconds}s"
  depends_on = [
    module.apis
  ]
}
