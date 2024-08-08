<?php


function dbconnection() {
    $con = mysqli_connect("localhost", "root", "", "learners");
    return $con;
}

?>