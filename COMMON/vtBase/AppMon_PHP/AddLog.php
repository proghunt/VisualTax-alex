<?php

try {    
    
    include 'init_database.php';
    
    // Prepare INSERT statement to SQLite3 file db
    $insert = 
        "INSERT INTO SaveLog 
            (AppName, AppKey, LicenseLevel, ReturnCountLimited, MaxReturnCount, EventDate, ComputerName, PreparerName, PreparerAddress, ReturnCount, FileName, EfileNumber, TaxationYear, AdditionalInfo) 
         SELECT 
            :AppName, :AppKey, :LicenseLevel, :ReturnCountLimited, :MaxReturnCount, :EventDate, :ComputerName, :PreparerName, :PreparerAddress, :ReturnCount, :FileName, :EfileNumber, :TaxationYear, :AdditionalInfo
         WHERE NOT EXISTS(SELECT * FROM SaveLog WHERE AppKey = :AppKey2 AND ComputerName = :ComputerName2 AND FileName = :FileName2 AND EfileNumber = :EfileNumber2)
        ";
    $stmt = $file_db->prepare($insert);

    // Bind parameters to statement variables
    $stmt->bindParam(':AppName', htmlspecialchars($_POST["AppName"]));
    $stmt->bindParam(':AppKey', htmlspecialchars($_POST["AppKey"]));
    $stmt->bindParam(':LicenseLevel', htmlspecialchars($_POST["LicenseLevel"]));
    $stmt->bindParam(':ReturnCountLimited', htmlspecialchars($_POST["ReturnCountLimited"]));
    $stmt->bindParam(':MaxReturnCount', htmlspecialchars($_POST["MaxReturnCount"]));
    $stmt->bindParam(':EventDate', htmlspecialchars($_POST["EventDate"]));
    $stmt->bindParam(':ComputerName', htmlspecialchars($_POST["ComputerName"]));
    $stmt->bindParam(':PreparerName', htmlspecialchars($_POST["PreparerName"]));
    $stmt->bindParam(':PreparerAddress', htmlspecialchars($_POST["PreparerAddress"]));
    $stmt->bindParam(':ReturnCount', htmlspecialchars($_POST["ReturnCount"]));
    $stmt->bindParam(':FileName', htmlspecialchars($_POST["FileName"]));
    $stmt->bindParam(':EfileNumber', htmlspecialchars($_POST["EfileNumber"]));
    $stmt->bindParam(':TaxationYear', htmlspecialchars($_POST["TaxationYear"]));    
    $stmt->bindParam(':AdditionalInfo', htmlspecialchars($_POST["AdditionalInfo"]));
    $stmt->bindParam(':AppKey2', htmlspecialchars($_POST["AppKey"]));
    $stmt->bindParam(':ComputerName2', htmlspecialchars($_POST["ComputerName"]));
    $stmt->bindParam(':FileName2', htmlspecialchars($_POST["FileName"]));
    $stmt->bindParam(':EfileNumber2', htmlspecialchars($_POST["EfileNumber"]));

    $stmt->execute();
    
    // Close file db connection
    $file_db = null;
    
    echo 'OK';
    
} catch(PDOException $e) {
    echo $e->getMessage();
}

?>