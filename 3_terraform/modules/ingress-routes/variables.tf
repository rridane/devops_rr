variable "namespace" {
  type = string
}

variable "stripPrefixMiddlewares" {
  type = map(
    object({
      type = string
      prefix = string
    })
  )
}

#variable "customHeadersMiddlewares" {
#  type = map(
#    object({
#      type = string
#      x-script-name = string
#      x-forwarded-prefix = string
#    })
#  )
#}

variable "addPrefixMiddleWares" {
  type = map(
    object({
      type = string
      prefix = string
    })
  )
}

variable "ingress_route" {
  type = object({
    name = string
    host = string
    pathPrefix = string
  })
}

variable "target-service" {
  type = object({
    name = string
    port = string
  })
}
