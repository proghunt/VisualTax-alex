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
        src += "&searchBusinessName="+document.getElementById('searchBusinessName').value;
        src += "&searchPostal="+document.getElementById('searchPostal').value;
        url_redirect(src);
        return false;
    }   
    function showmap() {        
        document.getElementById('modal_title').innerHTML = 'Show on map';
        showPopup("show_efilers_on_map.php");
        return false;
    }  
    function edit_efiler(CyberId) {        
        document.getElementById('modal_title').innerHTML = 'Edit efiler';
        showPopup("admin_edit_efiler.php?CyberId=" + CyberId);
        return false;
    }    
  </script>
</head>
<body onLoad="tableLoad()">
    
<?php 

$_GET["action"] = "LIST_EFILERS";
$res = processApiRequest();

include "top.inc";

if ($res->success == "true") {     
    ?>
    <div>
        <table border=0 width=100%>
            <tr>
                <td>
                    <h2>Efilers</h2>
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
                            <label>Business Name</label>
                            <input type="text" id="searchBusinessName" class="form-control" value="<?php echo isset($_GET["searchBusinessName"]) ? $_GET["searchBusinessName"] : ""; ?>">
                        </div>
                        <div class="inline right_margin">
                            <label>Postal</label>
                            <input type="text" id="searchPostal" class="form-control" value="<?php echo isset($_GET["searchPostal"]) ? $_GET["searchPostal"] : ""; ?>">
                        </div>                        
                        <div class="inline right_margin"> 
                            <label>&nbsp;</label><br>
                            <input type="submit" class="btn btn-primary" name="action" value="Search" onclick="gotopage(<?php echo $res->page_no;?>)">
                        </div>
                        <div class="inline right_margin float_right"> 
                            <label>&nbsp;</label><br>
                            <span data-toggle="modal" data-target="#myModal">
                                <button type="button" class="btn btn-primary" onclick="showmap()">Show on map</button>
                            </span>
                        </div>
                    </div>
                </td>
            </tr>            
        </table>
        <label id="loading">Loading ..</label>        
        <table id="offices" class="table-bordered table-condensed table-responsive" style="visibility: visible;" width=100%>
            <tr>
                <th>Virtual Id</th>
                <th>Name</th>
                <th>Phone</th>
                <th>Street</th>
                <th>City</th>
                <th>Province</th>
                <th>Postal</th>
                <th></th>
            </tr>
    <?php
    foreach($res->result as $row) {
      ?>
        <tr>
            <td><?php echo $row->CyberId ?></td>
            <td><?php echo $row->BusinessName ?></td>
            <td><?php echo $row->Phone ?></td>
            <td><?php echo $row->Street ?></td>
            <td><?php echo $row->City ?></td>
            <td><?php echo $row->Province ?></td>
            <td><?php echo $row->Postal ?></td>   
            <td>                
                <span data-toggle="modal" data-target="#myModal">
                    <button type="button" class="btn btn-info btn-sm" onclick="edit_efiler('<?php echo $row->CyberId; ?>')">Edit</button>
                </span`>
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
            <h4 id="modal_title" class="modal-title">Show on map</h4>
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
