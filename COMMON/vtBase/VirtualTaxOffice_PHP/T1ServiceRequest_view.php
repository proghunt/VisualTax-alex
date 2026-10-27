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

$form_id = 1;

$Save_Value = "Submit";
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
            $_POST["action"] = "SAVE_FORM_PROPOSAL"; 
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
$_GET["action"] = "LIST_FORM_ITEMS";
$_GET["FormId"] = $form_id;
if (!isset($_GET["CyberId"])) {
    $_GET["CyberId"] = $cyberid;
}
$res = processApiRequest();
$res->restore = $has_error;
if ($res->success == "true") {
    if ($need_refresh || $res->need_refresh) { ?>
            <script>
                parent.need_refresh = true;
            </script>
    <?php } ?>
    
    <div>          
        <div class="form-group clearfix">
            <div class="col-sm-12">                
                <table border=0 width=100%>
                    <tr>
                        <td>
                            <span>Date Posted: <strong><?php echo $res->DatePosted; ?></strong></span>
                        </td>
                        <td>
                            <span>Virtual Id: <strong><?php echo $res->CyberId; ?></strong></span>
                        </td>
                        <td>
                            <span>Virtual Client Name: <strong><?php echo $res->LastName . " " . $res->FirstName; ?></strong></span>
                        </td>
                        <td>
                            <span>Phone: <strong><?php echo $res->Area . " " . $res->Phone; ?></strong></span>
                        </td>
                        <td>
                            <span>E-mail: <strong><?php echo $res->Email; ?></strong></span>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="col-sm-12">
            <table border=0 width=100%>
                <tr>
                    <td>
                        <div class="form-group clearfix ">
                            <h2><?php echo $res->TaxFormName; ?></h2>
                        </div>
                    </td>                 
                    <td align=right>
                        <?php if ($res->AllowEdit) { ?>
                        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">  
                        <input type="hidden" name="CyberId" class="form-control" value="<?php echo $res->CyberId; ?>">
                        <?php } ?>
                        <div class="btn-group" role="group" aria-label="First group">
                            <button type="submit" name="draft" class="btn <?php echo $res->Status == "D" ? "btn-secondary": "btn-default" ;?>" disabled>Draft</button>
                            <button type="submit" name="proposal" class="btn <?php echo $res->Status == "P" ? "btn-warning": "btn-default" ;?>" disabled>Ready for Proposals</button>
                            <button type="submit" name="accept" class="btn <?php echo $res->Status == "A" ? "btn-info": "btn-default" ;?>" disabled>Accepted</button>
                            <button type="submit" name="complete" class="btn <?php echo $res->Status == "C" ? "btn-success": "btn-default" ;?>" disabled>Completed</button>                
                        </div>
                        <?php if ($res->AllowEdit) { ?>
                        </form>  
                        <?php } ?>
                    </td>
                </tr>
            </table>
        </div>        
    <?php 
        foreach($res->result as $section) {
            ?>
            <div class="col-sm-6">
                <div class="form-group clearfix ">
                    <label><?php echo $section->TaxSectionName; ?></label>
                </div>
                <?php 
                    foreach($section->items as $item) {
                        if ($item->TaxItemType == "B") {
                            ?>
                            <div class="form-group clearfix ">
                                <input type="checkbox" class="form-check-input" value="Y" name="I_<?php echo $item->ItemId;?>" 
                                    <?php if ($res->Readonly) {echo $checkbox_readonly; } ?>
                                    <?php echo $item->TaxItemValue == "Y" ? 'checked' : '';?>>
                                <span><?php echo $item->TaxItemName ?></span>
                                <?php 
                                    if ($item->HasCount == 'Y') {
                                        ?>
                                        <input type="text" class="form-control inline_input" name="Count_<?php echo $item->ItemId;?>" placeholder="Enter slips count"
                                               value="<?php echo $has_error && isset($_POST["Count_" . $item->ItemId]) ? $_POST["Count_" . $item->ItemId] : $item->CountValue; ?>" <?php if ($res->Readonly) {echo "readonly"; } ?>> 
                                        <?php
                                    }
                                ?>
                                <div id="DivNote_<?php echo $item->ItemId;?>" class="<?php echo ($item->TaxItemValue == "Y" && !$res->Readonly || !is_empty($item->Note)) ? 'show' : 'hidden'; ?>">
                                    <input type="text" class="form-control" name="Note_<?php echo $item->ItemId;?>" placeholder="Enter note here if needed"                                       
                                           value="<?php echo $has_error && isset($_POST["Note_" . $item->ItemId]) ? $_POST["Note_" . $item->ItemId] : $item->Note; ?>" <?php if ($res->Readonly) {echo "readonly"; } ?>> 
                                </div>
                            </div>
                            <?php
                        } 
                        else {
                            ?>
                            <div class="form-group clearfix ">
                                <span><?php echo $item->TaxItemName ?></span>
                                <input type="text" name="I_<?php echo $item->ItemId;?>" class="form-control" 
                                        value="<?php echo $has_error && isset($_POST["I_" . $item->ItemId]) ? $_POST["I_" . $item->ItemId] : $item->TaxItemValue; ?>" <?php if ($res->Readonly) {echo "readonly"; } ?>>
                            </div>
                            <?php
                        }
                    }                
                ?>            
            </div>
            
            <?php
        }
    ?>   
        
        <?php if (!$res->ProposalId == 0) { ?>
            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post" class="p-3">
            <input type="hidden" name="TaxFormProposalId" class="form-control" value="<?php echo $res->ProposalId; ?>">        
            <input type="hidden" name="TaxPayerCyberId" class="form-control" value="<?php echo $res->CyberId; ?>">
                <div class="form-group clearfix ">
                    <div class="col-sm-2 ">
                        <label>Expected Total Cost</label>
                        <input type="text" name="ExpectedTotalCost" class="form-control" value="<?php echo restore_value_if_needed($res, "ExpectedTotalCost"); ?>" <?php echo $res->Status != "P" ? "readonly" : ""?>>
                    </div>
                    <div class="col-sm-3 ">
                        <label>Expected Completion Date</label>
                        <input type="date" name="ExpectedCompletionDate" class="form-control" value="<?php echo restore_value_if_needed($res, "ExpectedCompletionDate"); ?>" <?php echo $res->Status <> "P" ? "readonly" : ""?>>
                    </div>                
                </div>
                <div class="form-group clearfix ">
                    <div class="col-sm-12 ">
                        <label>Office Note</label>
                        <input type="text" name="OfficeNote" class="form-control" value="<?php echo restore_value_if_needed($res, "OfficeNote"); ?>" <?php echo $res->Status <> "P" ? "readonly" : ""?>>
                    </div>                                   
                </div>
                <div class="form-group clearfix">
                    <div class="col-sm-2">  
                        <input type="submit" class="btn btn-primary" name="action" value="<?php echo $Save_Value; ?>" <?php echo $res->Status <> "P" ? "disabled" : ""?>>
                    </div>
                    <div class="col-sm-10">                             
                        <?php 
                            if (!is_empty($Save_err)) { ?>
                            <label class="text-danger"><?php echo $Save_err; ?></label>
                        <?php } elseif (!is_empty($Save_Success)) { ?>
                            <label class="text-success"><?php echo $Save_Success; ?></label>
                        <?php } ?> 
                    </div>                            
                </div>
            </form>
        <?php } ?>
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