<?php
// Initialize the session
if (session_id() == ''){
    session_start();
}

require_once "apicontroller.php";

// Check if the user is logged in, if not then redirect him to login page
if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true) {
    header("location: login.php");
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

$Save_Value = "Set Appointment";
$Save_err = "";
$Save_Success = "";
$has_error = false;
$need_refresh = false;

$cyberid = "";
if (isset($_GET["TaxPayerCyberId"])) {
    $cyberid = $_GET["TaxPayerCyberId"];
}
elseif (isset($_POST["TaxPayerCyberId"])) {
    $cyberid = $_POST["TaxPayerCyberId"];
}
    
if($_SERVER["REQUEST_METHOD"] == "POST") {   
    if (isset($_POST["action"])) {
        if ($_POST["action"] == $Save_Value) {
            $_POST["action"] = "SET_APPOINTMENT"; 
            $res = processApiRequest();
            if ($res->success != "true") {
                $has_error = true;
                $Save_err = $res->error_message;
            }
            else {
                $Save_Success = "Appointment was saved successfully";
                $need_refresh = true;
            }
        }
    }
}

$_SERVER["REQUEST_METHOD"] = "GET";
$_GET["action"] = "LOAD_PROFILE";
$_GET["CyberId"] = $cyberid;
$res = processApiRequest();
if ($res->success == "true") {
    if ($need_refresh) { ?>
            <script>
                parent.need_refresh = true;
            </script>
    <?php } ?>
                <div class="jumbotron white_bg">
                   
                        <div class="form-group ">
                        </div>                        
                        
                        <div class="form-group clearfix ">
                            <div class="col-sm-2">
                                <label>Virtual Id</label>
                                <input type="text" name="CyberId" class="form-control" value="<?php echo $res->CyberId; ?>" readonly>
                            </div> 
                            <div class="col-sm-2 ">
                                <label>Virtual Office Id</label>
                                <input type="text" name="TaxOfficeCyberId" class="form-control" value="<?php echo $res->TaxOfficeCyberId; ?>" readonly>
                            </div>
                            <div class="col-sm-3">
                                <label>First Name</label>
                                <input type="text" name="FirstName" class="form-control" value="<?php echo $res->FirstName; ?>" readonly>
                            </div>
                            <div class="col-sm-3">
                                <label>Last Name</label>
                                <input type="text" name="LastName" class="form-control" value="<?php echo $res->LastName; ?>" readonly>
                            </div>
                            <div class="col-sm-2">
                                <label>E-mail</label>
                                <input type="text" name="Email" class="form-control" value="<?php echo $res->Email; ?>" readonly>
                            </div>
                        </div>
                        <div class="form-group clearfix ">
                            <div class="col-sm-5 ">
                                <label>Street</label>
                                <input type="text" name="Street" class="form-control" value="<?php echo $res->Street; ?>" readonly>
                            </div>
                            <div class="col-sm-2 ">
                                <label>City</label>
                                <input type="text" name="City" class="form-control" value="<?php echo $res->City; ?>" readonly>
                            </div>
                            <div class="col-sm-1 ">
                                <label>Province</label>
                                <input type="text" name="Province" class="form-control" value="<?php echo $res->Province; ?>" readonly>
                            </div>
                            <div class="col-sm-2 ">
                                <label>Postal</label>
                                <input type="text" name="Postal" class="form-control" value="<?php echo $res->Postal; ?>" readonly>
                            </div>
                            <div class="col-sm-2 ">
                                <label>Country</label>
                                <input type="text" name="Country" class="form-control" value="<?php echo $res->Country; ?>" readonly>
                            </div>
                        </div>
                        <div class="form-group clearfix ">                            
                            <div class="col-sm-1">
                                <label>Area</label>
                                <input type="text" name="Area" class="form-control" value="<?php echo $res->Area; ?>" readonly>
                            </div>
                            <div class="col-sm-3">                            
                                <label>Phone</label>
                                <input type="text" name="Phone" class="form-control" value="<?php echo $res->Phone; ?>" readonly>
                            </div>
                            <div class="col-sm-4">                            
                                <label>Cell</label>
                                <input type="text" name="Cell" class="form-control" value="<?php echo $res->Cell; ?>" readonly>
                            </div>
                            <div class="col-sm-4">                            
                                <label>Fax</label>
                                <input type="text" name="Fax" class="form-control" value="<?php echo $res->Fax; ?>" readonly>
                            </div>
                        </div> 
                        <div class="form-group clearfix ">
                            <div class="inline right_margin content-checkbox">
                                <label>Computer:&nbsp;&nbsp;</label>
                                <label class="radio-inline"><input type="radio" name="Computer" value="W" <?php echo ($res->Computer=="W") ? 'checked' : ''; ?> onclick="return false;">Windows</label>
                                <label class="radio-inline"><input type="radio" name="Computer" value="M" <?php echo ($res->Computer=="M") ? 'checked' : ''; ?> onclick="return false;">Mac</label>
                                <label class="radio-inline"><input type="radio" name="Computer" value="O" <?php echo ($res->Computer=="O") ? 'checked' : ''; ?> onclick="return false;">Other</label>
                            </div> 
                        </div> 
                        <div class="form-group clearfix ">
                            <div class="inline right_margin">
                                <label>Teamviewer ID</label>
                                <input type="text" name="TeamviewerID" class="form-control" value="<?php echo $res->TeamviewerID; ?>" readonly>
                            </div>
                            <div class="inline right_margin">                            
                                <label>Virtual Meeting Alarm</label>
                                <input type="text" name="VirtualMeetingAlarm" class="form-control" value="<?php echo $res->VirtualMeetingAlarm; ?>" readonly>
                            </div>
                            <div class="inline right_margin">                            
                                <label class="form-check-label" for="ZoomVideoID">ZoomVideo</label>
                                <input type="checkbox" class="form-check-input" value="Y" name="ZoomVideoID" <?php echo ($res->ZoomVideoID=="Y") ? 'checked' : ''; ?> onclick="return false;">
                            </div>
                            <div class="inline right_margin">
                                <label>UltraViewer ID</label>
                                <input type="text" name="UltraViewerID" class="form-control" value="<?php echo $res->UltraViewerID; ?>" readonly>
                            </div>
                            <div class="inline right_margin">
                                <label>Tax Software Names</label>
                                <input type="text" name="TaxSoftwareNames" class="form-control" value="<?php echo $res->TaxSoftwareNames; ?>" readonly>
                            </div>
                        </div> 
                        <?php 
                        if (!is_empty($res->PhotoFile)) { ?>
                                <div class="form-group clearfix ">
                                        <div class="col-sm-12"> 
                                            <div class="inline right_margin">                                    
                                                <label>Photo</label><br>
                                                <img src='<?php echo $res->PhotoFile; ?>'>                                    
                                            </div> 
                                        </div>
                                    </div>  
                        <?php } ?>
            
                        <?php 
                        if (!is_empty($res->SignatureFile)) { ?>
                                <div class="form-group clearfix ">
                                        <div class="col-sm-12"> 
                                            <div class="inline right_margin">                                    
                                                <label>Signature</label><br>
                                                <img src='<?php echo $res->SignatureFile; ?>'>                                    
                                            </div> 
                                        </div>
                                    </div>  
                        <?php }            
                        ?>        
            <br><br>
            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post" class="p-3">
                <input type="hidden" name="TaxPayerCyberId" class="form-control" value="<?php echo $res->CyberId; ?>">
                <div class="form-group clearfix ">
                    <div class="col-sm-12 ">
                        <div class="inline right_margin ">
                            <label>Appointment Date</label>
                            <input type="datetime-local" name="AppointmentDate" class="form-control" value="<?php echo $res->AppointmentDateT; ?>">                                            
                        </div>
                        <div class="inline right_margin ">
                            <label>Purpose Of Meeting</label>
                            <input type="text" name="PurposeOfMeeting" class="form-control" value="<?php echo $res->PurposeOfMeeting; ?>">        
                        </div> 
                        <div class="inline right_margin">  
                            <label>&nbsp;</label><br>
                            <input type="submit" class="btn btn-primary" name="action" value="<?php echo $Save_Value; ?>">
                        </div>
                        <div class="inline right_margin">                             
                            <?php 
                                if (!is_empty($Save_err)) { ?>
                                <label class="text-danger"><?php echo $Save_err; ?></label>
                            <?php } elseif (!is_empty($Save_Success)) { ?>
                                <label class="text-success"><?php echo $Save_Success; ?></label>
                            <?php } ?> 
                        </div>         
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