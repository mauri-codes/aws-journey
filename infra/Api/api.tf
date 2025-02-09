
resource "null_resource" "function_binary" {
  # triggers = {
  #   dir_sha1 = sha1(join("", [for f in fileset("lambda", "**"): filesha1("lambda/${f}")]))
  # }

  provisioner "local-exec" {
    command = "cd lambda; GOARCH=amd64 GOOS=linux go build -o bootstrap main.go"
  }
}

data "archive_file" "compressed" {
  depends_on = [null_resource.function_binary]

  type        = "zip"
  source_file = local.built_file
  output_path = local.compressed_file
}

resource "aws_s3_object" "object" {
  depends_on = [data.archive_file.compressed]
  bucket     = data.aws_ssm_parameter.state_bucket_name.value
  key        = "lambda/api.zip"
  source     = local.compressed_file
  etag       = filemd5(local.compressed_file)
}

module "api" {
  source        = "./module"
  app_table     = local.app_table
  app_table_arn = local.app_table_arn
  env           = "PROD"
  infra_bucket  = local.infra_bucket
}
