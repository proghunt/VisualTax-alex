<?php

// Connect to database
$file_db = new PDO('sqlite:Keys.db');
$file_db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// Create table keys
$file_db->exec("CREATE TABLE IF NOT EXISTS Keys (
                    AppYear             VARCHAR (4),
                    Name                VARCHAR (50), 
                    CloudDir            VARCHAR (50),
                    CloudDataDir        VARCHAR (255),
                    
                    T1Key               VARCHAR (25),
                    T2Key               VARCHAR (25),
                    T3Key               VARCHAR (25),
                    T4Key               VARCHAR (25),
                    TFKey               VARCHAR (25),
                    FPKey               VARCHAR (25), 
                    TRKey               VARCHAR (25),
                    S1Key               VARCHAR (25),
                    S2Key               VARCHAR (25),
                    CloudKey            VARCHAR (25),
                    
                    DropBoxKey          VARCHAR (25),
                    AllowedApps         VARCHAR (255),
                    
                    vtLoanKey           VARCHAR (25),
					
                    PRIMARY KEY (AppYear, Name) ON CONFLICT REPLACE
                );");	

// Create table BNLimited
$file_db->exec("CREATE TABLE IF NOT EXISTS BNLimited ( 
                   T2Key               VARCHAR (25),  
                   Content             VARCHAR (1000), 

                   PRIMARY KEY (T2Key) ON CONFLICT REPLACE 
      
                );");                
?>