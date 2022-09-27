rg_names = [
  "rg-connected-dev",
  "rg-connected-test",
  "rg-connected-prod",
]

vnets = [
  {
    name    = "dev_vnet"
    address = "10.0.0.0/16"
  },
  {
    name    = "test_vnet"
    address = "10.1.0.0/16"
  },
  {
    name    = "prod_vnet"
    address = "10.2.0.0/16"
  }
]

#prefix
#prefix = "tem002"
