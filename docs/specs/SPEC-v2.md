# Application Specification: Rails 8 Modernization Codelab ("DHH App Spec")

This specification outlines the architecture and requirements for a Rails 8 blog application designed for automated deployment on GCP, emphasizing testing and minimal operational overhead ("babysitting").

-----

## 1\. Core Requirements

  * **Framework:** Rails 8 (latest stable release).
  * **Database:** PostgreSQL, configured for migration to Cloud SQL.
  * **Infrastructure:** Containerized (Docker) for consistent local and cloud execution.
  * **Automation:** Full CI/CD capability via automated setup scripts (Terraform/gcloud).

## 2\. Technical Stack & Features

### A. Application Logic

  * **Models:** `Post` (title, content, published\_at), `Comment` (content, post\_id).
  * **Storage:** Active Storage configured to use Google Cloud Storage (GCS) buckets, not local file storage.
  * **Background Processing:** Solid Queue for asynchronous tasks.

### B. Security & Connectivity

  * **Database Access:** Cloud SQL Proxy for secure, encrypted connections.
  * **Credential Management:** Environment variables (dotenv/GCP Secrets Manager) rather than hardcoded credentials.

## 3\. Automation & Observability (Minimize "Babysitting")

  * **Automated Provisioning:** Scripts must handle GCS bucket creation, Cloud SQL instance setup, and IAM service account configuration.
  * **Self-Healing/Recovery:**
      * Database connection retries for Cloud SQL Proxy.
      * Background worker monitoring (Solid Queue).
  * **"Golden Image" Strategy:** Use a containerized environment (Dockerfile) that eliminates "it works on my machine" issues.

## 4\. Testing & Development Strategy (The Harness)

  * **Test-First Architecture:**
      * System tests for end-to-end user journeys (Create Post -\> Comment -\> Verify).
      * Integration tests for Active Storage and GCS bucket interactions.
  * **Error-Driven Learning:**
      * Configure worker jobs to be intentionally "broken" in the base harness to test automated failure alerts.
  * **Iterative Branching:** Utilize Git tags to provide state snapshots:
      * `start`: Vanilla Rails setup.
      * `v1-cloud-storage`: Integration of GCS.
      * `v2-secure-db`: Cloud SQL Proxy integration.
      * `final`: Fully containerized/deployed Cloud Run instance.

## 5\. Deployment Target

  * **Platform:** Google Cloud Run.
  * **Pipeline Requirements:**
      * Build container image.
      * Push to Artifact Registry.
      * Deploy to Cloud Run (Service Account-based permissions).

-----

### Instructions for Coding Harness

  * **Initialization:** Scaffold with `rails new blog --database=postgresql --css=tailwind`.
  * **Environment:** Wrap the local development environment in `docker-compose`.
  * **Infrastructure as Code:** Include `terraform` files for provisioning the cloud infrastructure (GCS bucket, Cloud SQL instance).
  * **Validation:** Every step must include a `bin/test` hook that passes before moving to the next phase.

