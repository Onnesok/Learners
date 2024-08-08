<?php

header('Content-Type: application/json');

// Sample categories data
$categories = [
    [
        "title" => "App development",
        "image" => "http://192.168.1.13/learners_api/assets/images/iron_man.jpg",
        "stars" => "5.0",
        "discount" => "10%",
    ],
    [
        "title" => "UX Design Essentials",
        "image" => "http://192.168.1.13/learners_api/assets/images/league.jpg",
        "stars" => "4.0",
        "discount" => "No",
    ],
    [
        "title" => "Digital Marketing 101",
        "image" => "http://192.168.1.13/learners_api/assets/images/batman.png",
        "stars" => "4.5",
        "discount" => "No",
    ],
    [
        "title" => "Mara khawya 101",
        "image" => "http://192.168.1.13/learners_api/assets/images/league1.jpg",
        "stars" => "4.5",
        "discount" => "50%",
    ],
    [
        "title" => "ROS",
        "image" => "http://192.168.1.13/learners_api/assets/images/demo.jpg",
        "stars" => "5.0",
        "discount" => "10%",
    ],
    [
        "title" => "Overflow handled  perfectly 101",
        "image" => "http://192.168.1.13/learners_api/assets/images/demo.jpg",
        "stars" => "5.0",
        "discount" => "10%",
    ],
    [
        "title" => "Apex legends 101",
        "image" => "http://192.168.1.13/learners_api/assets/images/apex.jpg",
        "stars" => "5.0",
        "discount" => "10%",
    ],
];

// Output the data as JSON
echo json_encode($categories);

?>
