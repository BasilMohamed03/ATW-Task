-- Create the database
CREATE DATABASE web_db;

-- Switch to the new database
USE web_db;

-- Create the visitors table
CREATE TABLE visitors (
    id INT AUTO_INCREMENT PRIMARY KEY,       -- Auto-incrementing primary key
    ip_address VARCHAR(50) NOT NULL,         -- IP address of the visitor
    visit_time DATETIME DEFAULT CURRENT_TIMESTAMP -- Time of the visit
);

-- Create a database user with permissions
CREATE USER 'web_user'@'localhost' IDENTIFIED BY 'StrongP@ssw0rd!';

-- Grant the user full privileges on the database
GRANT ALL PRIVILEGES ON web_db.* TO 'web_user'@'localhost';

-- Apply the changes
FLUSH PRIVILEGES;
