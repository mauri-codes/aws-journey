resource "aws_cognito_user" "admin" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  username     = "admin@${var.domain}"

  attributes = {
    email          = "admin@${var.domain}"
    name           = "admin"
    role           = "admin"
    email_verified = true
  }
}

resource "aws_cognito_user" "tester1" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  username     = "tester1@${var.domain}"

  attributes = {
    email          = "tester1@${var.domain}"
    name           = "tester1"
    role           = "user"
    email_verified = true
  }
}

resource "aws_cognito_user" "tester2" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  username     = "tester2@${var.domain}"

  attributes = {
    email          = "tester2@${var.domain}"
    name           = "tester2"
    role           = "user"
    email_verified = true
  }
}

resource "aws_cognito_user" "tester3" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  username     = "tester3@${var.domain}"

  attributes = {
    email          = "tester3@${var.domain}"
    name           = "tester3"
    role           = "user"
    email_verified = true
  }
}
