variable "region" {
    type = string
    default = "ap-south-1"
}

variable "environment" {
    type = string
    default = "prod"
}

variable "product" {
    type = string
    default = "tubesight"
}

variable "secret_prefix" {
    type = string
    default = "querious/tubesight"
}

variable "runtime" {
    type = string
    default = "python3.9"
}

variable "functions_dir" {
    type = string
    description = "Directory for the functions in the local file system"
    default = "backend/functions"
}

variable "output_dir" {
    type = string
    description = "Directory for the function's deployment package in the local file system"
    default = "backend/build"
}