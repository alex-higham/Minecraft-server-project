## What does this repository do?

This repo was made to create a Minecraft server on an AWS EC2 instance using Terraform, AWS cli, and Ansible.  It started as a manual install of a Minecraft server meant to host a max of ten players and was converted to Infrastructure as Code.  This automation was built to run on Linux, but should be capable of running on Windows if the necessary tools are installed for Windows/Mac.  If it's ran on Windows, I would suggest running the code in a Linux VM or WSL.  The tutorial section will have instructions meant for Ubuntu 24.04
## Requirements

This code was converted from a previous manual install from the AWS home console for EC2.  That being said, there are some values in the Terraform script that are hard-coded to work based on the previous installation of the Minecraft server.  The requirements for running the script are as follows.
#### AWS Resources (Must be created manually first)
These resources were created from a manual install and recycled for this project.  They must exist in your AWS account before running the automation:

**Security Group:**
- **Name:** `Minecraft Security`
- **Inbound Rules:**
  - SSH: TCP port 22 from 0.0.0.0/0
  - Minecraft: TCP port 25565 from 0.0.0.0/0
- **Outbound Rules:**
  - All traffic to 0.0.0.0/0

**EC2 Key Pair:**
- **Name:** `Minecraft Key`
- **Type:** ED25519
- **Location:** `~/.ssh/Minecraft Key.pem` (with 400 permissions)

**Elastic IP:**
- **Name:** `Minecraft Terraform-eip`
- **Scope:** VPC
- **Type:** Public IPv4

#### Required Tools

| Tool      | Version   | Purpose                                    |
| --------- | --------- | ------------------------------------------ |
| Terraform | v1.12.1+  | Infrastructure provisioning                |
| AWS CLI   | v2.27.25+ | AWS authentication and resource management |
| Ansible   | v2.18.6+  | Server configuration management            |

#### Credentials

Since an AWS account is required to set up this server, we need the access key id, the secret access key, and the session token to connect to create the EC2 instance.  

I got my credentials from signing into the aws academy web portal and starting the AWS lab.  After it's started, click on the AWS details button.  Under Cloud Access, there should be a Show button next to AWS CLI.  Click on that, and copy the credentials into:

```bash
# Location: ~/.aws/credentials
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY
aws_session_token = YOUR_SESSION_TOKEN  
```

## Pipeline Architecture and Overview

#### Stage 1: Infrastructure Provisioning (Terraform)
- **Duration:** ~2-3 minutes
- **Actions:**
  - Validates existing AWS resources (security group, key pair, Elastic IP)
  - Creates new EC2 instance with Ubuntu 24.04
  - Associates Elastic IP with instance
  - Configures security group attachment
#### Stage 2: Wait Period
- **Duration:** 60 seconds
- **Purpose:** Ensures EC2 instance is fully booted and SSH is available
#### Stage 3: Server Configuration (Ansible)
- **Duration:** ~5 minutes
- **Actions:**
  - Updates system packages
  - Installs Java 21 and tmux
  - Downloads Minecraft server (version 1.21)
  - Generates initial server files
  - Accepts EULA and configures server properties
  - Creates startup scripts and systemd service
  - Starts Minecraft server
#### Stage 4: Verification
- **Duration:** ~1-2 minutes  
- **Actions:**
  - Server generates world
  - Service becomes available on port 25565
  - Players can connect

The following graphic was made via an LLM since I wasn't sure how to effectively visualize the process.

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Terraform     │    │   AWS EC2       │    │   Ansible       │
│                 │    │                 │    │                 │
│ • Provisions    │───▶│ • Ubuntu 24.04  │───▶│ • Java 21       │
│   EC2 instance  │    │ • t3.medium     │    │ • Minecraft     │
│ • Associates    │    │ • Security      │    │ • Systemd       │
│   Elastic IP    │    │   groups        │    │ • Auto-start    │
│ • Configures    │    │ • SSH access    │    │                 │
│   networking    │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │ Minecraft Server│
                       │                 │
                       │ • Port 25565    │
                       │ • 10 players    │
                       │ • Auto-restart  │
                       │ • Tmux session  │
                       └─────────────────┘
```

## Starting Tutorial

#### Step 1

The first thing to that should be done is run an update and for the OS and install the necessary tools if they aren't already installed.  Since this was coded in Ubuntu 24.04, I used the apt package-manager for the install. 

   ```bash
   sudo apt update
   sudo apt install -y terraform ansible awscli
   ```
#### Step 2

If it hasn't been done already, move the SSH key for the AWS instance into the correct directory and give it the correct user permissions.  You might want to verify that your AWS credentials are also set up correctly.  Replace the information shown below with your known credentials.

   ```bash
   cp "Minecraft Key.pem" ~/.ssh/
   chmod 400 ~/.ssh/"Minecraft Key.pem"
   
   # Location: ~/.aws/credentials
   [default]
   aws_access_key_id = YOUR_ACCESS_KEY
   aws_secret_access_key = YOUR_SECRET_KEY
   aws_session_token = YOUR_SESSION_TOKEN
   ```
#### Step 3

Select a directory you want to run the code in.  Clone this repository and navigate to that directory

```bash
git clone https://github.com/alex-higham/Minecraft-server-project.git
cd Minecraft-server-project
```
#### Step 4

Next we need to initialize the Terraform script to get the required providers for the script.  We should also format the configuration and validate it to ensure it works as intended.  If there are no errors, we can start the Terraform script.  Enter the following commands into the terminal one at a time.  

```bash

terraform init
terraform fmt
terraform validate
terraform apply
```

#### Step 5

Wait until the script finishes.  It might take a while for it to complete.  If the additional variables are set correctly, then the script should output the IP address and port number needed to connect to the server via the Minecraft client.  It will also output the necessary ssh command to connect to the server to verify the install and make any other changes to the server setup.

#### Step 6

Enjoy the Minecraft server!