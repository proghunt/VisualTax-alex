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
  <script>
    function checkbox_click(id) {        
        cb = document.getElementById('I_' + id);
        dn = document.getElementById('DivNote_' + id);

        if (cb && dn) {            
            if (cb.checked) {
                dn.className = 'show';                
            }
            else {
                dn.className = 'hidden';
            }
        }
    }
  </script>
</head>
<body>

<?php 

$form_id = 1;

$Save_Value = "Save";
$Save_err = "";
$Save_Success = "";
$has_error = false;

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
            $_POST["action"] = "SAVE_FORM_ITEMS"; 
            $_POST["FormId"] = $form_id;            
            $res = processApiRequest();
            if ($res->success != "true") {
                $has_error = true;
                $Save_err = $res->error_message;
            }
            else {
                $Save_Success = "Changes were saved successfully";
            }
        }
    } 
    elseif (isset($_POST["draft"]) || isset($_POST["accept"]) || isset($_POST["proposal"]) || isset($_POST["complete"])) {
        if (isset($_POST["draft"])) {
            $_POST["Status"] = "D";
        } 
        elseif (isset($_POST["proposal"])) {
            $_POST["Status"] = "P";
        }
        elseif (isset($_POST["accept"])) {
            $_POST["Status"] = "A";
        }
        elseif (isset($_POST["complete"])) {
            $_POST["Status"] = "C";
        }
        $_POST["FormId"] = $form_id;
        $_POST["action"] = "SET_FORM_STATUS"; 
        $res = processApiRequest();
        if ($res->success != "true") {
            $has_error = true;
            $Save_err = $res->error_message;
        }
        else {
            $Save_Success = "Changes were saved successfully";
        }
    }
}

$_SERVER["REQUEST_METHOD"] = "GET";
$_GET["action"] = "LIST_FORM_ITEMS";
$_GET["FormId"] = $form_id;
$res = processApiRequest();

include "top.inc";

if ($res->success == "true") {
    ?>
    
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
                    <td>
                        <div class="btn-group" role="group">
                            <span data-toggle="modal" data-target="#myModal">
                                <button type="button" class="btn btn-primary" onclick='showPopup("taxpayer_show_proposals.php");'>Show Proposals 
                                    <?php if ($_SESSION["T1RequestsProposalCount"] > 0) { ?><span class="badge badge-light"><?php echo $_SESSION["T1RequestsProposalCount"]?></span> <?php }?>
                                </button>
                            </span>
                        </div>
                    </td>
                    <td align=right>
                        <?php if ($res->AllowEdit) { ?>
                        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">  
                        <input type="hidden" name="CyberId" class="form-control" value="<?php echo $res->CyberId; ?>">
                        <?php } ?>
                        <div class="btn-group" role="group">
                            <button type="submit" name="draft" class="btn <?php echo $res->Status == "D" ? "btn-secondary": "btn-default" ;?>" <?php echo $res->Status == "P" || $res->Status == "D" ? "" : "disabled"?>>Draft</button>
                            <button type="submit" name="proposal" class="btn <?php echo $res->Status == "P" ? "btn-warning": "btn-default" ;?>" <?php echo $res->Status == "P" || $res->Status == "D" ? "" : "disabled"?>>Ready for Proposals</button>
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
        <?php if ($res->AllowEdit) { ?>
        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post" class="p-3"> 
        <input type="hidden" name="CyberId" class="form-control" value="<?php echo $res->CyberId; ?>">        
        <?php } ?>
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
                                <input type="checkbox" class="form-check-input" value="Y" name="I_<?php echo $item->ItemId;?>" id="I_<?php echo $item->ItemId;?>" 
                                    <?php if ($res->Readonly) {echo $checkbox_readonly; } ?>
                                    <?php echo $item->TaxItemValue == "Y" ? 'checked' : '';?>
                                    onclick="checkbox_click(<?php echo $item->ItemId;?>);">
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
                                <input type="text" class="form-control inline_input" name="I_<?php echo $item->ItemId;?>"
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
        
    <?php if ($res->AllowEdit) { ?>
        <div class="form-group clearfix">
                <div class="col-sm-2">  
                    <input type="submit" class="btn btn-primary" name="action" value="<?php echo $Save_Value; ?>" <?php if ($res->Readonly) {echo "disabled"; } ?>>
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
<?php }
include "bottom.inc";
?>        

<!-- Modal -->
<div id="myModal" class="modal fade" role="dialog" data-keyboard="false" data-backdrop="static">
  <div id="modaldlg" class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div id="modalheader" class="modal-header">
        <button type="button" class="close" data-dismiss="modal" onclick="if (need_refresh) { location.reload() }">&times;</button>
        <h4 class="modal-title">Show Proposals</h4>
      </div>
      <div class="modal-body">
        <iframe id="editFrame" seamless=""></iframe>
      </div>
    </div>

  </div>
</div>   

</body>
</html>