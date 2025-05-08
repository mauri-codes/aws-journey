variable "step" {
  type    = string
  default = "BASE"
}

variable "voting_queue_name" {
  type    = string
  default = "VotingQueue"
}

variable "table_name" {
  type = string
}

variable "vote_collector_lambda_name" {
  type = string
}

variable "vote_collector_policy_name" {
  type = string
}

variable "suffix" {
  type = string
  default = ""
}
