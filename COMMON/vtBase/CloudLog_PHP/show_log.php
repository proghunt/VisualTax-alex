<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Cloud Log Viewer</title>
  <style>
	table, td, th {
		border: 1px solid black;
	}

	table {
		border-collapse: collapse;
	}
  </style>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <script>
  $( function() {
    $( "#start_date" ).datepicker();
	$( "#start_date" ).attr("autocomplete", "off");
	$( "#end_date" ).datepicker();
	$( "#end_date" ).attr("autocomplete", "off");
  } );
  </script>
  <style>
	table, td, th {
		border: 1px solid black;
	}

	table {
		border-collapse: collapse;
	}
  </style>
</head>
<body>
<p><h1>Cloud Log Viewer</h1></p>
<p>
<form action="http://www.visualtax.com/CloudLog/show_log.php" method="post"> 
<div style="display:none"><input type="password" tabindex="-1"/></div>
Start Date:&nbsp;<input type="text" id="start_date" name="start_date" value="<?php echo $_POST["start_date"] ?>">
&nbsp;End Date:&nbsp;<input type="text" id="end_date" name="end_date" value="<?php echo $_POST["end_date"] ?>">
<?php

if ($_POST["password"] == "Igor") {
	echo "<input type=\"hidden\" name=\"password\" value=\"Igor\">";
}
else {
	echo "Password:&nbsp;<input type=\"password\" value=\"\" name=\"password\">";
}

?>
&nbsp;<input name= "action" type="submit" value="Search">

</form>
</p>
<?php
    
    function convertToCurrTime($v) {
        $currTZ = new DateTimeZone("UTC");
        $newTZ = new DateTimeZone("America/Toronto");  
        $date = new DateTime($v, $currTZ);
        $date->setTimezone($newTZ);
        return $date->format('Y-m-d H:i:s');
    }
    
    if ($_POST["password"] == "Igor") {

        try {    
            
            include 'init_database.php';        
           
            // Generate query 
            $query = " SELECT * FROM Logs WHERE 1 = 1 ";
            
            // Convert Dates
            if ($_POST["start_date"] != "") {						
                $startDate = DateTime::createFromFormat('m/d/Y',$_POST["start_date"]);
                $query = $query . " AND StartTime >= '" . $startDate->format("Y-m-d") . "'";
            }	

            if ($_POST["end_date"] != "") {						
                $endDate = DateTime::createFromFormat('m/d/Y',$_POST["end_date"]);
                $query = $query . " AND StartTime <= '" . $endDate->format("Y-m-d") . "'";
            }
    
            $query = $query . " ORDER BY Id";
            
            // Select all data from file db messages table 
            $result = $file_db->query($query);
            
            echo "<table border='1' width='100%'><tr>";
            echo "<th>CloudKey</th>";
            echo "<th>Preparer Name</th>";
            echo "<th>Email</th>";
            echo "<th>Phone</th>";
            echo "<th>Start Time</th>";
            echo "<th>End Time</th>";
            echo "</tr>";	
                      
            
            foreach($result as $row) {
              echo "<tr>";
              echo "<td>" . $row['CloudKey'] . "</td>";
              echo "<td>" . $row['PreparerName'] . "</td>";
              echo "<td>" . $row['Email'] . "</td>";
              echo "<td>" . $row['Phone'] . "</td>";            
              
              
              echo "<td>" . convertToCurrTime($row['StartTime']) . "</td>";
              echo "<td>" . convertToCurrTime($row['EndTime']) . "</td>";
              echo "</tr>";
            }
            echo "</table>";
            
            // Close file db connection
            $file_db = null;
            
        } catch(Exception $e) {
            echo $e->getMessage();
        }
    }
?>
 
</body>
</html>