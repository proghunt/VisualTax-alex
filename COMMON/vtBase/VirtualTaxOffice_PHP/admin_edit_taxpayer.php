<?php
// Initialize the session
if (session_id() == ''){
    session_start();
}

require_once "apicontroller.php";

if (!isset($_SESSION["adminloggedin"]) || $_SESSION["adminloggedin"] !== true ) {   
    header("location: admin.php");
    exit;
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

$Save_Value = "Save";
$Change_Password_Value = "Reset password";
$Save_err = $Change_Password_err = $Current_Password_err = $New_Password_err = $Confirm_Password_err = "";
$Save_Success = $Change_Password_Success = "";
$has_error = false;
$need_refresh = false;
    
if($_SERVER["REQUEST_METHOD"] == "POST") {   
    if (isset($_POST["action"])) {
        if ($_POST["action"] == $Save_Value) {
            $_POST["action"] = "SAVE_PROFILE";            
            $res = processApiRequest();
            if ($res->success != "true") {
                $has_error = true;
                $Save_err = $res->error_message;
            }
            else {
                $Save_Success = "Changes were saved successfully";   
                $need_refresh = true;
            }
        }
        elseif ($_POST["action"] == $Change_Password_Value) {
            $_POST["action"] = "CHANGE_PASSWORD";            
            $res = processApiRequest();
            if ($res->success != "true") {
                $has_error = true;
                if ($res->type == 'password') {
                    $Current_Password_err = $res->error_message;
                }
                elseif ($res->type == 'new_password') {
                    $New_Password_err = $res->error_message;
                }
                elseif ($res->type == 'confirm_password') {
                    $Confirm_Password_err = $res->error_message;
                }
                else {
                    $Change_Password_err = $res->error_message;
                }
            }
            else {
                $Change_Password_Success = "Password was changed successfully";
            }
        }
        elseif ($_POST["action"] == "Logout") {
            logout();
            exit;
        }        
    }
}
$_SERVER["REQUEST_METHOD"] = "GET";
if (!isset($_GET["CyberId"]) && isset($_POST["CyberId"])) {                
    $_GET["CyberId"] = $_POST["CyberId"];
}
$_GET["action"] = "LOAD_PROFILE";
$res = processApiRequest();
$res->restore = $has_error;
if ($res->success == "true") {
        if ($need_refresh) { ?>
            <script>
                parent.need_refresh = true;
            </script>
        <?php }
                ?>                                
                <div class="jumbotron white_bg">
                   
                    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post" class="p-3">
                        <div class="form-group ">
                        </div>
                        <?php 
                            if (!is_empty($Save_err)) { ?>
                            <div class="alert alert-danger">
                              <strong>Error!</strong> <?php echo $Save_err; ?>
                            </div>
                        <?php } elseif (!is_empty($Save_Success)) { ?>
                            <div class="alert alert-success">
                              <?php echo $Save_Success; ?>
                            </div>
                        <?php } ?> 
                        <div class="form-group clearfix ">
                            <div class="col-sm-2">
                                <label>Virtual Id</label>
                                <input type="text" name="CyberId" class="form-control" value="<?php echo $res->CyberId; ?>" readonly>
                            </div> 
                            <div class="col-sm-2 ">
                                <label>Virtual Office Id</label>
                                <input type="text" name="TaxOfficeCyberId" class="form-control" value="<?php echo restore_value_if_needed($res, "TaxOfficeCyberId"); ?>">
                            </div>
                            <div class="col-sm-3">
                                <label>First Name</label>
                                <input type="text" name="FirstName" class="form-control" value="<?php echo restore_value_if_needed($res, "FirstName"); ?>">
                            </div>
                            <div class="col-sm-3">
                                <label>Last Name</label>
                                <input type="text" name="LastName" class="form-control" value="<?php echo restore_value_if_needed($res, "LastName"); ?>">
                            </div>
                            <div class="col-sm-2">
                                <label>E-mail</label>
                                <input type="text" name="Email" class="form-control" value="<?php echo restore_value_if_needed($res, "Email"); ?>">
                            </div>
                        </div>
                        <div class="form-group clearfix ">
                            <div class="col-sm-5 ">
                                <label>Street</label>
                                <input type="text" name="Street" class="form-control" value="<?php echo restore_value_if_needed($res, "Street"); ?>">
                            </div>
                            <div class="col-sm-2 ">
                                <label>City</label>
                                <input type="text" name="City" class="form-control" value="<?php echo restore_value_if_needed($res, "City"); ?>">
                            </div>
                            <div class="col-sm-1 ">
                                <label>Province</label>
                                <input type="text" name="Province" class="form-control" value="<?php echo restore_value_if_needed($res, "Province"); ?>">
                            </div>
                            <div class="col-sm-2 ">
                                <label>Postal</label>
                                <input type="text" name="Postal" class="form-control" value="<?php echo restore_value_if_needed($res, "Postal"); ?>">
                            </div>
                            <div class="col-sm-2 ">
                                <label>Country</label>
                                <input type="text" name="Country" class="form-control" value="<?php echo restore_value_if_needed($res, "Country"); ?>">
                            </div>
                        </div>
                        <div class="form-group clearfix ">                            
                            <div class="col-sm-1">
                                <label>Area</label>
                                <input type="text" name="Area" class="form-control" value="<?php echo restore_value_if_needed($res, "Area"); ?>">
                            </div>
                            <div class="col-sm-3">                            
                                <label>Phone</label>
                                <input type="text" name="Phone" class="form-control" value="<?php echo restore_value_if_needed($res, "Phone"); ?>">
                            </div>
                            <div class="col-sm-4">                            
                                <label>Cell</label>
                                <input type="text" name="Cell" class="form-control" value="<?php echo restore_value_if_needed($res, "Cell"); ?>">
                            </div>
                            <div class="col-sm-4">                            
                                <label>Fax</label>
                                <input type="text" name="Fax" class="form-control" value="<?php echo restore_value_if_needed($res, "Fax"); ?>">
                            </div>
                        </div> 
                        <div class="form-group clearfix ">
                            <div class="col-sm-4 content-checkbox">
                                <label>Computer:&nbsp;&nbsp;</label>
                                <label class="radio-inline"><input type="radio" name="Computer" value="W" <?php echo (restore_value_if_needed($res, "Computer")=="W") ? 'checked' : ''; ?>>Windows</label>
                                <label class="radio-inline"><input type="radio" name="Computer" value="M" <?php echo (restore_value_if_needed($res, "Computer")=="M") ? 'checked' : ''; ?>>Mac</label>
                                <label class="radio-inline"><input type="radio" name="Computer" value="O" <?php echo (restore_value_if_needed($res, "Computer")=="O") ? 'checked' : ''; ?>>Other</label>
                            </div> 
                        </div> 
                        <div class="form-group clearfix ">
                            <div class="col-sm-2">
                                <label>Teamviewer ID</label>
                                <input type="text" name="TeamviewerID" class="form-control" value="<?php echo restore_value_if_needed($res, "TeamviewerID"); ?>">
                            </div>
                            <div class="col-sm-2">                            
                                <label>Virtual Meeting Alarm</label>
                                <input type="text" name="VirtualMeetingAlarm" class="form-control" value="<?php echo restore_value_if_needed($res, "VirtualMeetingAlarm"); ?>">
                            </div>
                            <div class="col-sm-1">                            
                                <label class="form-check-label" for="ZoomVideoID">ZoomVideo</label>
                                <input type="checkbox" class="form-check-input" value="Y" name="ZoomVideoID" <?php echo (restore_value_if_needed($res, "ZoomVideoID")=="Y") ? 'checked' : ''; ?>>
                            </div>
                            <div class="col-sm-2">
                                <label>UltraViewer ID</label>
                                <input type="text" name="UltraViewerID" class="form-control" value="<?php echo restore_value_if_needed($res, "UltraViewerID"); ?>">
                            </div>
                            <div class="col-sm-2">
                                <label>Tax Software Names</label>
                                <input type="text" name="TaxSoftwareNames" class="form-control" value="<?php echo restore_value_if_needed($res, "TaxSoftwareNames"); ?>">
                            </div>
                        </div>                        
                        <div class="form-group clearfix ">
                            <div class="col-sm-6">                            
                                <label>Admin notes</label>
                                <input type="text" name="AdminNotes" class="form-control" value="<?php echo restore_value_if_needed($res, "AdminNotes"); ?>">
                            </div>
                            <div class="col-sm-2">                            
                                <label>Membership Fee Paid</label>
                                <input type="text" name="MembershipFeePaid" class="form-control" value="<?php echo restore_value_if_needed($res, "MembershipFeePaid"); ?>">               
                            </div>
                            <div class="col-sm-2">
                                <label>Number Of Times Received</label>
                                <input type="text" name="NumberOfTimesReceived" class="form-control" value="<?php echo restore_value_if_needed($res, "NumberOfTimesReceived"); ?>" readonly>
                            </div>
                            <div class="col-sm-2">
                                <label>Number Of Times Sent</label>
                                <input type="text" name="NumberOfTimesSent" class="form-control" value="<?php echo restore_value_if_needed($res, "NumberOfTimesSent"); ?>" readonly>
                            </div>
                        </div>                          
                        <div class="form-group clearfix ">
                            <div class="col-sm-1">  
                                <input type="submit" class="btn btn-primary" name="action" value="<?php echo $Save_Value; ?>">
                            </div>                            
                        </div> 
                    </form>
                    
                    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
                        <div class="form-group clearfix ">
                            <div class="col-sm-12"> 
                                <h2>Reset password</h2>
                            </div>
                        </div>
                        <div class="form-group clearfix ">
                       
                            <div class="col-sm-2 <?php echo (!is_empty($New_Password_err)) ? 'has-error' : ''; ?>">
                                <label>New password</label>
                                <input type="Password" name="NewPassword" class="form-control" maxlength="12">
                                <span class="help-block"><?php echo $New_Password_err; ?></span>
                            </div>

                            <div class="col-sm-2 <?php echo (!is_empty($Confirm_Password_err)) ? 'has-error' : ''; ?>">
                                <label>Confirm password</label>
                                <input type="Password" name="ConfirmPassword" class="form-control" maxlength="12">
                                <span class="help-block "><?php echo $Confirm_Password_err; ?></span>
                            </div>
                        </div>                                               
                        
                        <div class="form-group clearfix">
                            <div class="col-sm-2">  
                                <input type="hidden" name="CyberId" class="form-control" value="<?php echo $res->CyberId;?>">
                                <input type="submit" class="btn btn-primary" name="action" value="<?php echo $Change_Password_Value; ?>">
                            </div>
                            <div class="col-sm-10">                             
                                <?php 
                                    if (!is_empty($Change_Password_err)) { ?>
                                    <label class="text-danger"><?php echo $Change_Password_err; ?></label>
                                <?php } elseif (!is_empty($Change_Password_Success)) { ?>
                                    <label class="text-success"><?php echo $Change_Password_Success; ?></label>
                                <?php } ?> 
                            </div>                            
                        </div>
                    </form>
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
</body>
</html>