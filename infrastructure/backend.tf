terraform {
  backend "s3" {
    bucket       = "statefiles-feriel-020952703527"
    key          = "projet-federateur/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
