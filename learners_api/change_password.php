<?php

include("dbconnection.php");
$con = dbconnection();

$response = ['success' => 'false'];

if (isset($_POST["email"], $_POST["current_password"], $_POST["new_password"])) {
    $email = trim($_POST["email"]);
    $current_password = trim($_POST["current_password"]);
    $new_password = trim($_POST["new_password"]);

    // Validate email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $response['message'] = 'Invalid email format';
        echo json_encode($response);
        exit;
    }

    // Check if user exists and current password is correct
    $stmt = $con->prepare("SELECT upassword FROM sign_up WHERE uemail = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->bind_result($stored_password);
    $stmt->fetch();
    $stmt->close();

    if (!$stored_password || $stored_password !== $current_password) {
        $response['message'] = 'Current password is incorrect';
        echo json_encode($response);
        exit;
    }

    // Update password
    $stmt = $con->prepare("UPDATE sign_up SET upassword = ? WHERE uemail = ?");
    $stmt->bind_param("ss", $new_password, $email);

    if ($stmt->execute()) {
        $response['success'] = 'true';
        $response['message'] = 'Password updated successfully';
    } else {
        $response['message'] = 'Password update failed: ' . $stmt->error;
    }

    $stmt->close();
} else {
    $response['message'] = 'Required fields are missing';
}

echo json_encode($response);

?>
