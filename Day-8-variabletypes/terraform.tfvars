rg-details = {
  name = "testing-rg"
  location = "westus"
  tag = {
    "env" = "test"
  }
}
nested-rg = {
    "dev" = {
        name = "dev-rg"
        location = "eastus"
        tag = {
            environment = "dev"
        }
    }
    "prod" = {
        name = "prod-rg"
        location = "eastus2"
        tag = {
            environment = "prod"
        }
    }
}