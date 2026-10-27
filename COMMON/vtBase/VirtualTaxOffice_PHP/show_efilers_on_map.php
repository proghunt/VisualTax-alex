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
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="css/virtualtaxoffice.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  <script src="js/virtualtaxoffice.js"></script>  
  <script src="https://maps.googleapis.com/maps/api/js?key=<?php echo GOOGLE_KEY;?>&callback=initMap&libraries=&v=weekly" defer></script>
  <script>
        function initialize() {
            var myLatlng = new google.maps.LatLng( 54.7199036, -113.7409905 );
            var myOptions = {
                zoom: 4,
                center: myLatlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            var map = new google.maps.Map( document.getElementById( "map_canvas" ), myOptions );
            infowindow = new google.maps.InfoWindow();
            
            var points = 
            <?php                 
                $_GET["action"] = "LIST_EFILERS_FOR_MAP";
                $res = processApiRequest();
                if ($res->success == "true") { 
                    echo json_encode($res->points);
                }
                else {
                    ?> alert(<?php echo $res->error_message; ?>); <?php
                }            
            ?>;
            
            for (var m in points) {
                var myLatlng = new google.maps.LatLng(points[m].Latitude,points[m].Longitude);
                
                var marker = new google.maps.Marker({
                    position: myLatlng,
                    map: map,
                    title: points[m].BusinessName,
                    CyberId: points[m].CyberId,
                    Postal: points[m].Postal
                });
                
                google.maps.event.addListener(marker, 'click', function() {
                    var content = '';  
                    content += '<div><div class="col-sm-3">Virtual Id</div><div class="col-sm-9"><label>'+ this.CyberId +'</label></div></div>';
                    content += '<div><div class="col-sm-3">Name</div><div class="col-sm-9"><label>'+ this.title +'</label></div></div>';
                    content += '<div><div class="col-sm-3">Postal</div><div class="col-sm-9"><label>'+ this.Postal +'</label></div></div>';
                    content += '<div><div class="col-sm-12"><button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#myModal" onclick="showPopup(\'admin_edit_efiler.php?CyberId='+ this.CyberId +'\')">Open</button></div></div>';
                    content += ''
                    infowindow.setContent(content);
                    infowindow.open(map, this);
                });
            }
        }
  </script>
  <style>
        html {
            height: 100%;
            overflow: hidden;
        }
        body {
            margin: 0;
            padding: 0;
            height: 100%;
        }
        #map_canvas {
            height: 100%;
        }
    </style>
</head>
<body onload="initialize()">

    <div>
        <table border=0 width=100%>
            <tr>
                <td>
                    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="get">
                    <div class="form-group clearfix ">
                        <div class="col-sm-1">
                            <label>Virtual Id</label>
                            <input type="text" id="searchCyberId" name="searchCyberId" class="form-control" value="<?php echo isset($_GET["searchCyberId"]) ? $_GET["searchCyberId"] : ""; ?>">
                        </div>                          
                        <div class="col-sm-2">
                            <label>Business Name</label>
                            <input type="text" id="searchBusinessName" name="searchBusinessName" class="form-control" value="<?php echo isset($_GET["searchBusinessName"]) ? $_GET["searchBusinessName"] : ""; ?>">
                        </div>
                        <div class="col-sm-1">
                            <label>Postal</label>
                            <input type="text" id="searchPostal" name="searchPostal" class="form-control" value="<?php echo isset($_GET["searchPostal"]) ? $_GET["searchPostal"] : ""; ?>">
                        </div>                        
                        <div class="col-sm-1"> 
                            <label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                            <input type="submit" class="btn btn-primary" name="action" value="Search"">
                        </div>
                    </div>
                    </form>
                </td>
            </tr>            
        </table>
    </div> 
    
    <div id="map_canvas"></div>
    
    <!-- Modal -->
    <div id="myModal" class="modal fade" role="dialog" data-keyboard="false" data-backdrop="static">
      <div id="modaldlg" class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
          <div id="modalheader" class="modal-header">
            <button type="button" class="close" data-dismiss="modal" onclick="if (need_refresh) { location.reload() }">&times;</button>
            <h4 class="modal-title">Efiler Profile</h4>
          </div>
          <div class="modal-body">
            <iframe id="editFrame" seamless=""></iframe>
          </div>
        </div>

      </div>
    </div> 
   
</body>
</html>
