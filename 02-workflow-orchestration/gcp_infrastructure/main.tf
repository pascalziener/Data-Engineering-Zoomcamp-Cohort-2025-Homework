terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
  project = "custom-blade-448320-j1"
  region  = "europe-west4l"
}

resource "google_storage_bucket" "pzi-de-zoomcamp-bucket" {
  name     = "448320-pzi-de-zoomcamp-bucket"
  location = "europe-west2"
  project  = "custom-blade-448320-j1"

  # Optional, but recommended settings:
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 // days
    }
  }

  force_destroy = true
}

resource "google_bigquery_dataset" "pzi-de-zoomcamp-bq-dataset" {
  dataset_id = "pzi_de_zoomcamp_bq_dataset"
  location   = "europe-west2"
  project    = "custom-blade-448320-j1"
}
