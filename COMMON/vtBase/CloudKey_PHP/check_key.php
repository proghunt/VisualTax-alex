<?php

try { 

    include 'init_database.php';
    
    $key = $_POST['key'];
    $year = $_POST['year'];
    
    // Generate query 
    $query = 
     "SELECT K.*, B.Content FROM Keys K
        LEFT JOIN BNLimited B ON B.T2KEY = K.T2KEY
      WHERE CloudKey = :Key AND AppYear = :Year";

    $stmt = $file_db->prepare($query);

    // Bind parameters to statement variables
    $stmt->bindParam(':Key', $key);
    $stmt->bindParam(':Year', $year);
    
    // search keys
    $stmt->execute();
    $result = $stmt->fetch();    
    
    header('Content-type: application/xml');
    
    if ($result) { 
        echo 
        '<?xml version="1.0" encoding="UTF-8"?>' .
        '<RESULTS>' .
        '    <RESULT>OK</RESULT>' .
        '    <NAME>'. htmlspecialchars($result['Name']) . '</NAME>' .
        '    <CLOUDDIR>'. $result['CloudDir'] . '</CLOUDDIR>' .
        '    <CLOUDDATADIR>'. $result['CloudDataDir'] . '</CLOUDDATADIR>' .
		'    <T1>'. $result['T1Key'] . '</T1>' .
        '    <T2>'. $result['T2Key'] . '</T2>' .
        '    <T3>'. $result['T3Key'] . '</T3>' .
        '    <T4>'. $result['T4Key'] . '</T4>' .
        '    <TF>'. $result['TFKey'] . '</TF>' .
        '    <FP>'. $result['FPKey'] . '</FP>' .
        '    <TR>'. $result['TRKey'] . '</TR>' .
        '    <S1>'. $result['S1Key'] . '</S1>' .
        '    <S2>'. $result['S2Key'] . '</S2>' .
        '    <DROPBOX>'. $result['DropBoxKey'] . '</DROPBOX>' .        
        '    <VTLOAN>'. $result['vtLoanKey'] . '</VTLOAN>' .           
        '    <BNLimited>'. htmlspecialchars($result['Content']) . '</BNLimited>' .  
        '</RESULTS>';
    }
    else {
        echo 
        '<?xml version="1.0" encoding="UTF-8"?>' .
        '<RESULTS>' .
        '    <RESULT>Not found</RESULT>' .
        '</RESULTS>';
    }    
} catch(PDOException $e) {
    echo "Error occured: " . $e->getMessage();
}
?>    