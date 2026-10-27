<?php
// Initialize the session
if (session_id() == ''){
    session_start();
}

require_once "apicontroller.php";

if($_SERVER["REQUEST_METHOD"] == "POST") {   
    if (isset($_POST["action"])) {
        if ($_POST["action"] == "Logout") {
            logout();
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
    function gotopage(page_no) {        
        src = "?page_no=" + page_no;
        var radios = document.getElementsByName('searchStatus');
        for (var i = 0, length = radios.length; i < length; i++) {
          if (radios[i].checked) {
            src += "&searchStatus="+radios[i].value;            
            break;
          }
        }
        url_redirect(src);
        return false;
    }
    
    function updateStatus(id, status, undo) {

        const formData = new FormData();
        if (status == "A") {
            formData.append('action', 'ACCEPT_PROPOSAL');
        } 
        else if (status == "C") {
            formData.append('action', 'COMPLETE_PROPOSAL');
        }
        else {
            return false;
        }
        if (undo == 1) {
            formData.append('undo', 'true');
        }
        formData.append('TaxFormProposalId', id);
        var request = new XMLHttpRequest();
        request.open('POST', 'api.php', false);
        try {
            request.send(formData);
            result = JSON.parse(request.response);
            if (result.success!="true") {                    
                alert(result.error_message);
            }
            else {
                parent.need_refresh = true;
                document.getElementById('N').checked = false;
                document.getElementById('A').checked = true;
                document.getElementById('Search').click();
                //location.reload();
            }
        }
        catch (error) {
            alert(error + '\n\n' + request.response);
        }            
}
  </script>
</head>
<body onLoad="tableLoad()">
    
<?php 

if (!isset($_GET["searchStatus"])) {
    $_GET["searchStatus"] = $_SESSION["T1RequestsProposalCount"] > 0 ? "N" : "A";   
}

$form_id = 1;
$Accept_Value = "Accept";
$Undo_Accept_Value = "Revoke Acceptance";
$Complete_Value = "Complete";
$Undo_Complete_Value = "Undo Completion";
$Error = "";
$has_error = false;

if($_SERVER["REQUEST_METHOD"] == "POST") {   
    if (isset($_POST["action"])) {
        if ($_POST["action"] == $Accept_Value) {
            $_POST["action"] = "ACCEPT_PROPOSAL"; 
            $res = processApiRequest();
            if ($res->success != "true") {
                $has_error = true;
                $Error = $res->error_message;
            }            
        }
        elseif ($_POST["action"] == $Undo_Accept_Value) {
            $_POST["action"] = "ACCEPT_PROPOSAL"; 
            $_POST["undo"] = "true"; 
            $res = processApiRequest();
            if ($res->success != "true") {
                $has_error = true;
                $Error = $res->error_message;
            }            
        } 
        elseif ($_POST["action"] == $Complete_Value) {
            $_POST["action"] = "COMPLETE_PROPOSAL"; 
            $res = processApiRequest();
            if ($res->success != "true") {
                $has_error = true;
                $Error = $res->error_message;
            }            
        }
        elseif ($_POST["action"] == $Undo_Complete_Value) {
            $_POST["action"] = "COMPLETE_PROPOSAL"; 
            $_POST["undo"] = "true"; 
            $res = processApiRequest();
            if ($res->success != "true") {
                $has_error = true;
                $Error = $res->error_message;
            }            
        } 
    }
}

$_GET["action"] = "SHOW_PROPOSALS";
$_GET["FormId"] = $form_id;
$res = processApiRequest();

if ($res->success == "true") { 
    if ($res->need_refresh) { ?>
            <script>
                parent.need_refresh = true;
            </script>
    <?php } ?>
    <div>
        <?php 
            if (!is_empty($Error)) { ?>
            <div class="alert alert-danger">
              <strong>Error!</strong> <?php echo $Error; ?>
            </div>
        <?php } ?> 
        <table border=0 width=100%>
            <tr>
                <td>
                    <div class="form-group clearfix ">
                        <div class="col-sm-12 ">
                            <label class="radio-inline"><input type="radio" id="N" name="searchStatus" value="N" <?php echo $_GET["searchStatus"] =="N" ? 'checked' : ''; ?>>New</label>
                            <label class="radio-inline"><input type="radio" id="A" name="searchStatus" value="A" <?php echo $_GET["searchStatus"] =="A" ? 'checked' : ''; ?>>All</label>                            
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="submit" class="btn btn-primary" id="Search" name="action" value="Search" onclick="gotopage(<?php echo $res->page_no;?>)">
                        </div>                                                  
                    </div>
                </td>
            </tr>
        </table>
        <label id="loading" style="visibility: hidden;">Loading ..</label>        
        <table id="offices" class="table-bordered table-condensed table-responsive" style="visibility: visible;" width=100%>
            <tr>
                <th rowspan=2>Virtual Office Id</th>
                <th rowspan=2>Business Name</th>
                <th rowspan=2>E-mail</th>
                <th rowspan=2>Contact</th>                
                <th rowspan=2>Area</th>
                <th rowspan=2>Phone</th>
                <th colspan=2 class="text-center">Expected</th>                
                <th rowspan=2>Office Note</th>
                <th rowspan=2></th>
            </tr>
            <tr>
                <th>Total Cost</th>
                <th>Completion Date</th>
            </tr>
    <?php
    foreach($res->result as $row) {
      ?>
        <tr class="<?php 
            if ($row->PayerStatus == "A" && $res->Status == "A") {echo "bg-info"; }
            elseif ($row->PayerStatus == "A" && $res->Status == "C") {echo "bg-success"; }
            ?>">
            <td><?php echo $row->CyberId ?></td>
            <td><?php echo $row->BusinessName ?></td>
            <td><?php echo $row->Email ?></td>
            <td><?php echo $row->Contact ?></td>            
            <td><?php echo $row->Area ?></td>
            <td><?php echo $row->Phone ?></td>
            <td><?php echo $row->ExpectedTotalCost ?></td>
            <td><?php echo $row->ExpectedCompletionDate ?></td>
            <td><?php echo $row->OfficeNote ?></td>
            <td>                
                <?php if ($res->Status == 'P') { ?>
                    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
                        <button type="button" class="btn btn-info btn-sm" name="action" onclick='updateStatus(<?php echo $row->Id; ?>, "A", 0)'><?php echo $Accept_Value; ?></button>
                    </form>
                <?php } 
                    elseif ($row->PayerStatus == "A" && $res->Status == "A") { ?>
                        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
                        <button type="button" class="btn btn-warning btn-sm" name="action" onclick='updateStatus(<?php echo $row->Id; ?>, "A", 1)'><?php echo $Undo_Accept_Value; ?></button>
                        <button type="button" class="btn btn-success btn-sm" name="action" onclick='updateStatus(<?php echo $row->Id; ?>, "C", 0)'><?php echo $Complete_Value; ?></button>
                    </form>
                <?php }
                    elseif ($row->PayerStatus == "A" && $res->Status == "C") { ?>
                        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
                        <button type="button" class="btn btn-warning btn-sm" name="action" onclick='updateStatus(<?php echo $row->Id; ?>, "C", 1)'><?php echo $Undo_Complete_Value; ?></button>
                    </form>
                <?php }
                ?>
            </td>
        </tr>        
    <?php  
    }
    ?>    
    </table>   
    
    <?php include 'paginator.php';?>
    
    </div> 

<!-- Modal -->
<div id="myModal" class="modal fade" role="dialog" data-keyboard="false" data-backdrop="static">
  <div id="modaldlg" class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div id="modalheader" class="modal-header">
        <button type="button" class="close" data-dismiss="modal" onclick="if (need_refresh) { location.reload() }">&times;</button>
        <h4 class="modal-title">Edit Tax Office</h4>
      </div>
      <div class="modal-body">
        <iframe id="editFrame" seamless=""></iframe>
      </div>
    </div>

  </div>
</div>   

<?php 
} else { 
?>
<br><br>
<div class="alert alert-danger">
    <strong>Error!</strong> <?php echo $res->error_message; ?>
</div>
<?php } ?>
        </td>
    </tr>
    <tr class="page_footer"><td colspan=2><div id="bottom_corner"></div></td></tr>
</table>   
</body>
</html>
