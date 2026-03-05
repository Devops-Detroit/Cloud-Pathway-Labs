resource "aws_s3_bucket" "s3" {
    bucket = "Devops-Detroit-S3-Bucket"
    force_destroy = true
    
   
  
}

resource "aws_s3_bucket_public_access_block" "public_access_policy" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_website" {
  bucket = aws_s3_bucket.s3.id

  index_document {
    suffix = "index.html"
  }

}


##Bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  depends_on = [aws_s3_bucket_public_access_block.public_access_policy]
  bucket     = aws_s3_bucket.s3.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "PublicReadGetObject",
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.s3.id}/*"
        }
      ]
    }
  )
}