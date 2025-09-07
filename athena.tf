# Flip var.enable_athena = true to use this; add your own workgroup/results bucket
resource "aws_glue_catalog_database" "cloudtrail" {
count = var.enable_athena ? 1 : 0
name = "cloudtrail_logs"
}


resource "aws_glue_catalog_table" "cloudtrail" {
count = var.enable_athena ? 1 : 0
name = "events"
database_name = aws_glue_catalog_database.cloudtrail[0].name
table_type = "EXTERNAL_TABLE"
storage_descriptor {
location = "s3://${var.bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/CloudTrail/"
input_format = "org.apache.hadoop.mapred.TextInputFormat"
output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
ser_de_info {
serialization_library = "org.openx.data.jsonserde.JsonSerDe"
}
}
}
