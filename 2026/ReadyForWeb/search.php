<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>AppMon Viewer</title>
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
<p><h1>AppMon Viewer</h1></p>
<p>
<form action="https://www.visualtax.com/AppMon/search.php" method="post"> 
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
&nbsp;<input name= "action" type="submit" value="Init Database">

</form>
</p>
<?php
if ($_POST["password"] == "Igor") {
    if ($_POST["action"] == "Search") {
        echo "<hr>";
        echo "<p>Results</p>";
        
        try {    
            
            include 'init_database.php';        
           
            // Generate query 
            $query = "SELECT * FROM SaveLog WHERE IFNULL(AppName, '') <> ''";
            
            // Convert Dates
            if ($_POST["start_date"] != "") {						
                $startDate = DateTime::createFromFormat('m/d/Y',$_POST["start_date"]);
                $query = $query . " AND EventDate >= '" . $startDate->format("Y-m-d") . "'";
            }	

            if ($_POST["end_date"] != "") {						
                $endDate = DateTime::createFromFormat('m/d/Y',$_POST["end_date"]);
                $query = $query . " AND EventDate <= '" . $endDate->format("Y-m-d") . "'";
            }
            
            $query = $query . " ORDER BY EventDate";
            
            // Select all data from file db messages table 
            $result = $file_db->query($query);
            
            echo "<table border='1' width='100%'><tr>";
            echo "<th>AppName</th>";
            echo "<th>AppKey</th>";
            echo "<th>License Level</th>";
            echo "<th>Event Date</th>";
            echo "<th>Computer Name</th>";
            echo "<th>Preparer Name</th>";
            echo "<th>Preparer Address</th>";
            echo "<th>Return Count</th>";
            echo "<th>FileName</th>";
            echo "<th>Efile Number</th>";
            echo "<th>Taxation Year</th>";
            echo "<th>Additional Info</th>";
            echo "</tr>";		
            
            foreach($result as $row) {
              echo "<tr>";
              echo "<td>" . $row['AppName'] . "</td>";
              echo "<td>" . $row['AppKey'] . "</td>";
              echo "<td>" . $row['LicenseLevel'] . "</td>";
              echo "<td>" . $row['EventDate'] . "</td>";
              echo "<td>" . $row['ComputerName'] . "</td>";
              echo "<td>" . $row['PreparerName'] . "</td>";
              echo "<td>" . $row['PreparerAddress'] . "</td>";
              echo "<td>" . $row['ReturnCount'] . "</td>";
              echo "<td>" . $row['FileName'] . "</td>";
              echo "<td>" . $row['EfileNumber'] . "</td>";
              echo "<td>" . $row['TaxationYear'] . "</td>";
              echo "<td>" . $row['AdditionalInfo'] . "</td>";
              echo "</tr>";
            }
            echo "</table>";
            
            // Close file db connection
            $file_db = null;
            
        } catch(Exception $e) {
            echo $e->getMessage();
        }	
    }
    else if ($_POST["action"] == "Init Database") {
        try {
            
            $filename = "Recent.db";
            $new_filename = "archive/Recent_". date("Y-m-d_H-i-s") .".db";
            if (file_exists($filename)) {                
                if (rename($filename, $new_filename)) {
                    echo 'File was renamed sucessfully<br>';
                }
                else {
                    echo 'File was not renamed to '. $new_filename .'<br>';    
                }
            }
            else {
                echo 'File was not found!<br>';    
            }                
    
            if (!file_exists($filename)) {
                include 'init_database.php';
            
                echo 'New database was created sucessfully<br>';
            }
            
            // Close file db connection
            $file_db = null;
            
        } catch(Exception $e) {
            echo $e->getMessage();
        }    
    }
}
?>
 
</body>
</html>