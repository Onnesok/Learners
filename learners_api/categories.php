<?php

header('Content-Type: application/json');

// Sample categories data
$categories = [
    [
        "name" => "Programming",
        "image" => "http://192.168.1.13/learners_api/assets/images/programming.png",
        "courseCount" => 10
    ],
    [
        "name" => "UI/UX",
        "image" => "http://192.168.1.13/learners_api/assets/images/designer.png",
        "courseCount" => 8
    ],
    [
        "name" => "Marketing",
        "image" => "http://192.168.1.13/learners_api/assets/images/marketing.png",
        "courseCount" => 12
    ],
    [
        "name" => "Management",
        "image" => "http://192.168.1.13/learners_api/assets/images/management.png",
        "courseCount" => 12
    ],
    [
        "name" => "Robotics",
        "image" => "http://192.168.1.13/learners_api/assets/images/robotics.png",
        "courseCount" => 12
    ]
];

// Output the data as JSON
echo json_encode($categories);

?>
