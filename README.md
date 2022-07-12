# simplego
### Description
This solution was created to demonstrate how Continuous deployment based on "Infrastructure as a code" looks like. It consists of go web-application which returns a web page containing a cat gif.
### CICD
![cicd](https://github.com/igkostyuk/simplego/blob/main/img/cicd.png)
### Infrastructure
![Infrastructure](https://github.com/igkostyuk/simplego/blob/main/img/cluster.png)
### Deployment
Preparation
- Install the required versions of Terraform
- Configure AWS CLI for your account (see [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html))
- Download the repo content
- Obtain GitHub token (see [here](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token))
#### CICD deployment
- Go to the /cicd directory
- Create terraform.tfvars
```
repo_url           = "https://github.com/user/appname"
github_oauth_token = "token"
branch_pattern     = "^refs/heads/main$"
git_trigger_event  = "PUSH"
```
> If you want to change Application name, environment name or region do not forget to update buildspec.yml before deploying from sratch. If you want to change parameters when infrastructure already deployed, it will delete all of existing resources and deploy new infrastructure and application. [ref.1](https://github.com/igkostyuk/simplego/blob/main/terraform/variables.tf)[ref.2](https://github.com/igkostyuk/simplego/blob/main/cicd/variables.tf)

- run:
```
terraform init
terrafrom apply
```
