<?php

if (session_id() != '') {
    if (isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] === true) {
        if ($_SESSION["office"]) {
            header("location: taxoffice.php");
        }
        elseif ($_SESSION["payer"]) {
            header("location: taxpayer.php");
        }
        exit;
    }
}

require_once "apicontroller.php";
 
// Define variables and initialize with empty values
$CyberId = $Password = "";
$CyberId_err = $Password_err = $err = "";
 

// Processing form data when form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST"){
    $CyberId = trim($_POST["CyberId"]);
    $Password = trim($_POST["Password"]);
    $_POST["action"] = 'LOGIN';
    $res = processApiRequest();
        
    if ($res->success != 'true') {
        if ($res->type == 'cyberid') {
            $CyberId_err = $res->error_message;
        }
        elseif ($res->type == 'password') {
            $Password_err = $res->error_message;
        }
        else {
            $err = $res->error_message;
        }
    }
    else {
        if ($_SESSION["office"]) {
            header("location: taxoffice.php");
        }
        elseif ($_SESSION["payer"]) {
            header("location: taxpayer.php");
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
    <?php include "top.inc";?>
            <div>
                <h2>Login</h2>
                <p>Please fill in your credentials to login.</p>
                <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
                    <div class="form-group <?php echo (!is_empty($CyberId_err)) ? 'has-error' : ''; ?>">
                        <label>Virtual Id</label>
                        <input type="text" name="CyberId" class="form-control" value="<?php echo $CyberId; ?>">
                        <span class="help-block"><?php echo $CyberId_err; ?></span>
                    </div>    
                    <div class="form-group <?php echo (!is_empty($Password_err)) ? 'has-error' : ''; ?>">
                        <label>Password</label>
                        <input type="Password" name="Password" class="form-control">
                        <span class="help-block"><?php echo $Password_err; ?></span>
                    </div>
                    <div class="form-group">
                        <input type="submit" class="btn btn-primary" value="Login">
                        <?php 
                            if (!is_empty($err)) { ?>
                            <label class="text-danger"><?php echo $err; ?></label>                                
                        <?php } ?> 
                    </div>
                    <p>Don't have an account? <a href="taxpayer_register.php">Sign up now</a>.</p>
                </form>
            </div>
    <?php include "bottom.inc";?>
</body>
</html>