<?php

//phpinfo();

try { 

    include 'init_database.php';

    // Prepare INSERT statement 
    $insert = 
        'INSERT INTO Logs 
            (CloudKey, PreparerName, Email, Phone, StartTime, EndTime) 
         SELECT 
            :CloudKey, :PreparerName, :Email, :Phone, datetime("now"), datetime("now")';
    $stmt = $file_db->prepare($insert);

    // Bind parameters to statement variables
    $stmt->bindParam(':CloudKey', $_POST['CLOUDKEY']);
    $stmt->bindParam(':PreparerName', $_POST['PREPARERNAME']);
    $stmt->bindParam(':Email', $_POST['EMAIL']);
    $stmt->bindParam(':Phone', $_POST['PHONE']);

    $stmt->execute();
    
    $get_id = 
        'select seq from sqlite_sequence where name="Logs"';
    $stmt = $file_db->prepare($get_id);
    $stmt->execute();
    $result = $stmt->fetch();        
    
    if ($result) { 
        header('Content-type: application/xml');
        
        echo 
        '<?xml version="1.0" encoding="UTF-8"?>' .
        '<RESULTS>' .
        '    <CLOUDID>' . $result['seq'] . '</CLOUDID>' .
        '</RESULTS>';
    }
    
    /*$filename = 'received.txt';
    ob_start();
    var_dump($_POST);
    $text = ob_get_clean();

    file_put_contents($filename, $text);
    
    echo "OK";*/

} catch(PDOException $e) {
	echo "Error occured: " . $e->getMessage();
}
?>