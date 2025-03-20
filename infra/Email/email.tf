module "ses" {
  source  = "./ses"
  region  = local.region
  zone_id = local.zone_id
  domain  = local.domain
}
