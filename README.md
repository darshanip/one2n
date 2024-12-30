
# HTTP Service to List S3 Bucket Content

## Problem Statement

### Part 1: HTTP Service
Write an HTTP service in any programming language that exposes the endpoint `GET "http://IP:PORT/list-bucket-content/<path>"`. The endpoint should return the content of an S3 bucket path as specified in the request. If no path is specified, the top-level content is returned.

#### Examples:
1. **Top-Level Content**:
    - If the bucket has:
    ```
    |_ dir1
    |_ dir2
        |_ file1
        |_ file2
    ```
    - `http://IP:PORT/list-bucket-content` should return:
    ```json
    {"content": ["dir1", "dir2"]}
    ```

2. **Content of a Directory**:
    - `http://IP:PORT/list-bucket-content/dir1` should return:
    ```json
    {"content": []}
    ```

    - `http://IP:PORT/list-bucket-content/dir2` should return:
    ```json
    {"content": ["file1", "file2"]}
    ```

3. **Non-Existing Path**:
    - Handle errors for non-existing paths, like:
    ```json
    {"error": "Path not found"}
    ```

### Part 2: Terraform Layout for AWS Infrastructure

Write a Terraform layout to provision the necessary infrastructure on AWS and deploy the above code. This should include:
- An S3 bucket to store the files.
- An EC2 instance to run the HTTP service.
- Necessary IAM roles and permissions to allow the EC2 instance to access the S3 bucket.

### Evaluation Criteria

- **Code Quality**: The service code should be simple, clean, and adhere to standard coding practices. Well-organized code with proper documentation and comments is expected.
- **Infrastructure Code**: The Terraform code should be efficient, with a clear understanding of the resources required for the service. Proper handling of security configurations, IAM roles, and permissions is essential.
- **Error Handling**: The service should gracefully handle errors such as non-existing paths.
- **Deployment**: The service should be deployed over HTTPS.
- **Test Cases**: Ensure proper test cases to verify functionality.
  
### Bonus Points

- Handle errors for non-existing paths.
- Ensure that the service is deployed on HTTPS for secure communication.
- A short video demo recording or a comprehensive README explaining design decisions, assumptions, and the implementation process.

### Assumptions and Clarifications

- **Language Choice**: The HTTP service can be written in any of the following languages: Python, Go, Ruby, NodeJS, Java, or any language of choice. In this case, Python is used.
- **AWS Free Tier**: The deployment is done using an AWS Free Tier account. It is important to turn off unused resources to avoid unnecessary costs.

### Deployment Instructions

#### 1. Terraform Setup:
Ensure you have Terraform installed. The infrastructure is provisioned using the following resources:
- **S3 Bucket**: For storing files.
- **EC2 Instance**: Running the HTTP service.
- **IAM Role and Policy**: Allowing EC2 instance to access the S3 bucket.
- **Security Group**: Allowing HTTP (80) and HTTPS (443) inbound traffic.

To provision the resources:
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/one2n.git
   cd one2n
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

4. The EC2 instance will be deployed and accessible via the public IP generated during the deployment.

#### 2. HTTP Service Setup:
- The service will be deployed on the EC2 instance using the startup script (`startup-script.sh`).
- The script installs necessary dependencies such as Python and Flask, and starts the HTTP service to listen for requests on port 443.

#### 3. Access the Service:
Once the service is deployed, you can access it using the EC2 public IP and the following endpoints:
- `https://<EC2_PUBLIC_IP>/list-bucket-content`: To list the top-level contents of the S3 bucket.
- `https://<EC2_PUBLIC_IP>/list-bucket-content/<path>`: To list the contents of a specific directory within the S3 bucket.

#### 4. Example Requests:
1. `https://<EC2_PUBLIC_IP>/list-bucket-content` → Returns the top-level contents of the S3 bucket.
2. `https://<EC2_PUBLIC_IP>/list-bucket-content/dir1` → Returns the contents of `dir1`.
3. `https://<EC2_PUBLIC_IP>/list-bucket-content/dir2` → Returns the contents of `dir2`.

#### 5. Terminating Resources:
To avoid unnecessary charges, you can destroy the infrastructure after use:
```bash
terraform destroy
```

---

## Conclusion

This project demonstrates how to create a simple HTTP service to interact with an S3 bucket using Python and deploy it to AWS using Terraform. The service handles directory listings in an S3 bucket and provides secure access through HTTPS.

---
