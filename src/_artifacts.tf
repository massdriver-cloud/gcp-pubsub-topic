locals {
  data_infrastructure = {
    grn = google_pubsub_topic.main.id
  }

  data_security = {
    iam = {
      read = {
        role      = "roles/pubsub.viewer"
        condition = "resource.name.startsWith(\"${local.data_infrastructure.grn}\")"
      }
      write = {
        role      = "roles/pubsub.publisher"
        condition = "resource.name.startsWith(\"${local.data_infrastructure.grn}\")"
      }
      edit = {
        role      = "roles/pubsub.editor"
        condition = "resource.name.startsWith(\"${local.data_infrastructure.grn}\")"
      }
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
  type                 = "gcp-pubsub-topic"
  name                 = "GCP PubSub Topic ${var.md_metadata.name_prefix} (${google_pubsub_topic.main.id})"
  artifact             = jsonencode(local.artifact_topic)
}
