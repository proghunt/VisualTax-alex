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
  <script>
    function gotopage(page_no) {        
        src = "?page_no=" + page_no;
        src += "&records_per_page="+document.getElementById('records_per_page').value;
        src += "&searchFirstName="+document.getElementById('searchFirstName').value;
        src += "&searchLastName="+document.getElementById('searchLastName').value;
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
    function show_serviceRequest(CyberId) {        
        document.getElementById('modal_title').innerHTML = 'T1 Service Request';
        showPopup("T1ServiceRequest_view.php?CyberId=" + CyberId);
        return false;
    }    
  </script>
</head>
<body onLoad="tableLoad()">
    
<?php 

$_GET["action"] = "LIST_SERVICE_REQUESTS";
$_GET["FormId"] = 1;
$res = processApiRequest();

include "top.inc";

if ($res->success == "true") {     
    ?>
    <div>
        <table border=0 width=100%>
            <tr>
                <td>
                    <h2>T1 Service Requests</h2>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="form-group clearfix ">
                        <div class="inline right_margin">
                            <label>First Name</label>
                            <input type="text" id="searchFirstName" class="form-control" value="<?php echo isset($_GET["searchFirstName"]) ? $_GET["searchFirstName"] : ""; ?>">
                        </div>                          
                        <div class="inline right_margin">
                            <label>Last Name</label>
                            <input type="text" id="searchLastName" class="form-control" value="<?php echo isset($_GET["searchLastName"]) ? $_GET["searchLastName"] : ""; ?>">
                        </div>
                        <div class="inline right_margin">
                            <label>Postal</label>
                            <input type="text" id="searchPostal" class="form-control" value="<?php echo isset($_GET["searchPostal"]) ? $_GET["searchPostal"] : ""; ?>">
                        </div> 
                        <div class="inline right_margin">
                            <label>Status</label><br>
                            <label class="radio-inline"><input type="radio" id="P" name="searchStatus" value="P" <?php echo ((isset($_GET["searchStatus"]) ? $_GET["searchStatus"] : "P")=="P") ? 'checked' : ''; ?>>Ready for proposal</label>
                            <label class="radio-inline"><input type="radio" id="A" name="searchStatus" value="A" <?php echo ((isset($_GET["searchStatus"]) ? $_GET["searchStatus"] : "P")=="A") ? 'checked' : ''; ?>>Accepted</label>
                            <label class="radio-inline"><input type="radio" id="C" name="searchStatus" value="C" <?php echo ((isset($_GET["searchStatus"]) ? $_GET["searchStatus"] : "P")=="C") ? 'checked' : ''; ?>>Completed</label>
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
                <th>First Name</th>
                <th>Last Name</th>
                <th>Street</th>
                <th>City</th>
                <th>Province</th>
                <th>Postal</th>
                <th>Date Posted</th>
                <th>Status</th>
                <th></th>
            </tr>
    <?php
    foreach($res->result as $row) {
      ?>
        <tr class="<?php if ($row->OfficeStatus == "V") {echo "bg-warning"; } elseif ($row->OfficeStatus == "S") { echo "bg-info"; } ?>">
            <td><?php echo $row->CyberId ?></td>
            <td><?php echo $row->FirstName ?></td>
            <td><?php echo $row->LastName ?></td>
            <td><?php echo $row->Street ?></td>
            <td><?php echo $row->City ?></td>
            <td><?php echo $row->Province ?></td>
            <td><?php echo $row->Postal ?></td>   
            <td><?php echo $row->DatePosted ?></td>  
            <td><?php echo $row->OfficeStatusDesc ?></td> 
            <td>                
                <span data-toggle="modal" data-target="#myModal">
                    <button type="button" class="btn btn-info btn-sm" onclick="show_serviceRequest('<?php echo $row->CyberId; ?>')">View</button>
                </span>
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
