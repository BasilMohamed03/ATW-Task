# ATW-Task
1. Networking Concepts

## IP Addresses 
An **IP address** (Internet Protocol address) is a unique identifier assigned to devices on a network to enable them to communicate with each other. There are two types of IP addresses:
- **IPv4**: A 32-bit address (e.g., `192.168.0.1`).
- **IPv6**: A 128-bit address (e.g., `2001:0db8:85a3:0000:0000:8a2e:0370:7334`).

For local networks, private IP ranges are commonly used:
- `192.168.0.0` to `192.168.255.255`
- `10.0.0.0` to `10.255.255.255`
- `172.16.0.0` to `172.31.255.255`

## MAC Addresses
A **MAC address** (Media Access Control address) is a hardware address that uniquely identifies each network interface card (NIC) on a device. It is a 48-bit address typically written in hexadecimal format, e.g., `00:1A:2B:3C:4D:5E`. Unlike IP addresses, MAC addresses operate at the data link layer of the OSI model and are used for communication within a local network.

## Switches
A **switch** is a networking device that connects devices within the same network segment (local area network, or LAN). It operates at Layer 2 (data link layer) of the OSI model and uses MAC addresses to forward data to the appropriate device. Switches can efficiently manage traffic by only sending data to the specific device it is intended for.

## Routers
A **router** is a networking device that connects multiple networks, such as connecting a local network to the internet or a different subnet. Routers operate at Layer 3 (network layer) and use IP addresses to determine the best path for forwarding data between different networks. Routers are responsible for routing packets across networks using routing protocols.

## Routing Protocols
**Routing protocols** are used by routers to exchange information about network paths and determine the best route for forwarding data. Some common routing protocols include:
- **RIP (Routing Information Protocol)**: A distance-vector protocol that uses hop count to determine the best route.
- **OSPF (Open Shortest Path First)**: A link-state protocol that uses more complex algorithms to determine the best route based on network topology.
- **BGP (Border Gateway Protocol)**: A path vector protocol used for routing between different autonomous systems on the internet.

2. Deliverables

This outlines the steps I took to complete the ATW Task, which involves setting up a LAMP (Linux, Apache, MySQL, PHP) stack on an AWS EC2 instance and hosting a website on it. The website displays visitor data from a MySQL database.

# LAMP Stack Setup using Ubuntu VM

## Overview
This guide describes how I set up and configured the environment for the ATW task on a local Ubuntu virtual machine (VM), including the setup of MySQL, Apache, and the deployment of the PHP file (`index.php`).

## Prerequisites
Before starting, ensure you have:
- A local Ubuntu virtual machine (VM) set up.
- Apache, MySQL, and PHP installed on your VM.
- Access to a `.sql` file for setting up the database schema.

## 1. Install Apache and MySQL on Ubuntu VM
1. **Update your system:**
```bash
    sudo apt update
    sudo apt upgrade -y
   ```

2. **Install Apache:**
```bash
    sudo apt install apache2
   ```

3. **Install MySQL:**
```bash
    sudo apt install mysql-server
   ```

4. **Install PHP and MySQL PHP extension:**
```bash
    sudo apt install php libapache2-mod-php php-mysql
   ```

5. **Start Apache and MySQL services:**
```bash
    sudo systemctl start apache2
    sudo systemctl enable apache2

    sudo systemctl start mysql
    sudo systemctl enable mysql
   ```

## 2. Configure MySQL Database
1. **Log in to MySQL:**
```bash
    sudo mysql
   ```

2. **Create the Database and User:**
```sql
    CREATE DATABASE web_db;
    CREATE USER 'web_user'@'localhost' IDENTIFIED BY 'StrongP@ssw0rd!';
    GRANT ALL PRIVILEGES ON web_db.* TO 'web_user'@'localhost';
    FLUSH PRIVILEGES;
   ```

3. **Exit MySQL:**
```sql
    EXIT;
   ```

4. **Create the Database Schema:**
    Create a file called `schema.sql` with the necessary table creation and data insertion commands. Here's an example schema:
```sql
    CREATE TABLE visitors (
        id INT AUTO_INCREMENT PRIMARY KEY,
        ip_address VARCHAR(100),
        visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
   ```

5. **Import the schema into MySQL:**
```bash
    sudo mysql -u web_user -p web_db < /home/basil/schema.sql
   ```

## 3. Set Up Apache Virtual Host for PHP File
1. **Edit Apache configuration for your site:**
```bash
    sudo nano /etc/apache2/sites-available/000-default.conf
   ```

2. **Modify the `DirectoryIndex` directive to prioritize `index.php` over `index.html`:**
    Find the following line:
```bash
    DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm
   ```
    And change it to:
```bash
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
   ```

3. **Modify the `DocumentRoot` to point to the directory where your PHP file will be located:**
```bash
    DocumentRoot /home/basil/Task
   ```

4. **Enable PHP module for Apache if not already enabled:**
```bash
    sudo a2enmod php
   ```

5. **Restart Apache to apply changes:**
```bash
    sudo systemctl restart apache2
   ```


## 4. Test the Setup
1. Open a browser and navigate to your VM's local IP address or `localhost`:
  ```
    http://localhost/index.php or http://192.168.117.128
    ```

2. You should see the visitor data fetched from the MySQL database if everything is set up correctly.

## Troubleshooting
- If you encounter an issue where the database connection fails, check the Apache and MySQL logs for errors.
    - Apache error logs: `/var/log/apache2/error.log`
    - MySQL error logs: `/var/log/mysql/error.log`
  
## Troubleshooting
- If you encounter an issue where the database connection fails, check the Apache and MySQL logs for errors.
    - Apache error logs: `/var/log/apache2/error.log`
    - MySQL error logs: `/var/log/mysql/error.log`

# LAMP Stack Setup using AWS 

## Overview
This guide describes how I set up and configured the environment for the ATW task on AWS EC2 virtual machine (VM), including the setup of MySQL, Apache, and the deployment of the PHP file (`index.php`).

## Prerequisites

- An AWS EC2 instance with an appropriate AMI and security group configuration.
- SSH access to the EC2 instance.
- PHP file (`index.php`) that connects to a MySQL database and displays visitor information.
- A local machine running Linux (Ubuntu) for setup and local development.

## Steps

### 1. Launch EC2 Instance on AWS

1. **Create an EC2 Instance**:
   - I used an Amazon ubuntu AMI (AMI ID: `ami-0e2c8caa4b6378d8c`) to launch an EC2 instance.
   - Security group configuration was set to allow inbound traffic on port 80 (HTTP), port 443 (HTTPS) and 22 (SSH) for access.

2. **Generate and Configure Key Pair**:
   - I created a key pair on AWS (e.g., `key.pem`) to enable SSH access to the EC2 instance.

3. **Obtain the Public IP of the EC2 Instance**:
   - Once the instance was running, I noted down its public IP address for use in connecting to the instance.

### 2. SSH into the EC2 Instance

1. **Connect to the EC2 Instance**:
   I used the following command to SSH into the EC2 instance:

 ```bash
   ssh -i /path/to/key.pem ec2-user@<Public-IP> 
```

2. **Fix Permissions for Key: In case the private key file has insecure permissions, I fixed it with:**

 ```bash
chmod 400 /path/to/key.pem 
   ```
### 3. Install LAMP Stack on EC2 Instance

1. **Install Apache:**
```bash
    sudo apt update
    sudo apt install apache2
   ```

2. **Install MySQL:**
```bash
    sudo apt install mysql-server
   ```

3. **Start and enable MySQL:**
 ```bash
    sudo systemctl start mysql
    sudo systemctl enable mysql
   ```

## 4. Configure MySQL Database

1. **Log in to MySQL:**
```bash
    sudo mysql
   ```

2. **Create the Database and User:**
```sql
    CREATE DATABASE web_db;
    CREATE USER 'web_user'@'localhost' IDENTIFIED BY 'StrongP@ssw0rd!';
    GRANT ALL PRIVILEGES ON web_db.* TO 'web_user'@'localhost';
    FLUSH PRIVILEGES;
   ```

3. **Exit MySQL:**
```sql
    exit;
   ```

4. **Create the Database Schema:**
    Create a file called `schema.sql` with the necessary table creation and data insertion commands. Here's an example schema:
```sql
    CREATE TABLE visitors (
        id INT AUTO_INCREMENT PRIMARY KEY,
        ip_address VARCHAR(100),
        visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
   ```
    Then, run:
```bash
    sudo mysql -u web_user -p web_db < /home/ubuntu/schema.sql
   ```

## 5. Test the Setup
1. Visit the public IP of your EC2 instance in your browser:
    (http://3.86.105.116)

2. If everything is set up correctly, you should see the visitor data fetched from the MySQL database.

## Troubleshooting
- If you encounter an issue where the database connection fails, check the Apache and MySQL logs for errors.
    - Apache error logs: `/var/log/apache2/error.log`
    - MySQL error logs: `/var/log/mysql/error.log`
