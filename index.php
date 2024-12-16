<?php
$servername = "localhost";
$username = "web_user";
$password = "StrongP@ssw0rd!";
$database = "web_db";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Fetch visitor data
$sql = "SELECT ip_address, visit_time FROM visitors";
$result = $conn->query($sql);

// Display data
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        echo "IP: " . $row["ip_address"] . " - Time: " . $row["visit_time"] . "<br>";
    }
} else {
    echo "No records found.";
}

$conn->close();
?>
