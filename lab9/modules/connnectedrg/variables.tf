variable rg_names {
    type = list(string)
}

variable vnets {
    type = list(map(string))
}

variable prefix {
    type = string
    default = "tem002"
}

variable region {
    type = string
    default = "Norway East"
}