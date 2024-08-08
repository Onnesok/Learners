<?php

include("dbconnection.php");
$con = dbconnection();

$response = ['success' => 'false'];

if (isset($_POST["fname"], $_POST["lname"], $_POST["email"], $_POST["password"])) {
    $fname = trim($_POST["fname"]);
    $lname = trim($_POST["lname"]);
    $email = trim($_POST["email"]);
    $password = trim($_POST["password"]);

    // Validate email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $response['message'] = 'Invalid email format';
        echo json_encode($response);
        exit;
    }

    // Check for existing user
    $stmt = $con->prepare("SELECT COUNT(*) FROM sign_up WHERE uemail = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->bind_result($userCount);
    $stmt->fetch();
    $stmt->close();

    if ($userCount > 0) {
        $response['message'] = 'User already exists';
        echo json_encode($response);
        exit;
    }

    // Insert new user with plaintext password
    $stmt = $con->prepare("INSERT INTO sign_up (ufname, ulname, uemail, upassword) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $fname, $lname, $email, $password);

    if ($stmt->execute()) {
        $response['success'] = 'true';
        $response['message'] = 'Registration successful';
    } else {
        $response['message'] = 'Registration failed: ' . $stmt->error;
    }

    $stmt->close();
} else {
    $response['message'] = 'Required fields are missing';
}

echo json_encode($response);

?>
