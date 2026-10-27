<!DOCTYPE html>
<html lang="en">
<head>
  <title>Virtual Tax Office</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="css/virtualtaxoffice.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body>

<?php

// Include config file
require_once "apicontroller.php";

$_GET["action"] = "ACTIVATE";

$res = processApiRequest();
if ($res->success == "true") {
?>
<div class="alert alert-success">
  <strong>Success!</strong> Your account was activated
</div>    
<?php    
} 
else {
?>    
<div class="alert alert-danger">
  <strong>Error occured!</strong> <?php echo $res->error_message?>
</div>
<?php
}

?>

</body >