<?php
// Initialize the session
if (session_id() == ''){
    session_start();
}

require_once "apicontroller.php"; 
logout();
header("location: login.php");
?>