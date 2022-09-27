#Her deklareres prefix som brukes på alle resursser
variable "prefix" {
  type = string
  description = "Prefix som som brukes på kurs"
}

#Her deklareres og settes default region
variable "region" {
  type = string
  default = "Norway East"
  description = "Regionen for Azure resurser. Standard er Norway East"
}

#Tags
variable "tags" {
  type = map(string)
 
}