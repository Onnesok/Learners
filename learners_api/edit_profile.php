<?php

include("dbconnection.php");
$con = dbconnection();

$response = ['success' => 'false'];

if (isset($_POST["email"], $_POST["password"], $_POST["new_fname"], $_POST["new_lname"])) {
    $email = trim($_POST["email"]);
    $password = trim($_POST["password"]);
    $newFname = trim($_POST["new_fname"]);
    $newLname = trim($_POST["new_lname"]);

    // Validate email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $response['message'] = 'Invalid email format';
        echo json_encode($response);
        exit;
    }

    // Check if the email and password match
    $stmt = $con->prepare("SELECT upassword FROM sign_up WHERE uemail = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->bind_result($storedPassword);
    $stmt->fetch();
    $stmt->close();

    if ($storedPassword) {
        // Verify password
        if ($password === $storedPassword) {
            // Update user profile data
            $stmt = $con->prepare("UPDATE sign_up SET ufname = ?, ulname = ? WHERE uemail = ?");
            $stmt->bind_param("sss", $newFname, $newLname, $email);

            if ($stmt->execute()) {
                $response['success'] = 'true';
                $response['message'] = 'Profile updated successfully';
            } else {
                $response['message'] = 'Profile update failed: ' . $stmt->error;
            }

            $stmt->close();
        } else {
            $response['message'] = 'Invalid password';
        }
    } else {
        $response['message'] = 'Email not found';
    }
} else {
    $response['message'] = 'Required fields are missing';
}

echo json_encode($response);

?>
