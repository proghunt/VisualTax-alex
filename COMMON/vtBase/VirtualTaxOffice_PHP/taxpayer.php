<?php
// Initialize the session
if (session_id() == ''){
    session_start();
}
 
// Check if the user is logged in, if not then redirect him to login page
if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true || !$_SESSION["payer"]) {
    header("location: login.php");
    exit;
}

require_once "apicontroller.php";

$Save_Value = "Save";
$Change_Password_Value = "Change password";
$Save_Photo_Value = "Upload photo";
$Save_Signature_Value = "Upload signature";
$Save_err = $Save_Photo_err = $Save_Signature_err = $Change_Password_err = $Current_Password_err = $New_Password_err = $Confirm_Password_err = "";
$Save_Success = $Save_Photo_Success = $Save_Signature_Success = $Change_Password_Success = "";
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
        elseif ($_POST["action"] == $Save_Photo_Value) {
            $_POST["action"] = "SAVE_PHOTO";            
            $res = processApiRequest();
            if ($res->success != "true") {
                $has_error = true;
                $Save_Photo_err = $res->error_message;
            }
            else {
                $Save_Photo_Success = "Photo was uploaded successfully";
            }
        }
        elseif ($_POST["action"] == $Save_Signature_Value) {
            $_POST["action"] = "SAVE_SIGNATURE";            
            $res = processApiRequest();
            if ($res->success != "true") {
                $has_error = true;
                $Save_Signature_err = $res->error_message;
            }
            else {
                $Save_Signature_Success = "Signature was uploaded successfully";
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

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Virtual Tax Office</title>
  <?php include "head_tags.inc"; ?>
  <script>    
    function showmap() {        
        document.getElementById('modal_title').innerHTML = 'Select on map';
        showPopup("select_taxoffice.php");
        return false;
    } 
    
    function showtaxoffice() {
        document.getElementById('modal_title').innerHTML = 'Virtual Office Profile';
        cyberid = document.getElementById('TaxOfficeCyberId').value;
        if (cyberid == "") {
            alert('Tax Office is not selected');
            return false;
        }
        showPopup('taxpayer_show_taxoffice.php?CyberId='+ cyberid);        
    }

    window.closeModal = function(){
        $('#myModal').modal('hide');
    };    
  </script>
</head>
<body>
 
<?php 

$_SERVER["REQUEST_METHOD"] = "GET";
$_GET["action"] = "LOAD_PROFILE";
$res = processApiRequest();
$res->restore = $has_error;

include "top.inc";

if ($res->success == "true") {       
                ?>                
                
                <div>   
                    <?php if (!is_empty($res->AppointmentDate)) { ?>
                    <div class="form-group clearfix ">
                        <div class="col-sm-12 ">
                        </div>
                        <div class="col-sm-12 " style="background-color: #f0ad4e; color: white; padding: 10px;">
                            <table border=0 width=100%>
                            <tr>
                                <td colspan=3>
                                    <h3 style="margin-top: 0px;">You have an Appointment!</h3>
                                </td>
                            </tr>
                            <tr>
                            <td>
                                <label>Appointment Date</label>
                                <input type="datetime-local" name="AppointmentDate" class="form-control" value="<?php echo $res->AppointmentDateT; ?>" readonly> 
                            </td>
                            <td>&nbsp;</td>
                            <td width=100%>
                                <label>Purpose Of Meeting</label>
                                <input type="text" name="PurposeOfMeeting" style="width: 100%;" class="form-control" value="<?php echo $res->PurposeOfMeeting; ?>" readonly> 
                            </td>
                            </tr>
                            </table>
                            <!--<div class="inline right_margin" style="float: left; width: auto;">
                                <h3>You have an Appointment!</h3>
                            </div>
                            <div class="inline right_margin " style="float: left; width: auto;">
                                <label>Appointment Date</label>
                                <input type="datetime-local" name="AppointmentDate" class="form-control" value="<?php echo $res->AppointmentDateT; ?>" readonly>                                            
                            </div>
                            <div class=" " style="float: left; width: 100%;">
                                <label>Purpose Of Meeting</label>
                                <input type="text" name="PurposeOfMeeting" class="form-control" value="<?php echo $res->PurposeOfMeeting; ?>" readonly>        
                            </div>                                    -->
                        </div>
                    </div>                                                                            
                    <?php } ?>
                
                    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
                        <div class="form-group clearfix ">
                            <div class="col-sm-11"> 
                                <div class="inline right_margin">
                                    <h2>Virtual Client</h2>
                                </div>
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
                            <div class="col-sm-3 ">
                                
                                <table border=0 cellpadding=0 cellspacing=0>
                                    <tr>
                                        <td><label>Virtual Office Id</label></td>
                                        <td><label>Profile</label></td>
                                        <td><label>Map</label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input type="text" id="TaxOfficeCyberId" name="TaxOfficeCyberId" class="form-control inline" value="<?php echo restore_value_if_needed($res, "TaxOfficeCyberId"); ?>">                                  
                                        </td>
                                        <td>
                                            <span data-toggle="modal" data-target="#myModal">
                                                <button class="btn" type="button" data-placement="bottom" title="Show Tax Office Profile" data-toggle="tooltip" onclick="showtaxoffice()"><img src="img/profile-icon.png"></button>
                                            </span>
                                        </td>
                                        <td>
                                            <span data-toggle="modal" data-target="#myModal">
                                                <button class="btn" type="button" data-placement="bottom" title="Select Tax Office on map" data-toggle="tooltip"  onclick="showmap()"><img src="img/map-magnify-icon.png"></button>
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-sm-2">
                                <label>First Name</label>
                                <input type="text" name="FirstName" class="form-control" value="<?php echo restore_value_if_needed($res, "FirstName"); ?>">
                            </div>
                            <div class="col-sm-2">
                                <label>Last Name</label>
                                <input type="text" name="LastName" class="form-control" value="<?php echo restore_value_if_needed($res, "LastName"); ?>">
                            </div>
                            <div class="col-sm-3">
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
                            <div class="inline right_margin ">
                                <label>Computer:&nbsp;&nbsp;</label>
                                <label class="radio-inline"><input type="radio" name="Computer" value="W" <?php echo (restore_value_if_needed($res, "Computer")=="W") ? 'checked' : ''; ?>>Windows</label>
                                <label class="radio-inline"><input type="radio" name="Computer" value="M" <?php echo (restore_value_if_needed($res, "Computer")=="M") ? 'checked' : ''; ?>>Mac</label>
                                <label class="radio-inline"><input type="radio" name="Computer" value="O" <?php echo (restore_value_if_needed($res, "Computer")=="O") ? 'checked' : ''; ?>>Other</label>
                            </div> 
                        </div> 
                        <div class="form-group clearfix ">
                            <div class="inline right_margin">
                                <label>Teamviewer ID</label>
                                <input type="text" name="TeamviewerID" class="form-control" value="<?php echo restore_value_if_needed($res, "TeamviewerID"); ?>">
                            </div>
                            <div class="inline right_margin">                            
                                <label>Virtual Meeting Alarm</label>
                                <input type="text" name="VirtualMeetingAlarm" class="form-control" value="<?php echo restore_value_if_needed($res, "VirtualMeetingAlarm"); ?>">
                            </div>
                            <div class="inline right_margin">                            
                                <label class="form-check-label" for="ZoomVideoID">ZoomVideo</label>
                                <input type="checkbox" class="form-check-input" value="Y" name="ZoomVideoID" <?php echo (restore_value_if_needed($res, "ZoomVideoID")=="Y") ? 'checked' : ''; ?>>
                            </div>
                            <div class="inline right_margin">
                                <label>UltraViewer ID</label>
                                <input type="text" name="UltraViewerID" class="form-control" value="<?php echo restore_value_if_needed($res, "UltraViewerID"); ?>">
                            </div>
                            <div class="inline right_margin">
                                <label>Tax Software Names</label>
                                <input type="text" name="TaxSoftwareNames" class="form-control" value="<?php echo restore_value_if_needed($res, "TaxSoftwareNames"); ?>">
                            </div>
                        </div>    
                        <div class="form-group clearfix ">
                            <div class="inline right_margin">                            
                                <label class="form-check-label" for="ShowSignatureToOffice">Show Signature To Office</label>
                                <input type="checkbox" class="form-check-input" value="Y" name="ShowSignatureToOffice" <?php echo (restore_value_if_needed($res, "ShowSignatureToOffice")=="Y") ? 'checked' : ''; ?>>
                            </div>                            
                        </div>                         
                        
                        <div class="form-group clearfix ">
                            <div class="col-sm-1">  
                                <input type="submit" class="btn btn-primary" name="action" value="<?php echo $Save_Value; ?>">
                            </div>
                        </div>                        
                    </form>  

                    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post" enctype="multipart/form-data">
                        <div class="form-group clearfix ">
                            <div class="col-sm-10"> 
                                <h2>Photo</h2>
                            </div>
                        </div>
                        <?php if (!is_empty($res->PhotoFile)) {?>
                        <div class="form-group clearfix ">
                            <div class="col-sm-12"> 
                                <div class="inline right_margin">                                    
                                    <label>Current photo</label><br>
                                    <img src='<?php echo $res->PhotoFile; ?>'>                                    
                                </div> 
                            </div>
                        </div>    
                        <?php }?>
                        <div class="form-group clearfix ">
                            <div class="col-sm-12"> 
                                <div class="inline right_margin">
                                    <label>Photo</label>
                                    <input type="file" name="photo_file"> 
                                </div>

                                <div class="inline right_margin">  
                                    <label>&nbsp;</label><br>
                                    <input type="submit" class="btn btn-primary" name="action" value="<?php echo $Save_Photo_Value; ?>">
                                </div>
                                <div class="inline right_margin">                             
                                    <br>
                                    <?php 
                                        if (!is_empty($Save_Photo_err)) { ?>
                                        <label class="text-danger"><?php echo $Save_Photo_err; ?></label>
                                    <?php } elseif (!is_empty($Save_Photo_Success)) { ?>
                                        <label class="text-success"><?php echo $Save_Photo_Success; ?></label>
                                    <?php } ?> 
                                </div> 
                            </div>
                        </div> 
                    </form>                    
                    
                    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post" enctype="multipart/form-data">
                        <div class="form-group clearfix ">
                            <div class="col-sm-10"> 
                                <h2>Signature</h2>
                            </div>
                        </div>
                        <?php if (!is_empty($res->SignatureFile)) {?>
                        <div class="form-group clearfix ">
                            <div class="col-sm-12"> 
                                <div class="inline right_margin">                                    
                                    <label>Current signature</label><br>
                                    <img src='<?php echo $res->SignatureFile; ?>'>                                    
                                </div> 
                            </div>
                        </div>    
                        <?php }?>
                        <div class="form-group clearfix ">
                            <div class="col-sm-12"> 
                                <div class="inline right_margin">
                                    <label>Signature</label>
                                    <input type="file" name="signature_file"> 
                                </div>

                                <div class="inline right_margin">  
                                    <label>&nbsp;</label><br>
                                    <input type="submit" class="btn btn-primary" name="action" value="<?php echo $Save_Signature_Value; ?>">
                                </div>
                                <div class="inline right_margin">                             
                                    <br>
                                    <?php 
                                        if (!is_empty($Save_Signature_err)) { ?>
                                        <label class="text-danger"><?php echo $Save_Signature_err; ?></label>
                                    <?php } elseif (!is_empty($Save_Signature_Success)) { ?>
                                        <label class="text-success"><?php echo $Save_Signature_Success; ?></label>
                                    <?php } ?> 
                                </div> 
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
                            <div class="inline right_margin <?php echo (!is_empty($Current_Password_err)) ? 'has-error' : ''; ?>">
                                <label>Current password</label>
                                <input type="Password" name="Password" class="form-control">
                                <span class="help-block"><?php echo $Current_Password_err; ?></span>
                            </div> 
                        
                            <div class="inline right_margin <?php echo (!is_empty($New_Password_err)) ? 'has-error' : ''; ?>">
                                <label>New password</label>
                                <input type="Password" name="NewPassword" class="form-control" maxlength="12">
                                <span class="help-block"><?php echo $New_Password_err; ?></span>
                            </div>

                            <div class="inline right_margin <?php echo (!is_empty($Confirm_Password_err)) ? 'has-error' : ''; ?>">
                                <label>Confirm password</label>
                                <input type="Password" name="ConfirmPassword" class="form-control" maxlength="12">
                                <span class="help-block "><?php echo $Confirm_Password_err; ?></span>
                            </div>
                        </div>                                               
                        
                        <div class="form-group clearfix">
                            <div class="col-sm-2">  
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


<!-- Modal -->
<div id="myModal" class="modal fade" role="dialog" data-keyboard="false" data-backdrop="static">
  <div id="modaldlg" class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div id="modalheader" class="modal-header">
        <button type="button" class="close" data-dismiss="modal" onclick="if (need_refresh) { location.reload() }">&times;</button>
        <h4 class="modal-title" id="modal_title">Select Virtual Office</h4>
      </div>
      <div class="modal-body">
        <iframe id="editFrame" seamless=""></iframe>
      </div>
    </div>

  </div>
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
