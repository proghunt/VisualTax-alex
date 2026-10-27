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
  <script>
    function gotopage(page_no) {        
        src = "?page_no=" + page_no;
        src += "&records_per_page="+document.getElementById('records_per_page').value;
        src += "&searchCyberId="+document.getElementById('searchCyberId').value;
        src += "&searchLastName="+document.getElementById('searchLastName').value;
        src += "&searchFirstName="+document.getElementById('searchFirstName').value;
        src += "&searchEmail="+document.getElementById('searchEmail').value;
        src += "&searchPostal="+document.getElementById('searchPostal').value;
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
  </script>
</head>
<body onLoad="tableLoad()">
    
<?php 

if (!isset($_GET["searchStatus"])) {
    $_GET["searchStatus"] = "ALL";   
}

$_GET["action"] = "LIST_PAYERS";
$res = processApiRequest();

include "top.inc";

if ($res->success == "true") {     
    ?>    
        <table border=0 width=100%>
            <tr>
                <td>
                    <h2>Virtual Clients</h2>
                </td>
            </tr> 
            <tr>
                <td>
                    <div class="form-group clearfix ">
                        <div class="inline right_margin">
                            <label>Virtual Id</label>
                            <input type="text" id="searchCyberId" class="form-control" value="<?php echo isset($_GET["searchCyberId"]) ? $_GET["searchCyberId"] : ""; ?>">
                        </div>                          
                        <div class="inline right_margin">
                            <label>Last Name</label>
                            <input type="text" id="searchLastName" class="form-control" value="<?php echo isset($_GET["searchLastName"]) ? $_GET["searchLastName"] : ""; ?>">
                        </div>
                        <div class="inline right_margin">
                            <label>First Name</label>
                            <input type="text" id="searchFirstName" class="form-control" value="<?php echo isset($_GET["searchFirstName"]) ? $_GET["searchFirstName"] : ""; ?>">
                        </div>
                        <div class="inline right_margin">
                            <label>E-mail</label>
                            <input type="text" id="searchEmail" class="form-control" value="<?php echo isset($_GET["searchEmail"]) ? $_GET["searchEmail"] : ""; ?>">
                        </div> 
                        <div class="inline right_margin">
                            <label>Postal</label>
                            <input type="text" id="searchPostal" class="form-control" value="<?php echo isset($_GET["searchPostal"]) ? $_GET["searchPostal"] : ""; ?>">
                        </div>   
                        <div class="inline right_margin content-checkbox"> 
                            <label>Status</label><br>
                            <label class="radio-inline"><input type="radio" name="searchStatus" value="A" <?php echo ((isset($_GET["searchStatus"]) ? $_GET["searchStatus"] : "")=="A") ? 'checked' : ''; ?>>Active</label>
                            <label class="radio-inline"><input type="radio" name="searchStatus" value="I" <?php echo ((isset($_GET["searchStatus"]) ? $_GET["searchStatus"] : "")=="I") ? 'checked' : ''; ?>>Inactive</label>
                            <label class="radio-inline"><input type="radio" name="searchStatus" value="ALL" <?php echo ((isset($_GET["searchStatus"]) ? $_GET["searchStatus"] : "")=="ALL") ? 'checked' : ''; ?>>All</label>
                        </div>                         
                        <div class="inline right_margin"> 
                            <label>&nbsp;</label><br>
                            <input type="submit" class="btn btn-primary" name="action" value="Search" onclick="gotopage(<?php echo $res->page_no;?>)">
                        </div>
                    </div>
                </td>
            </tr>                 
        </table>
        <label id="loading">Loading ..</label>        
        <table id="offices" class="table-bordered table-condensed table-responsive" style="visibility: visible;" width=100%>
            <tr>
                <th>Virtual Id</th>
                <th>Last Name</th>
                <th>First Name</th>
                <th>E-mail</th>                
                <th>Street</th>
                <th>City</th>
                <th>Province</th>
                <th>Postal</th>
                <th>Area</th>
                <th>Phone</th>
                <th>Active</th>
                <th></th>
            </tr>
    <?php
    foreach($res->result as $row) {
      ?>
        <tr>
            <td><?php echo $row->CyberId ?></td>
            <td><?php echo $row->LastName ?></td>
            <td><?php echo $row->FirstName ?></td>
            <td><?php echo $row->Email ?></td>
            <td><?php echo $row->Street ?></td>
            <td><?php echo $row->City ?></td>
            <td><?php echo $row->Province ?></td>
            <td><?php echo $row->Postal ?></td>
            <td><?php echo $row->Area ?></td>
            <td><?php echo $row->Phone ?></td>
            <td><input id="cb<?php echo $row->CyberId ?>" type="checkbox" class="form-check-input" <?php echo ($row->Status=="A") ? "checked" : ""; ?> onClick="statusCheck('<?php echo $row->CyberId ?>')">
            <td>                
                <span data-toggle="modal" data-target="#myModal">
                    <button type="button" class="btn btn-info btn-sm" onclick="showPopup('admin_edit_taxpayer.php?CyberId=<?php echo $row->CyberId; ?>')">Edit</button>
                </span>
            </td>
        </tr>        
    <?php  
    }
    ?>    
    </table>   
    
    <?php include 'paginator.php';?>
    

<!-- Modal -->
<div id="myModal" class="modal fade" role="dialog" data-keyboard="false" data-backdrop="static">
  <div id="modaldlg" class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div id="modalheader" class="modal-header">
        <button type="button" class="close" data-dismiss="modal" onclick="if (need_refresh) { location.reload() }">&times;</button>
        <h4 class="modal-title">Edit Virtual Client</h4>
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
<?php } 
include "bottom.inc";
?>   

</body>
</html>
