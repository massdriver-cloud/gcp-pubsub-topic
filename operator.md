## Google Cloud Pub/Sub

Google Cloud Pub/Sub is a messaging service that allows you to send and receive messages between independent applications. It provides durable message storage and real-time event delivery, enabling you to decouple services that produce events from services that process events.

### Design Decisions

- **Resource Naming:** Each Pub/Sub topic is named using a prefix specified in the `md_metadata` variable to ensure uniqueness and proper identification within the project.
- **IAM Configuration:** IAM roles are assigned conditionally based on the resource name, enhancing security by applying least privilege principles.
- **Retention Policies:** The message retention duration is configurable to maintain a balance between cost and data availability.
- **Monitoring and Alarms:** Includes monitoring and alerting mechanisms for retained bytes to prevent storage issues.
- **Dependencies Management:** Ensures that necessary API services are enabled before creating the Pub/Sub topic.
  
### Runbook

#### The Pub/Sub Topic Does Not Exist

If a Pub/Sub topic is not found, you need to verify its existence.

```sh
gcloud pubsub topics list --project=[PROJECT_ID]
```

Replace `[PROJECT_ID]` with your actual Google Cloud Project ID. This command lists all the Pub/Sub topics under the specified project. Verify if your topic is listed.

#### IAM Binding Issues

If users or services are having issues publishing or subscribing, verify their IAM roles.

```sh
gcloud pubsub topics get-iam-policy [TOPIC_ID] --project=[PROJECT_ID]
```

Replace `[TOPIC_ID]` and `[PROJECT_ID]` with your actual topic ID and Google Cloud Project ID, respectively. This command retrieves the IAM policy for the specified topic, allowing you to verify if the necessary permissions are assigned.

#### Topic Retained Bytes Alarm Triggered

If an alert for excessive retained bytes is triggered, you should first inspect the current usage metrics.

```sh
gcloud pubsub topics describe [TOPIC_ID] --project=[PROJECT_ID]
```

This command provides the current configuration and status of the specified Pub/Sub topic. Check the `retained_bytes` field to compare it against your threshold.

#### Excessive Message Retention

To reduce retained bytes, consider updating the message retention duration or manually purging messages.

```sh
gcloud pubsub topics update [TOPIC_ID] --message-retention-duration=[DURATION] --project=[PROJECT_ID]
```

Replace `[DURATION]` with the desired retention period in seconds (e.g., `3600s` for 1 hour). This command updates the message retention duration for the specified Pub/Sub topic.

#### Verifying API Enablement

Ensure that the Pub/Sub API is enabled to avoid issues related to missing services.

```sh
gcloud services list --enabled --project=[PROJECT_ID]
```

This command lists all enabled services in the specified Google Cloud Project. Verify that `pubsub.googleapis.com` is included in the list. If it's not, enable it:

```sh
gcloud services enable pubsub.googleapis.com --project=[PROJECT_ID]
```

Enabling the necessary API ensures the Pub/Sub service can operate correctly.

