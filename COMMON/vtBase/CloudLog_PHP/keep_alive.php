<?php

//phpinfo();

try { 

    include 'init_database.php';

    // Prepare update statement 
    $insert = 
        'UPDATE Logs 
            SET EndTime = datetime("now")
         WHERE Id = :CloudId';
    $stmt = $file_db->prepare($insert);

    // Bind parameters to statement variables
    $stmt->bindParam(':CloudId', $_POST['CLOUDID']);

    $stmt->execute();
    
    /*$filename = 'received.txt';
    ob_start();
    var_dump($_POST);
    $text = ob_get_clean();

    file_put_contents($filename, $text);*/
    
    echo "OK";

} catch(PDOException $e) {
	echo "Error occured: " . $e->getMessage();
}
?>