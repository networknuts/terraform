provider "aws" {
	region = "ap-south-1"
}

resource "aws_s3_bucket" "nnbucket" {
	bucket = "networknuts-weekend-terra"
	acl = "public-read"
	versioning {
		enabled = true
	}

	tags = {
		Name = "networknuts-weekend-terra"
	}

	lifecycle_rule {
		id = "log"
		enabled = true
		prefix = "log/"
		tags = {
			"rule" = "log"
			"autoclean" = "true"
		}
		transition {
			days = 35
			storage_class = "STANDARD_IA"
		}
		transition {
			days = 65
			storage_class = "GLACIER"
		}
		expiration {
			days = 100
		}
	}
}
