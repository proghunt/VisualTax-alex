<?php

// Initialize the session
if (session_id() == ''){
    session_start();
}
 
// Check if the user is logged in, if not then redirect him to login page
if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true) {
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
    
$_SERVER["REQUEST_METHOD"] = "GET";
$_GET["action"] = "LOAD_PROFILE";
$res = processApiRequest();
if ($res->success == "true") {
                ?>                
                <div class="jumbotron white_bg">
                        
                        <div class="form-group clearfix ">
                            <div class="col-sm-2">
                                <label>Virtual Id</label>
                                <input type="text" name="CyberId" class="form-control" value="<?php echo $res->CyberId; ?>" readonly>
                            </div>                          
                            <div class="col-sm-6">
                                <label>Business Name</label>
                                <input type="text" name="BusinessName" class="form-control" value="<?php echo $res->BusinessName; ?>" readonly>
                            </div>
                            <div class="col-sm-4 ">
                                <label>E-mail</label>
                                <input type="text" name="Email" class="form-control" value="<?php echo $res->Email; ?>" readonly>
                            </div>
                        </div>
                        <div class="form-group clearfix ">                            
                            <div class="col-sm-4 ">
                                <label>WebSite</label>
                                <input type="text" name="WebSiteUrl" class="form-control" value="<?php echo $res->WebSiteUrl; ?>" readonly>
                            </div>
                            <div class="col-sm-4 ">
                                <label>Contact</label>
                                <input type="text" name="Contact" class="form-control" value="<?php echo $res->Contact; ?>" readonly>
                            </div>
                            <!--<div class="col-sm-2 ">
                                <label class="form-check-label" for="HaveCRAEfilerNumber">Have CRA Efiler Number</label><br>
                                <input type="checkbox" class="form-check-input" value="Y" name="HaveCRAEfilerNumber" <?php echo ($res->HaveCRAEfilerNumber=="Y") ? 'checked' : ''; ?> onclick="return false;">
                            </div>
                            <div class="col-sm-2 ">
                                <label>CRA Efiler Name</label>
                                <input type="text" name="CRAEfilerName" class="form-control" value="<?php echo $res->CRAEfilerName; ?>">
                            </div>-->
                        </div>
                        <div class="form-group clearfix ">
                            <div class="col-sm-6 ">
                                <label>Street</label>
                                <input type="text" name="Street" class="form-control" value="<?php echo $res->Street; ?>" readonly>
                            </div>
                            <div class="col-sm-3 ">
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
                            <div class="col-sm-2">
                                <label>Teamviewer ID</label>
                                <input type="text" name="TeamviewerID" class="form-control" value="<?php echo $res->TeamviewerID; ?>" readonly>
                            </div>
                            <div class="col-sm-2">                            
                                <label>Virtual Meeting Alarm</label>
                                <input type="text" name="VirtualMeetingAlarm" class="form-control" value="<?php echo $res->VirtualMeetingAlarm; ?>" readonly>
                            </div>
                            <div class="col-sm-1">                            
                                <label class="form-check-label" for="ZoomVideoID">ZoomVideo</label>
                                <input type="checkbox" class="form-check-input" value="Y" name="ZoomVideoID" <?php echo ($res->ZoomVideoID=="Y") ? 'checked' : ''; ?> onclick="return false;">
                            </div>
                            <div class="col-sm-1">                            
                                <label class="form-check-label" for="UltraViewerID">UltraViewer</label>
                                <input type="checkbox" class="form-check-input" value="Y" name="UltraViewerID" <?php echo ($res->UltraViewerID=="Y") ? 'checked' : ''; ?> onclick="return false;">                                
                            </div>
                            <div class="col-sm-2">
                                <label>Tax Software Names</label>
                                <input type="text" name="TaxSoftwareNames" class="form-control" value="<?php echo $res->TaxSoftwareNames; ?>" readonly>
                            </div>
                        </div>   
                        <div class="form-group clearfix ">   
                            <div class="col-sm-2">
                                <label>Years in business</label>
                                <input type="text" name="YearsInBusiness" class="form-control" value="<?php echo $res->YearsInBusiness; ?>" readonly>
                            </div>
                            <div class="col-sm-10">                                
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T1">T1</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T1" <?php echo ($res->T1=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T2">T2</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T2" <?php echo ($res->T2=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T3">T3</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T3" <?php echo ($res->T3=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T4T5">T4T5</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T4T5" <?php echo ($res->T4T5=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="NR4">NR4</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="NR4" <?php echo ($res->NR4=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T3010">T3010</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T3010" <?php echo ($res->T3010=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T5013">T5013</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T5013" <?php echo ($res->T5013=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="T5018">T5018</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="T5018" <?php echo ($res->T5018=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="vtNOA">vtNOA</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="vtNOA" <?php echo ($res->vtNOA=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                                <div class="col-sm-1">                            
                                    <label class="form-check-label" for="Other">Other</label><br>
                                    <input type="checkbox" class="form-check-input" value="Y" name="Other" <?php echo ($res->Other=="Y") ? 'checked' : ''; ?> onclick="return false;">
                                </div>
                            </div>
                        </div>    
                        <div class="form-group clearfix ">    
                            <div class="col-sm-5">
                                <label>Other Service Description</label>
                                <input type="text" name="OtherServiceDescription" class="form-control" value="<?php echo $res->OtherServiceDescription; ?>" readonly>
                            </div>
                            <div class="col-sm-7">
                                <label for="Experience">Experience</label>
                                <textarea class="form-control" name="Experience" rows="3" readonly><?php echo $res->Experience; ?></textarea>
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
<?php 
}    
?>          
</body>
</html>
