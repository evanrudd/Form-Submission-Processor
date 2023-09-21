provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "contact_form_processor" {
  filename      = "/Users/evanrudd/Code/Projects/Contact Form AWS Lambda and Terraform/aws_contact_form_processor.zip"
  function_name = "ContactFormProcessor"
  role          = aws_iam_role.lambda_role.arn
  handler = "lambdafunction.lambda_handler"
  runtime       = "python3.8" # Set the appropriate runtime for your Lambda function
}

resource "aws_iam_role" "lambda_role" {
  name = "contact-form-processor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name        = "SES_Permission_Policy"
    policy      = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action   = [
            "ses:SendEmail",
            "ses:SendRawEmail"
          ],
          Effect   = "Allow",
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.contact_form_processor.arn
  principal     = "apigateway.amazonaws.com"
}

output "lambda_arn" {
  value = aws_lambda_function.contact_form_processor.arn
}
