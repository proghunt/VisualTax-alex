<?php

// Connect to database
$file_db = new PDO('sqlite:CloudLogs.db');
$file_db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// Create table logs
$file_db->exec("CREATE TABLE IF NOT EXISTS Logs (
                    Id                  INTEGER PRIMARY KEY AUTOINCREMENT,
                    CloudKey            VARCHAR (25),
                    PreparerName        VARCHAR (255), 
                    Email               VARCHAR (255),
                    Phone               VARCHAR (255),
                    
                    StartTime           DATETIME,
                    EndTime             DATETIME
                );");	

?>