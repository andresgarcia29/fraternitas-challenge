# Fraternitas Challenge

This project is a challenge for Fraternitas to demonstrate the deployment of a simple Python API to AWS Lambda using Terraform and GitHub Actions. The project consists of two main parts: Terraform code to create an S3 bucket and a Lambda function, and a Python API that returns a "Hello, World!" message.

## Project Structure

```
.
├── .env
├── .github/
│   ├── actions/
│   │   └── push-python-lamda-to-s3/
│   └── workflows/
│       └── lamda-to-s3-and-deploy.yaml
├── .gitignore
├── .pre-commit-config.yaml
├── .pytest_cache/
├── .vscode/
├── api/
│   ├── __pycache__/
│   ├── main.py
│   ├── Makefile
│   ├── poetry.lock
│   ├── pyproject.toml
│   ├── pytest.ini
│   ├── ruff.toml
│   └── tests/
│       ├── __init__.py
│       └── test_main.py
└── terraform/
    ├── modules/
    ├── phases/
    │   ├── prod/
    │   │   ├── locals.tf
    │   │   ├── variables.tf
    │   │   ├── conf.tf
    │   │   ├── main.tf
    │   │   └── .terraform.lock.hcl
    │   └── support/
    │       ├── policies.tf
    │       ├── openid.tf
    │       ├── main.tf
    │       └── .terraform.lock.hcl
    └── .tflint.hcl
```

## Terraform

The Terraform code is located in the `terraform/` directory. It creates an S3 bucket and a Lambda function. The Lambda function is configured to use the code from the `api/` directory.

### Files

- `terraform/phases/prod/locals.tf`: Defines local variables for the organization name, application name, environment, version, and name.
- `terraform/phases/prod/variables.tf`: Defines the `app_version` variable.
- `terraform/phases/prod/conf.tf`: Configures the Terraform backend to use an S3 bucket.
- `terraform/phases/prod/main.tf`: Defines the AWS provider and modules for S3 and Lambda.
- `terraform/phases/support/policies.tf`: Defines IAM policies for OIDC, ECR, S3, and Terraform.
- `terraform/phases/support/openid.tf`: Configures the OIDC provider for GitHub Actions.
- `terraform/phases/support/main.tf`: Defines IAM roles and policy attachments for GitHub Actions.
- `terraform/modules/aws_s3/`: Contains the S3 module.
- `terraform/modules/aws_lambda/`: Contains the Lambda module.

## API

The API code is located in the `api/` directory. It is a simple Python API that returns a "Hello, World!" message.

### Files

- `api/main.py`: Contains the `lambda_handler` function that returns the "Hello, World!" message.
- `api/tests/test_main.py`: Contains a test for the `lambda_handler` function.
- `api/Makefile`: Contains a target to run tests.
- `api/pyproject.toml`: Defines the project dependencies and configuration.
- `api/poetry.lock`: Locks the project dependencies.
- `api/pytest.ini`: Configures pytest.
- `api/ruff.toml`: Configures the Ruff linter.

## GitHub Actions

The GitHub Actions workflow is located in the `.github/workflows/lamda-to-s3-and-deploy.yaml` file. It is triggered on pushes to the `main` branch and performs the following steps:

We use OpenID Connect (OIDC) to authenticate with AWS, which is one of the most secure ways to manage authentication. OIDC allows GitHub Actions to securely access AWS resources without needing to store long-lived AWS credentials. Instead, short-lived tokens are used, reducing the risk of credential exposure and enhancing security. This setup is configured in the `terraform/phases/support/openid.tf` file, which ensures that only trusted GitHub repositories can assume the necessary IAM roles to perform actions in AWS.

1. Checks out the code.
2. Configures AWS credentials.
3. Pushes the Python Lambda code to S3.
4. Runs Terraform to apply the changes.

## GitHub Actions Composite

The GitHub Actions composite is located in the `.github/actions/push-python-lamda-to-s3/` directory. It defines a reusable action to push the Python Lambda code to an S3 bucket.

### Files

- `.github/actions/push-python-lamda-to-s3/action.yml`: Defines the composite action.

### action.yml

```yaml
name: 'Push Python Lambda to S3'
description: 'Pushes the Python Lambda code to an S3 bucket'
inputs:
    bucket-name:
        description: 'The name of the S3 bucket'
        required: true
    lambda-code-path:
        description: 'The path to the Lambda code'
        required: true
runs:
    using: 'composite'
    steps:
        - name: 'Upload Lambda code to S3'
            run: |
                aws s3 cp ${{ inputs.lambda-code-path }} s3://${{ inputs.bucket-name }}/lambda.zip
            shell: bash
```

## Usage

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Poetry](https://python-poetry.org/docs/#installation)
- [AWS CLI](https://aws.amazon.com/cli/)

### Setup

1. Clone the repository:

```sh
git clone <repository-url>
cd <repository-name>
```

2. Install the Python dependencies:

```sh
cd api
poetry install
```

3. Initialize and apply the Terraform configuration:

```sh
cd terraform/phases/prod
terraform init
terraform apply -var app_version=<version> -auto-approve
```

### Running Tests

To run the tests, use the following command:

```sh
cd api
make test
```

## Conclusion

This project demonstrates the deployment of a simple Python API to AWS Lambda using Terraform and GitHub Actions. The API returns a "Hello, World!" message, and any changes to the API code will trigger the GitHub Actions workflow to update the Lambda function.

## Updating the API

To test the deployment process with a new version, you can modify the response message in the `lambda_handler` function located in `api/main.py`. For example, change the message from "Hello, World!" to "Hello, Fraternitas!".

### Example Change

Edit the `api/main.py` file:

```python
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello, Fraternitas!'
        'try': '7'
    }
```

After making this change, commit and push the code to the `main` branch. This will trigger the GitHub Actions workflow to deploy the updated Lambda function with the new response message.

### Testing the Deployed API

To test the deployed API, you can use the following endpoint:

```
https://c5ooxvhfyh635rohzjk55h7u6u0hmzjk.lambda-url.us-east-1.on.aws/
```

You can use `curl` or any HTTP client to send a request to this endpoint and verify the response.

Example using `curl`:

```sh
curl https://c5ooxvhfyh635rohzjk55h7u6u0hmzjk.lambda-url.us-east-1.on.aws/
```

You should receive a response with the message "Hello, World!" or "Hello, Fraternitas!"