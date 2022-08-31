locals {
  data_infrastructure = {
    grn = google_pubsub_topic.main.id
  }

  data_security = {
    iam = {
      publisher = {
        role          = "roles/pubsub.publisher"
        condition = "resource.name.endsWith(\"${var.md_metadata.name_prefix}\")"
      }
    }

  specs_topic = {
    distribution = "pubsub"
  }

  artifact_topic = {
    data = {
      infrastructure = local.data_infrastructure
      security       = local.data_security
    }
    specs = {
      topic = local.specs_topic
    }
  }
}

resource "massdriver_artifact" "topic" {
  field                = "topic"
  provider_resource_id = google_pubsub_topic.main.id
  name                 = "GCP PubSub Topic ${var.md_metadata.name_prefix} (${google_pubsub_topic.main.id})"
  artifact             = jsonencode(local.artifact_topic)
}
