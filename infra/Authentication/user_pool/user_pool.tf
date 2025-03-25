resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 6
  }
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Account Confirmation"
    email_message        = "Your confirmation code is {####}"
  }
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "defaultEnv"
    required                 = false

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "env"
    required                 = false

    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "workspaces"
    required                 = false

    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "groups"
    required                 = false

    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "role"
    required                 = false

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
  email_configuration {
    email_sending_account = "DEVELOPER"
    from_email_address    = "auth@info.${var.domain}"
    source_arn            = var.ses_domain_identity
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "cognito-client"

  user_pool_id                  = aws_cognito_user_pool.user_pool.id
  generate_secret               = false
  allowed_oauth_flows           = ["implicit"]
  allowed_oauth_scopes          = ["email", "openid", "profile"]
  prevent_user_existence_errors = "ENABLED"
  supported_identity_providers  = ["COGNITO"]
  id_token_validity             = 12
  access_token_validity         = 12
  refresh_token_validity        = 60
  logout_urls                   = ["https://${var.domain}"]
  callback_urls                 = ["https://${var.domain}", "http://localhost:3000"]
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]
  allowed_oauth_flows_user_pool_client = true
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain          = "cognito.${var.domain}"
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  certificate_arn = var.certificate_arn
}
