<?php

// Initialize the session
if (session_id() == ''){
    session_start();
}
 
// Check if the user is logged in, if not then redirect him to login page
if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true || !$_SESSION["office"]) {
    header("location: login.php");
    exit;
}

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

$Save_Value = "Save";
$Change_Password_Value = "Change password";
$Save_err = $Change_Password_err = $Current_Password_err = $New_Password_err = $Confirm_Password_err = "";
$Save_Success = $Change_Password_Success = "";
$has_error = false;
    
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
$_GET["action"] = "LOAD_PROFILE";
$res = processApiRequest();
$res->restore = $has_error;

include "top.inc";

if ($res->success == "true") {
                ?>                
                <div>
                   
                    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post" class="p-3">
                        <div class="form-group ">
                        </div>
                        <div class="form-group clearfix ">
                            <div class="col-sm-12"> 
                                <h2>Virtual Office</h2>
                            </div>
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
                            <div class="col-sm-6">
                                <label>Business Name</label>
                                <input type="text" name="BusinessName" class="form-control" value="<?php echo restore_value_if_needed($res, "BusinessName"); ?>" readonly>
                            </div>
                            <div class="col-sm-4 ">
                                <label>E-mail</label>
                                <input type="text" name="Email" class="form-control" value="<?php echo restore_value_if_needed($res, "Email"); ?>" readonly>
                            </div>
                        </div>
                        <div class="form-group clearfix ">                            
                            <div class="col-sm-4 ">
                                <label>WebSite</label>
                                <input type="text" name="WebSiteUrl" class="form-control" value="<?php echo restore_value_if_needed($res, "WebSiteUrl"); ?>">
                            </div>
                            <div class="col-sm-4 ">
                                <label>Contact</label>
                                <input type="text" name="Contact" class="form-control" value="<?php echo restore_value_if_needed($res, "Contact"); ?>" readonly>
                            </div>
                            <div class="col-sm-2 ">
                                <label class="form-check-label" for="HaveCRAEfilerNumber">Have CRA Efiler Number</label><br>
                                <input type="checkbox" class="form-check-input" value="Y" name="HaveCRAEfilerNumber" <?php echo (restore_value_if_needed($res, "HaveCRAEfilerNumber")=="Y") ? 'checked' : ''; ?>>
                            </div>
                            <div class="col-sm-2 ">
                                <label>CRA Efiler Name</label>
                                <input type="text" name="CRAEfilerName" class="form-control" value="<?php echo restore_value_if_needed($res, "CRAEfilerName"); ?>">
                            </div>
                        </div>
                        <div class="form-group clearfix ">
                            <div class="col-sm-6 ">
                                <label>Street</label>
                                <input type="text" name="Street" class="form-control" value="<?php echo restore_value_if_needed($res, "Street"); ?>" readonly>
                            </div>
                            <div class="col-sm-3 ">
                                <label>City</label>
                                <input type="text" name="City" class="form-control" value="<?php echo restore_value_if_needed($res, "City"); ?>" readonly>
                            </div>
                            <div class="col-sm-1 ">
                                <label>Province</label>
                                <input type="text" name="Province" class="form-control" value="<?php echo restore_value_if_needed($res, "Province"); ?>" readonly>
                            </div>
                            <div class="col-sm-2 ">
                                <label>Postal</label>
                                <input type="text" name="Postal" class="form-control" value="<?php echo restore_value_if_needed($res, "Postal"); ?>" readonly>
                            </div>
                        </div>    
                        <div class="form-group clearfix ">                            
                            <div class="col-sm-1">
                                <label>Area</label>
                                <input type="text" name="Area" class="form-control" value="<?php echo restore_value_if_needed($res, "Area"); ?>" readonly>
                            </div>
                            <div class="col-sm-3">                            
                                <label>Phone</label>
                                <input type="text" name="Phone" class="form-control" value="<?php echo restore_value_if_needed($res, "Phone"); ?>" readonly>
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
                            <div class="col-sm-2">
                                <label>Years in business</label>
                                <input type="text" name="YearsInBusiness" class="form-control" value="<?php echo restore_value_if_needed($res, "YearsInBusiness"); ?>">
                            </div>
                            <div class="col-sm-10">                                
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T1">T1</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T1" <?php echo (restore_value_if_needed($res, "T1")=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T2">T2</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T2" <?php echo (restore_value_if_needed($res, "T2")=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T3">T3</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T3" <?php echo (restore_value_if_needed($res, "T3")=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T4T5">T4T5</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T4T5" <?php echo (restore_value_if_needed($res, "T4T5")=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="NR4">NR4</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="NR4" <?php echo (restore_value_if_needed($res, "NR4")=="Y") ? 'checked' : ''; ?>>
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T3010">T3010</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T3010" <?php echo (restore_value_if_needed($res, "T3010")=="Y") ? 'checked' : ''; ?>>
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T5013">T5013</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T5013" <?php echo (restore_value_if_needed($res, "T5013")=="Y") ? 'checked' : ''; ?>>
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T5018">T5018</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T5018" <?php echo (restore_value_if_needed($res, "T5018")=="Y") ? 'checked' : ''; ?>>
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="vtNOA">vtNOA</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="vtNOA" <?php echo (restore_value_if_needed($res, "vtNOA")=="Y") ? 'checked' : ''; ?>>
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="Other">Other</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="Other" <?php echo (restore_value_if_needed($res, "Other")=="Y") ? 'checked' : ''; ?>>
                                </div>
                            </div>
                        </div>    
                        <div class="form-group clearfix ">    
                            <div class="col-sm-5">
                                <label>Other Service Description</label>
                                <input type="text" name="OtherServiceDescription" class="form-control" value="<?php echo restore_value_if_needed($res, "OtherServiceDescription"); ?>">
                            </div>
                            <div class="col-sm-7">
                                <label for="Experience">Experience</label>
                                <textarea class="form-control" name="Experience" rows="3"><?php echo restore_value_if_needed($res, "Experience"); ?></textarea>
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
                            <div class="col-sm-10"> 
                                <h2>Change password</h2>
                            </div>
                        </div>
                        <div class="form-group clearfix ">
                            <div class="col-sm-2 <?php echo (!is_empty($Current_Password_err)) ? 'has-error' : ''; ?>">
                                <label>Current password</label>
                                <input type="Password" name="Current_Password" class="form-control">
                                <span class="help-block"><?php echo $Current_Password_err; ?></span>
                            </div> 
                        
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
                                <input type="submit" class="btn btn-primary" name="action" value="<?php echo $Change_Password_Value; ?>">
                            </div>
                            <div class="col-sm-8">                             
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
<?php } 
include "bottom.inc";   
?>             
</body>
</html>
