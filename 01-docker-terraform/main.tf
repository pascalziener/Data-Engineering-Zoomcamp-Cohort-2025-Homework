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

resource "google_storage_bucket" "tf-demo-bucket" {
  name          = "custom-blade-448320-j1-tf-demo-bucket"
  location      = "EU"
  force_destroy = true

  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  // days
    }
  }

}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "DEZC_dataset"
  description                 = "Bigquery dataset for Data Engineering Zoomcamp 2025"
  location                    = "EU"
  default_table_expiration_ms = 3600000
}



