<?php
// Initialize the session
if (session_id() == ''){
    session_start();
}
 
// Check if the user is logged in and redirect him to payer page
if(isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] == true && $_SESSION["payerid"] != 0){
    header("location: taxpayer.php");
    exit;
}

// Include config file
require_once "apicontroller.php";

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Virtual Tax Office</title>
  <?php include "head_tags.inc"; ?>
</head>
<body>  

<?php

include "top.inc";

// Define variables and initialize with empty values
$FirstName = $LastName = $Email = $TaxOfficeCyberId = $Password = $ConfirmPassword = "";
$FirstName_err = $LastName_err = $Email_err = $TaxOfficeCyberId_err = $Password_err = $ConfirmPassword_err = $Register_err = "";
$redirect = false;

// Processing form data when form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {    
    $FirstName = trim($_POST["FirstName"]);
    $LastName = trim($_POST["LastName"]);
    $Email = trim($_POST["Email"]);
    $TaxOfficeCyberId = trim($_POST["TaxOfficeCyberId"]);
    $Password = trim($_POST["Password"]);
    $ConfirmPassword = trim($_POST["ConfirmPassword"]);
    $_POST["action"] = 'REGISTER_PAYER';
    $res = processApiRequest();
        
    if ($res->success != 'true') {
        if ($res->type == 'first_name') {
            $FirstName_err = $res->error_message;
        }
        elseif ($res->type == 'last_name') {
            $LastName_err = $res->error_message;
        }
        elseif ($res->type == 'first_name') {
            $FirstName_err = $res->error_message;
        }
        elseif ($res->type == 'email') {
            $Email_err = $res->error_message;
        }
        elseif ($res->type == 'taxoffice_cyberid') {
            $TaxOfficeCyberId_err = $res->error_message;
        }
        elseif ($res->type == 'password') {
            $Password_err = $res->error_message;
        }
        elseif ($res->type == 'confirm_password') {
            $ConfirmPassword_err = $res->error_message;
        }
        else {
            $Register_err = $res->error_message;
        }
    }
    else {
        $redirect = true;
    }
                
    
}
if ($redirect) {
    header( "refresh:5;url=login.php" );
    ?> 
    <div class="alert alert-success">
      <strong>Congratulations!</strong> Your registration complete. Please check your e-mail for activation link before login
    </div>
    <?php
}
else {
        ?>
        
        <div>

        <table border=0 width=100%>
        <tr>
        <td>
            <h2>Are you a Tax Payer? </h2>
            <p>Please fill in your credentials to register.</p>
            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">            
                <div class="form-group <?php echo (!is_empty($FirstName_err)) ? 'has-error' : ''; ?>">
                    <label>First Name</label>
                    <input type="text" name="FirstName" class="form-control" value="<?php echo $FirstName; ?>">
                    <span class="help-block"><?php echo $FirstName_err; ?></span>
                </div>    
                <div class="form-group <?php echo (!is_empty($LastName_err)) ? 'has-error' : ''; ?>">
                    <label>Last Name</label>
                    <input type="text" name="LastName" class="form-control" value="<?php echo $LastName; ?>">
                    <span class="help-block"><?php echo $LastName_err; ?></span>
                </div>    
                <div class="form-group <?php echo (!is_empty($Email_err)) ? 'has-error' : ''; ?>">
                    <label>E-mail</label>
                    <input type="text" name="Email" class="form-control" value="<?php echo $Email; ?>">
                    <span class="help-block"><?php echo $Email_err; ?></span>
                </div>
                <div class="form-group <?php echo (!is_empty($TaxOfficeCyberId_err)) ? 'has-error' : ''; ?>">
                    <label>Virtual Office Id</label>
                    <input type="text" name="TaxOfficeCyberId" class="form-control" value="<?php echo $TaxOfficeCyberId; ?>">
                    <span class="help-block"><?php echo $TaxOfficeCyberId_err; ?></span>
                </div> 
                <div class="form-group <?php echo (!is_empty($Password_err)) ? 'has-error' : ''; ?>">
                    <label>Password</label>
                    <input type="password" name="Password" class="form-control" value="<?php echo $Password; ?>" maxlength="12">
                    <span class="help-block"><?php echo $Password_err; ?></span>
                </div>
                <div class="form-group <?php echo (!is_empty($ConfirmPassword_err)) ? 'has-error' : ''; ?>">
                    <label>Confirm Password</label>
                    <input type="password" name="ConfirmPassword" class="form-control" value="<?php echo $ConfirmPassword; ?>" maxlength="12">
                    <span class="help-block"><?php echo $ConfirmPassword_err; ?></span>
                </div>
                <div class="form-group">
                    <input type="submit" class="btn btn-primary" value="Submit">
                    <label class="text-danger"><?php echo $Register_err; ?></label>
                </div>
            </form>
        </div>
        </td>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
        <td style="border-left: 3px solid #e3e3e3;"></td>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
        <td style="vertical-align: top;">
            <h2>Are you a Tax Office? </h2>
            <p>Please contact us - <a href="mailto:support@visualtax.com">support@visualtax.com</a></p>
        </td>
        </tr>        
        </table>
        <?php        
    
}

include "bottom.inc";
?>        

</body>
</html>