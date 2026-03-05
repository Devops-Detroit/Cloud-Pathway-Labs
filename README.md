# Cloud Pathway Labs

The purpose of this repo is to store all lab related items for the cloud pathway program. This can be used by students and non students
to stream line the proecss of building AWS infrastcuture. **These labs are continously being refined**

## Table of Contents

1. Installation
2. Usage


## Installation

1. git clone https://github.com/Devops-Detroit/Cloud-Pathway-Labs.git

## Usage

All Labs are located in the Labs Directory. Each lab comes with a backend.hcl template

1. To run a lab, fill out the backend.hcl items labeled replace
2. Run the following command ./bootstrap/bootstrap_backend.sh 
3. Run the command terraform init -backend-config=backend.hcl
4. Run the command terraform apply
