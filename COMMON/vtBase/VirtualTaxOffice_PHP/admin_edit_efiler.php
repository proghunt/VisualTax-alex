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
$Save_err = "";
$Save_Success = "";
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
                            <div class="col-sm-8">
                                <label>Business Name</label>
                                <input type="text" name="BusinessName" class="form-control" value="<?php echo restore_value_if_needed($res, "BusinessName"); ?>">
                            </div>
                            <div class="col-sm-2">                            
                                <label>Phone</label>
                                <input type="text" name="Phone" class="form-control" value="<?php echo restore_value_if_needed($res, "Phone"); ?>" >
                            </div>
                        </div>
                        <div class="form-group clearfix ">
                            <div class="col-sm-6 ">
                                <label>Street</label>
                                <input type="text" name="Street" class="form-control" value="<?php echo restore_value_if_needed($res, "Street"); ?>" >
                            </div>
                            <div class="col-sm-3 ">
                                <label>City</label>
                                <input type="text" name="City" class="form-control" value="<?php echo restore_value_if_needed($res, "City"); ?>" >
                            </div>
                            <div class="col-sm-1 ">
                                <label>Province</label>
                                <input type="text" name="Province" class="form-control" value="<?php echo restore_value_if_needed($res, "Province"); ?>" >
                            </div>
                            <div class="col-sm-2 ">
                                <label>Postal</label>
                                <input type="text" name="Postal" class="form-control" value="<?php echo restore_value_if_needed($res, "Postal"); ?>" >
                            </div>
                        </div>                   
                        <div class="form-group clearfix ">
                            <div class="col-sm-1">  
                                <input type="submit" class="btn btn-primary" name="action" value="<?php echo $Save_Value; ?>">
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