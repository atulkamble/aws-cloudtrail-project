resource "aws_glue_catalog_database" "cloudtrail" {
  name = "cloudtrail_logs"
}

resource "aws_glue_catalog_table" "cloudtrail" {
  name          = "events"
  database_name = aws_glue_catalog_database.cloudtrail.name

  table_type = "EXTERNAL_TABLE"
  storage_descriptor {
    location      = "s3://${var.bucket_name}/AWSLogs/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }
  }
}
