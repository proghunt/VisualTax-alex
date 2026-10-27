<?php

//phpinfo();

try { 

    include 'init_database.php';
    
    $xml = simplexml_load_string($_POST['keys']);
    $year = $xml->attributes()->YEAR;

    // clear selected year records
    if ($xml->attributes()->CLEAR == 'TRUE') {
		$delete = "DELETE FROM Keys WHERE AppYear = :Year";	
		$stmt = $file_db->prepare($delete);
		$stmt->bindParam(':Year', $year);
		$stmt->execute();
		
		$vacuum = "VACUUM";
		$stmt = $file_db->prepare($vacuum);
		$stmt->execute();
		
		/*$reset_identity = "UPDATE SQLITE_SEQUENCE SET SEQ = IFNULL((SELECT MAX(Id) FROM Keys), 0) WHERE NAME = 'Keys'";
		$stmt = $file_db->prepare($reset_identity);
		$stmt->execute();*/
	}
    
    foreach ($xml->CLIENT as $client) {
        // Prepare INSERT statement 
        $insert = 
            "INSERT INTO Keys 
                (AppYear, Name, CloudDir, CloudDataDir, T1Key, T2Key, T3Key, T4Key, TFKey, FPKey, TRKey, S1Key, S2Key, CloudKey, DropBoxKey, vtLoanKey, AllowedApps) 
             SELECT 
                :AppYear, :Name, :CloudDir, :CloudDataDir, :T1Key, :T2Key, :T3Key, :T4Key, :TFKey, :FPKey, :TRKey, :S1Key, :S2Key, :CloudKey, :DropBoxKey, :vtLoanKey, :AllowedApps
             WHERE NOT EXISTS(SELECT * FROM Keys WHERE AppYear = :AppYear2 AND Name = :Name2)";
        $stmt = $file_db->prepare($insert);

        // Bind parameters to statement variables
        $stmt->bindParam(':AppYear', $year);
        $stmt->bindParam(':Name', $client->NAME);
        $stmt->bindParam(':CloudDir', $client->CLOUDDIR);
        $stmt->bindParam(':CloudDataDir', $client->CLOUDDATADIR);
		$stmt->bindParam(':T1Key', $client->T1KEY);
        $stmt->bindParam(':T2Key', $client->T2KEY);
        $stmt->bindParam(':T3Key', $client->T3KEY);
        $stmt->bindParam(':T4Key', $client->T4KEY);
        $stmt->bindParam(':TFKey', $client->TFKEY);
        $stmt->bindParam(':FPKey', $client->FPKEY);
        $stmt->bindParam(':TRKey', $client->TRKEY);
        $stmt->bindParam(':S1Key', $client->S1KEY);
        $stmt->bindParam(':S2Key', $client->S2KEY);
        $stmt->bindParam(':CloudKey', $client->CLOUDKEY);
        $stmt->bindParam(':DropBoxKey', $client->DROPBOXKEY);
        $stmt->bindParam(':vtLoanKey', $client->VTLOANKEY);
        $stmt->bindParam(':AllowedApps', $client->ALLOWEDAPPS);
        $stmt->bindParam(':AppYear2', $year);
        $stmt->bindParam(':Name2', $client->NAME);

        $stmt->execute();
        
        $insert = 
            "INSERT INTO BNLimited 
                (T2Key, Content) 
             SELECT 
                :T2Key, :Content
             WHERE NOT EXISTS(SELECT * FROM BNLimited WHERE T2Key = :T2Key2)";
        $stmt = $file_db->prepare($insert);

        // Bind parameters to statement variables
        $stmt->bindParam(':T2Key', $client->T2KEY);
        $stmt->bindParam(':T2Key2', $client->T2KEY);
        $stmt->bindParam(':Content', $client->BNLimited);

        $stmt->execute();
        
        $update = 
            "UPDATE Keys 
                SET CloudDir = :CloudDir, 
                    CloudDataDir = :CloudDataDir,
                    T1Key = :T1Key, 
                    T2Key = :T2Key, 
                    T3Key = :T3Key, 
                    T4Key = :T4Key, 
                    TFKey = :TFKey, 
                    FPKey = :FPKey, 
                    TRKey = :TRKey, 
                    S1Key = :S1Key, 
                    S2Key = :S2Key, 
                    CloudKey = :CloudKey,
                    DropBoxkey = :DropBoxKey,
                    vtLoanKey = :vtLoanKey,
                    AllowedApps = :AllowedApps
             WHERE AppYear = :AppYear AND Name = :Name";
        $stmt = $file_db->prepare($update);

        // Bind parameters to statement variables
        $stmt->bindParam(':AppYear', $year);
        $stmt->bindParam(':Name', $client->NAME);
        $stmt->bindParam(':CloudDir', $client->CLOUDDIR);
        $stmt->bindParam(':CloudDataDir', $client->CLOUDDATADIR);
		$stmt->bindParam(':T1Key', $client->T1KEY);
        $stmt->bindParam(':T2Key', $client->T2KEY);
        $stmt->bindParam(':T3Key', $client->T3KEY);
        $stmt->bindParam(':T4Key', $client->T4KEY);
        $stmt->bindParam(':TFKey', $client->TFKEY);
        $stmt->bindParam(':FPKey', $client->FPKEY);
        $stmt->bindParam(':TRKey', $client->TRKEY);
        $stmt->bindParam(':S1Key', $client->S1KEY);
        $stmt->bindParam(':S2Key', $client->S2KEY);
        $stmt->bindParam(':CloudKey', $client->CLOUDKEY);
        $stmt->bindParam(':DropBoxKey', $client->DROPBOXKEY);
        $stmt->bindParam(':vtLoanKey', $client->VTLOANKEY);
        $stmt->bindParam(':AllowedApps', $client->ALLOWEDAPPS);
        
        $stmt->execute();
        
        $update = 
            "UPDATE BNLimited 
                SET Content = :Content
             WHERE T2Key = :T2Key";
        $stmt = $file_db->prepare($update);

        // Bind parameters to statement variables
        $stmt->bindParam(':T2Key', $client->T2KEY);
        $stmt->bindParam(':Content', $client->BNLimited);

        $stmt->execute();
    }
    
    
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