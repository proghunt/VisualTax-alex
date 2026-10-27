<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Cloud Keys Viewer</title>
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
<p><h1>Cloud Keys Viewer</h1></p>
<?php
    if ($_POST["password"] == "Igor") {
        echo "<input type=\"hidden\" name=\"password\" value=\"Igor\">";    

        try {    
            
            include 'init_database.php';        
           
            // Generate query 
            $query = "SELECT * FROM Keys ORDER BY AppYear, Name";
            
            // Select all data from file db messages table 
            $result = $file_db->query($query);
            
            echo "<table border='1' width='100%'><tr>";
            echo "<th>AppYear</th>";
            echo "<th>Name</th>";
            echo "<th>Cloud Key</th>";
            echo "<th>Cloud Dir</th>";
            echo "<th>Cloud Data Dir</th>";
            echo "<th>T1</th>";
            echo "<th>T2</th>";
            echo "<th>T3</th>";
            echo "<th>T4T5</th>";
            echo "<th>TF</th>";
            echo "<th>FP</th>";
            // echo "<th>DropBox</th>";
            echo "<th>vtLoan</th>";
            echo "<th>Allowed Apps</th>";
            echo "</tr>";		
            
            foreach($result as $row) {
              echo "<tr>";
              echo "<td>" . $row['AppYear'] . "</td>";
              echo "<td>" . $row['Name'] . "</td>";
              echo "<td>" . $row['CloudKey'] . "</td>";
              echo "<td>" . $row['CloudDir'] . "</td>";
              echo "<td>" . $row['CloudDataDir'] . "</td>";
              echo "<td>" . $row['T1Key'] . "</td>";
              echo "<td>" . $row['T2Key'] . "</td>";
              echo "<td>" . $row['T3Key'] . "</td>";
              echo "<td>" . $row['T4Key'] . "</td>";
              echo "<td>" . $row['TFKey'] . "</td>";
              echo "<td>" . $row['FPKey'] . "</td>";
              // echo "<td>" . $row['DropBoxKey'] . "</td>";
              echo "<td>" . $row['vtLoanKey'] . "</td>";
              echo "<td>" . $row['AllowedApps'] . "</td>";
              echo "</tr>";
            }
            echo "</table>";
            
            // Close file db connection
            $file_db = null;
            
        } catch(Exception $e) {
            echo $e->getMessage();
        }
    }
    else {
        echo "<form action=\"http://www.visualtax.com/Cloud/show_keys.php\" method=\"post\">";
        echo "Password:&nbsp;<input type=\"password\" value=\"\" name=\"password\">";
        echo "&nbsp;<input name= \"action\" type=\"submit\" value=\"Logon\">";
        echo "</form>";
    }
?>
 
</body>
</html>