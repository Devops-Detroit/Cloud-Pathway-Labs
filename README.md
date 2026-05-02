# Cloud Pathway Labs

This repository contains all lab-related resources for the Cloud Pathway Program. It is designed to help both students and independent learners streamline the process of building and deploying AWS infrastructure through hands-on labs.

The materials in this repository are intended to provide practical experience with cloud concepts and infrastructure development.

**Note**: These labs are continuously being updated and refined to improve clarity, functionality, and learning outcomes.

## Table of Contents

1. Installation
2. Usage


## Installation

## Windows
1. Download the Windows installer: Go to https://awscli.amazonaws.com/AWSCLIV2.msi and save the file.
2. Double‑click AWSCLIV2.msi, click Next through the wizard, accept the license, and click Install, then Finish.
3. Open Command Prompt and run aws --version to confirm it shows an aws‑cli 2.x.x version.
2. Install Terraform: Go to  https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

## Terraform Usage

1. Get your access key ID & Secret access key
    - click the account name in the top right corner -> select security credentials -> access keys -> create key

2. Run aws configure and enter your Access Key, Secret Key, default region (like us-east-1), and output format (like json)

3. Navigate to a directroy of your choice 
   - cd <where you want the clone to live> 

4. Clone the Cloud Pathway Labs Repository
   - git clone  <git clone https://github.com/Devops-Detroit/Cloud-Pathway-Labs.git>

5. Open the repo within VSC
   - dir # to ensure that it lives there
   - code . # open coding editor


6. Create a new branch using the following command
   - git switch -c <branch-name>

7. Update the main.tf configuration

    configuration 
    create S3 bucket - cloud-pathway-terraformstate-webbase-<name of your choice>
    bucket key - enabled
    Encryption type - Server-side encryption with Amazon S3 managed keys (SSE-S3)

    backend "s3" {
    bucket  = "cloud-pathway-terraformstate-webbase-tester" # put your own s3 bucket name here
    key     = "dev.tfstate"
    region  = "us-east-1"
    encrypt = true

    }


