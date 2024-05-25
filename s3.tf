
resource "aws_s3_bucket" "terraform_bucket" {
  bucket = local.state_bucket
  tags = local.common_tags
}

resource "aws_s3_bucket_ownership_controls" "terraform_bucket_controls" {
  bucket = aws_s3_bucket.terraform_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "terraform_bucket_acl" {
  bucket = aws_s3_bucket.terraform_bucket.id
  acl    = "private"
  depends_on = [ aws_s3_bucket.terraform_bucket ]
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = local.logging_bucket
  tags = local.common_tags
}

resource "aws_s3_bucket_ownership_controls" "log_bucket_controls" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "private"
  depends_on = [ aws_s3_bucket.log_bucket ]
}

resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.terraform_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
  depends_on = [ aws_s3_bucket.terraform_bucket ]
}

# put policy on bucket
resource "aws_s3_bucket_policy" "terraform_bucket_policy" {
  bucket = aws_s3_bucket.terraform_bucket.id
  policy = data.aws_iam_policy_document.terraform_bucket_policy_document.json
  depends_on = [ aws_s3_bucket.terraform_bucket ]
}

# bucket policy
data "aws_iam_policy_document" "terraform_bucket_policy_document" {
  statement {
    sid = "User List Bucket"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.terraform_user.arn]
    }

    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.terraform_bucket.arn # bucket
    ]
  }
  statement {
    sid = "User Access state file"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.terraform_user.arn]
    }

    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.terraform_bucket.arn}/${var.environment}/terraform/.tfstate*" # state file
    ]
  }
}
