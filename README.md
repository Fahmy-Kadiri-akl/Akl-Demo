# Akeyless Demo

## Introduction
The purpose of this project is to create a complete end-to-end Akeyless deployment and configures those integrations so that you can focus on day 2 operations with Akeyless rather than how to set it up.

## Features
The project deployes in a standalone GKE cluster and includes the following components:

### Helm Charts
- API Gateway
- Kubernetes Secrets Injection
- Secure Remote Access
- Zero Trust Web Access

### Other components
- Create an Akeyless Application and group in Okta
- Deploy and Initialize Akeyless CLI for Linux and MacOS
- Configure Google DNS records for Akeyless Endpoints
- Deploy NGINX Ingress controller, Cert-Manager, and Let's Encrypt issuer
- 

## Prerequisites
- Akeyless account
- Register for an Okta account using the same email address as the Akeyless registration 
- A standalone kubernetes cluster in GCP
- DNS zone in GCP
- A GCP Services account with permissions (TBA)
- Terraform

## Installation
- Register for an account at https://console.akeyless.io/registration
- Install Okta CLI from https://cli.okta.com/manual/ and run the command below switching to your email address
- ```okta register --email=YOUR_EMAIL@proton.mee --first-name=FIRST --last-name=LAST --country=Canada```
- log into okta using your new account and get your Okta org name, it should look like `dev-123456` and base url `okta.com`
- In Okta go to Security > API > Tokens and create a new token.  Save your token for use later
- Create a standalone GKE cluster in GCP and have the project ID, zone, and region available
- Create a DNS zome in GCP and have the domain_suffix available.

## Usage
- Download the repo locally
- terraform init
- terraform apply

## Configuration
Here is a sample of environment variables you will need to add to `Terraform.tfvars`, you can also export `TF_VAR=` instead.
```#Okta sensitive information
okta_org_name  = "dev-12345"
okta_base_url  = "okta.com"
okta_api_token = "00D2RTADURK#DKGUVELASLEIRYQLDKDW"

#Akeyless Admin email and password # this is the admin creds you used to register an account
admin_email    = "YOUR.EMAIL@proton.me" #change to your email
domain_suffix = "demo.GCP.domain.com"  #change to your domain
dns_zone_name = "demo-GCP-ZONE-Name" #The GCP DNS zone name, you will need this to create the A Records

#AWS Target Credentials       # you can set this as a TF_VAR= variable and export it before running terraform
aws_access_key = "ACCESS_KEY"
aws_secret_key = "Secret KEY"

#gcp Target credentials & Project
gcp_project = "YOUR GCP PROJECT ID"
gcp_region  = "GCP REGION OF YOUR GKE CLUSTER"

gcp_key = "./keys.json" # this is your service account key that you created in GCP Service Accounts

#Kubernetes cluster info
config_context = "YOUR KUBERNETES CONTEXT"  # output from the command kubectx

#UID access Token    #place holder for UID access tokens, we will inject the newly created tokens for terraform provider to use later.
uid_access_id = "placeholder"
uid_token     = "placeholder"

#SRA Docker Rep Creds:  #populate if you are using SRA, leave blank otherwise, conditional Terraform deployment will skip SRA installtion if you don't have docker repo creds from Akeyless
docker_repo_creds = ""
  ```

## Known Issues
- You may run into permissions issues because your service accounts may not have the right set of permissions to perform actions in your GCP environment.  When you see an error related to permissions, find the corresponding missing permissions and add it like this:

```gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:YOUR_EMAIL@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.admin"
```
- Apply your terraform config again after you've added all of the needed permissions
- If you destroy your Terraform config, you will get a ```400 bad request``` error.  This is because the API Key access-id Terraform tries to being used by a running Gateway.  You can't delete the gateway while it's running either, so catch 22, the only way around this is to wait for a timeout period 2-5 minutes, and manually delete the gateway from the akeyless console https://console.akeyless.io.  This will resolve the error and you can destroy the rest of the terraform config.
  
## Modules
okta_module
Akeyless_module
gcloud_module

## Inputs
List and describe all the inputs for your Terraform project.

## Outputs
List and describe all the outputs from your Terraform project.

## Contributing
Guidelines on how others can contribute to your project.

## Versioning
Information on the versioning system used, if applicable.

## Authors or Contributors
List of individuals who have contributed to the project.

## License
State the license under which your project is available. Include a link to the LICENSE file if you have one.

## Acknowledgments
Optional: Any acknowledgments or credits you want to give.

## FAQs
Frequently asked questions about your project.

## Support and Contact
Information on where to seek help, report issues, or contact for support.
