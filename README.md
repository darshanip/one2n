
# One2N: EC2 Instance with S3 Bucket Access on AWS

This project demonstrates how to provision an **EC2 instance** on **AWS** that interacts with an **S3 bucket**. The EC2 instance is configured with **IAM roles and policies** that grant access to a specific S3 bucket for reading and writing data.

## Prerequisites

Before you begin, make sure you have the following:

- **AWS Account**: You need an AWS account to deploy the resources.
- **Terraform**: Install Terraform to provision and manage the infrastructure. You can download it from [here](https://www.terraform.io/downloads.html).
- **AWS CLI**: Install and configure the AWS CLI with your credentials. Instructions are available [here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

## Project Structure

This project contains the following files:

```
├── main.tf               # Terraform configuration to create AWS resources
├── startup-script.sh     # EC2 user-data script to set up the instance
└── README.md             # Project documentation
```

### `main.tf`

This is the main Terraform configuration file that provisions the AWS infrastructure. It creates:

- An S3 bucket
- IAM roles and policies for EC2 to access the S3 bucket
- EC2 instance with the necessary IAM role and security group
- Security group rules for HTTP/HTTPS traffic

### `startup-script.sh`

This is a bash script executed when the EC2 instance starts. It installs dependencies, configures the instance, and starts an application.

## Resources Provisioned

### 1. **S3 Bucket**

An S3 bucket named `one2ndemobucket` is created to store and retrieve objects. The bucket has `force_destroy = true`, so it will be deleted if Terraform destroys the resources.

### 2. **IAM Role & Policy**

- **IAM Role**: This role allows EC2 instances to assume the permissions defined by the attached IAM policy.
- **IAM Policy**: The policy grants EC2 instances permission to interact with the S3 bucket (`one2ndemobucket`). The permissions include:
  - `s3:GetObject`: Read objects from the bucket.
  - `s3:PutObject`: Upload objects to the bucket.
  - `s3:ListBucket`: List objects in the bucket.

### 3. **EC2 Instance**

An EC2 instance is provisioned using the Amazon Linux 2023 AMI (`ami-01816d07b1128cd2d`). It is configured with:
- An IAM role to interact with the S3 bucket
- A security group to allow HTTP and HTTPS traffic
- A user-data script to set up the environment

### 4. **Security Group**

A security group is created for the EC2 instance to allow inbound traffic on ports:
- HTTP (port 80)
- HTTPS (port 443)

### 5. **EC2 Instance Configuration**

The EC2 instance is associated with a public IP address. The instance is provisioned with the necessary IAM role and security group to enable access to the S3 bucket and serve content over HTTP/HTTPS.

## Steps to Deploy

### 1. Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/darshanip/one2n.git
cd one2n
```

### 2. Initialize Terraform

Run the following command to initialize Terraform and download required providers:

```bash
terraform init
```

### 3. Apply the Terraform Configuration

Apply the Terraform configuration to provision the resources on AWS:

```bash
terraform apply
```

Terraform will prompt you for confirmation to create the resources. Type `yes` to proceed.

### 4. EC2 Instance Setup

Once the EC2 instance is initialized, it will automatically run the `startup-script.sh` file. This script:
- Installs Python 3, Git, and the required Python libraries (`Flask`, `Boto3`).
- Downloads the `app.py` application script from a specified URL.
- Generates a self-signed SSL certificate and key using OpenSSL.
- Starts the application in the background.

### 5. Access the EC2 Instance

Once the EC2 instance is running, you can access the application through its public IP via:
- HTTP: `http://<EC2_PUBLIC_IP>:80`
- HTTPS: `https://<EC2_PUBLIC_IP>:443`

You can check the EC2 instance logs by viewing the `app.log` file or using `nohup`.

## IAM Policy Explained

The IAM policy attached to the EC2 instance role grants access to the `one2ndemobucket` and allows the following S3 operations:

- **`s3:GetObject`**: Read objects from the bucket.
- **`s3:PutObject`**: Upload objects to the bucket.
- **`s3:ListBucket`**: List objects in the bucket.

This setup ensures that the EC2 instance has the necessary permissions to interact with files in the S3 bucket.

## Security Group Configuration

The EC2 instance is exposed to the internet through the following inbound rules:
- **HTTP (port 80)**: Allow traffic from any IP address (`0.0.0.0/0`).
- **HTTPS (port 443)**: Allow traffic from any IP address (`0.0.0.0/0`).

The EC2 instance can send outbound traffic on all ports (`0.0.0.0/0`).

## Clean Up

To remove all the created resources, run the following command:

```bash
terraform destroy
```

Terraform will prompt you for confirmation to delete the resources. Type `yes` to proceed.