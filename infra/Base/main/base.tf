module "base_infrastructure" {
  source = "../module"
  bucket_name = var.bucket_name
  read_capacity = 5
  write_capacity = 5
  table_name = var.table_name
}
