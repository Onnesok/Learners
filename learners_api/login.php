<?php

include("dbconnection.php");
$con = dbconnection();

$response = ['success' => 'false'];

if (isset($_POST["email"], $_POST["password"])) {
    $email = trim($_POST["email"]);
    $password = trim($_POST["password"]);

    // Validate email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $response['message'] = 'Invalid email format';
        echo json_encode($response);
        exit;
    }

    // Prepare statement to check if the email exists and get the password
    $stmt = $con->prepare("SELECT ufname, ulname, upassword FROM sign_up WHERE uemail = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->bind_result($fname, $lname, $storedPassword);
    $stmt->fetch();
    $stmt->close();

    if ($storedPassword) {
        // Verify password
        if ($password === $storedPassword) {
            $response['success'] = 'true';
            $response['message'] = 'Login successful';
            $response['user'] = [
                'fname' => $fname,
                'lname' => $lname,
                'email' => $email
            ];
        } else {
            $response['message'] = 'Invalid password';
        }
    } else {
        $response['message'] = 'User not found';
    }
} else {
    $response['message'] = 'Required fields are missing';
}

echo json_encode($response);

?>
