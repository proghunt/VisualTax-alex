<?php

// Connect to database
$file_db = new PDO('sqlite:Recent.db');
$file_db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// Create table messages
$file_db->exec("CREATE TABLE IF NOT EXISTS SaveLog (
                    Id                  INTEGER       PRIMARY KEY AUTOINCREMENT
                                                      UNIQUE
                                                      NOT NULL,
                    AppName             VARCHAR (10),
                    AppKey              VARCHAR (19),
                    LicenseLevel        VARCHAR (255),
                    ReturnCountLimited  BOOLEAN,
                    MaxReturnCount      VARCHAR (255),
                    EventDate           DATETIME,
                    ComputerName        VARCHAR (255),
                    PreparerName        VARCHAR (255),
                    PreparerAddress     VARCHAR (255),
                    ReturnCount         INTEGER,
                    FileName            VARCHAR (255),
                    EfileNumber         VARCHAR (20),
                    TaxationYear        VARCHAR (20),
                    AdditionalInfo      VARCHAR (500) 
                );");

?>