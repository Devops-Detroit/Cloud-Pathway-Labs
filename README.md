# Cloud Pathway Labs

This repository contains all lab-related resources for the Cloud Pathway Program. It is designed to help both students and independent learners streamline the process of building and deploying AWS infrastructure through hands-on labs.

The materials in this repository are intended to provide practical experience with cloud concepts and infrastructure development.

**Note**: These labs are continuously being updated and refined to improve clarity, functionality, and learning outcomes.

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
