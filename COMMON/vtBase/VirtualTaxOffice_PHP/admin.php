<?php
// Initialize the session
if (session_id() == ''){
    session_start();
}

// Include config file
require_once "apicontroller.php";

if($_SERVER["REQUEST_METHOD"] == "POST") {   
    if (isset($_POST["action"])) {
        if ($_POST["action"] == "Logout") {
            logout();
        }
    }
}    
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Virtual Tax Office</title>
  <?php include "head_tags.inc"; ?>
</head>
<body>
 
<?php 

// Define variables and initialize with empty values
$Password = "";
$Password_err = "";

if (!isset($_SESSION["adminloggedin"]) || $_SESSION["adminloggedin"] !== true ) {
    if($_SERVER["REQUEST_METHOD"] == "POST") {  
        // Check if Password is empty
        if (is_empty(trim($_POST["Password"]))){
            $Password_err = "Please enter your Password.";
        } else{
            $Password = trim($_POST["Password"]);
        }
        
        if ($Password_err == "") {
            if ($_POST["Password"] == "Igor") {
                if (session_id() == ''){
                    session_start();
                }
                
                // Store data in session variables
                $_SESSION["adminloggedin"] = true;
                $_SESSION["loggedin"] = false;
                $_SESSION["cyberid"] = ""; 
                $_SESSION["office"] = false;
                $_SESSION["payer"] = false;
            }
            else {
                $Password_err = "Password is not valid";
            }
        }
    }
}
include "top.inc";       

if (!isset($_SESSION["adminloggedin"]) || $_SESSION["adminloggedin"] !== true ) {
    // show login form
    ?>
    
    <div>
        <h2>Admin panel</h2>
        <p>Enter password to get access to admin panel</p>
        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
            <div class="form-group <?php echo (!is_empty($Password_err)) ? 'has-error' : ''; ?>">
                <label>Password</label>
                <input type="Password" name="Password" class="form-control">
                <span class="help-block"><?php echo $Password_err; ?></span>
            </div>
            <div class="form-group">
                <input type="submit" class="btn btn-primary" value="Login">
            </div>
        </form>
    </div> 
    
    <?php 
}  

include "bottom.inc";
?>  
</body>
</html>
