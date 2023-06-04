resource "aws_iam_role_policy" "my_policy" {
  name = "role_policy"
  role = aws_iam_role.my-role.id

  
  policy = file("policy.json")
}

resource "aws_iam_role" "my-role" {
  name = "iam_role"

  assume_role_policy = file("iam-role.json")
}

data "archive_file" "lambda-file" {
  type        = "zip"
  source_file = "my-function.py"
  output_path = local.location
}

resource "aws_lambda_function" "my_lambda" {
  filename      = local.location
  function_name = "my_lambda_function"
  role          = aws_iam_role.my-role.arn
  handler       = "my-function.ugo"

  source_code_hash = base64sha256(local.location)
  runtime = "python3.8"

}