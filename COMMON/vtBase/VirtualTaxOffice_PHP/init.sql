CREATE TABLE IF NOT EXISTS TaxOffices ( 
    CyberId                           VARCHAR (255) NOT NULL PRIMARY KEY, 
    Activated                         CHAR (1) DEFAULT 'N',
    ActivationCode                    VARCHAR (255),  
    Password                          VARCHAR (255), 
    Status                            CHAR (1) DEFAULT 'A', 
    ExpireDate                        TIMESTAMP,
    BusinessName                      VARCHAR (255), 
    Email                             VARCHAR (255),
    WebSiteUrl                        VARCHAR (255),
    HaveCRAEfilerNumber               CHAR (1) DEFAULT 'N',
    CRAEfilerName                     VARCHAR (255),
    Rating                            INT,
    RatingNotes                       VARCHAR (255),
    AdminNotes                        VARCHAR (255),
    Contact                           VARCHAR (255),
    Area                              VARCHAR (3),
    Phone                             VARCHAR (255),
    Cell                              VARCHAR (255),
    Fax                               VARCHAR (255),
    Street                            VARCHAR (255),
    City                              VARCHAR (255),
    Province                          VARCHAR (4),
    Postal                            VARCHAR (7),
    YearsInBusiness                   INT,
    T1                                CHAR (1) DEFAULT 'N', 
    T2                                CHAR (1) DEFAULT 'N', 
    T3                                CHAR (1) DEFAULT 'N', 
    T4T5                              CHAR (1) DEFAULT 'N', 
    NR4                               CHAR (1) DEFAULT 'N', 
    T3010                             CHAR (1) DEFAULT 'N', 
    T5013                             CHAR (1) DEFAULT 'N', 
    T5018                             CHAR (1) DEFAULT 'N', 
    vtNOA                             CHAR (1) DEFAULT 'N', 
    Other                             CHAR (1) DEFAULT 'N', 
    OtherServiceDescription           VARCHAR (255), 
    Experience                        VARCHAR (255),
    VirtualTaxpayerDiscountPercent    NUMERIC (10, 2),
    VirtualTaxpayerDiscountAmount     NUMERIC (10, 2),
    MinT1Fee                          NUMERIC (10, 2),
    MinT2Fee                          NUMERIC (10, 2),
    BasedOnCheckListSupplied          CHAR (1) DEFAULT 'N', 
    PriceListURL                      VARCHAR (255),
    TeamviewerID                      VARCHAR (255),
    VirtualMeetingAlarm               VARCHAR (255),
    ZoomVideoID                       CHAR (1) DEFAULT 'N',
    UltraViewerID                     VARCHAR (255),
    TaxSoftwareNames                  VARCHAR (255),
    MembershipFeePaid                 NUMERIC (10, 2),
    DateFeePaid                       DATETIME,
    Latitude                          VARCHAR (255),
    Longitude                         VARCHAR (255)
);

CREATE TABLE IF NOT EXISTS TaxPayers ( 
    CyberId                       VARCHAR (255) NOT NULL PRIMARY KEY, 
    Activated                     CHAR (1) DEFAULT 'N',
    ActivationCode                VARCHAR (255),    
    Password                      VARCHAR (255),
    Status                        CHAR (1) DEFAULT 'A',                           
    FirstName                     VARCHAR (255), 
    LastName                      VARCHAR (255), 
    Email                         VARCHAR (255), 
    TaxOfficeCyberId              VARCHAR (255),    
    Area                          VARCHAR (3),
    Phone                         VARCHAR (255),
    Cell                          VARCHAR (255),
    Fax                           VARCHAR (255),
    Street                        VARCHAR (255),
    City                          VARCHAR (255),
    Province                      VARCHAR (4),
    Postal                        VARCHAR (7),
    Country                       VARCHAR (255),
    AdminNotes                    VARCHAR (255),
    Computer                      CHAR (1) DEFAULT 'O',
    TeamviewerID                  VARCHAR (255),
    VirtualMeetingAlarm           VARCHAR (255),
    ZoomVideoID                   CHAR (1) DEFAULT 'N',
    UltraViewerID                 VARCHAR (255),
    TaxSoftwareNames              VARCHAR (255),
    MembershipFeePaid             NUMERIC (10, 2),
    NumberOfTimesReceived         INT,
    NumberOfTimesSent             INT,
    SignatureFile                 VARCHAR (255),
    AppointmentDate               DATETIME,
    PurposeOfMeeting              VARCHAR (255),
    PhotoFile                     VARCHAR (255),
    ShowSignatureToOffice         CHAR (1) DEFAULT 'N'
);

CREATE TABLE IF NOT EXISTS Efilers ( 
    CyberId                           VARCHAR (255) NOT NULL PRIMARY KEY,     
    BusinessName                      VARCHAR (255), 
    Phone                             VARCHAR (255),    
    Street                            VARCHAR (255),
    City                              VARCHAR (255),
    Province                          VARCHAR (4),
    Postal                            VARCHAR (7),
    Latitude                          VARCHAR (255),
    Longitude                         VARCHAR (255)    
);

CREATE TABLE IF NOT EXISTS EncrPsw ( 
    Id                                INT PRIMARY KEY AUTO_INCREMENT,
    TaxOfficeCyberId                  VARCHAR (255),
    TaxPayerCyberId                   VARCHAR (255),	
    EncryptPsw                        VARCHAR (255),  
    DateCreated                       DATETIME NOT NULL DEFAULT NOW(),
    CreatedBy                         VARCHAR (2),
    FilesWaitingDecryption            INTEGER NOT NULL DEFAULT 0,
    INDEX (TaxOfficeCyberId, TaxPayerCyberId, CreatedBy DESC, FilesWaitingDecryption)    
);

CREATE TABLE IF NOT EXISTS TaxForms ( 
    Id                                INT PRIMARY KEY,
    TaxFormName                       VARCHAR (255)
);

CREATE TABLE IF NOT EXISTS TaxSections ( 
    Id                                INT PRIMARY KEY,
    TaxFormId                         INT,
    TaxSectionName                    VARCHAR (255),
    FOREIGN KEY (TaxFormId) REFERENCES TaxForms(Id)
);

CREATE TABLE IF NOT EXISTS TaxItems ( 
    Id                                INT PRIMARY KEY,
    TaxSectionId                      INT,
    TaxItemName                       VARCHAR (255),
    TaxItemType                       CHAR (1),
    HasCount                          CHAR (1),
    Mapping                           VARCHAR (255),
    FOREIGN KEY (TaxSectionId) REFERENCES TaxSections(Id)
);

CREATE TABLE IF NOT EXISTS TaxFormHeaders ( 
    Id                                INT PRIMARY KEY AUTO_INCREMENT,
    TaxFormId                         INT,
    TaxPayerCyberId                   VARCHAR (255),
    DatePosted                        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status                            CHAR (1) NOT NULL DEFAULT 'D',  -- D - draft, P - available for proposals, A - accepted, C - completed
    FOREIGN KEY (TaxFormId) REFERENCES TaxForms(Id),
    FOREIGN KEY (TaxPayerCyberId) REFERENCES TaxPayers(CyberId),
    CONSTRAINT UC_TaxFormIdTaxPayerCyberId UNIQUE (TaxFormId,TaxPayerCyberId)
);

CREATE TABLE IF NOT EXISTS TaxFormValues ( 
    Id                                INT PRIMARY KEY AUTO_INCREMENT,
    TaxFormItemId                     INT,
    TaxPayerCyberId                   VARCHAR (255),
    TaxItemValue                      VARCHAR (255),
    CountValue                        VARCHAR (255),
    Note                              VARCHAR (255),
    FOREIGN KEY (TaxFormItemId) REFERENCES TaxItems(Id),
    FOREIGN KEY (TaxPayerCyberId) REFERENCES TaxPayers(CyberId),
    CONSTRAINT UC_TaxFormItemIdTaxPayerCyberId UNIQUE (TaxFormItemId,TaxPayerCyberId)
);

CREATE TABLE IF NOT EXISTS TaxFormProposals ( 
    Id                                INT PRIMARY KEY AUTO_INCREMENT,
    TaxFormHeaderId                   INT,
    TaxOfficeCyberId                  VARCHAR (255),
    DateCreated                       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Accepted                          CHAR (1) NOT NULL DEFAULT 'N',
    OfficeStatus                      CHAR (1) NOT NULL DEFAULT 'N',  -- N - new, V - viewed, S - submitted, C - completed
    PayerStatus                       CHAR (1) NOT NULL DEFAULT 'N',  -- N - new, V - viewed, A - accepted
    ExpectedTotalCost                 NUMERIC (10, 2),
    ExpectedCompletionDate            TIMESTAMP,
    OfficeNote                        VARCHAR (255),
    
    FOREIGN KEY (TaxFormHeaderId) REFERENCES TaxFormHeaders(Id),
    FOREIGN KEY (TaxOfficeCyberId) REFERENCES TaxOffices(CyberId),
    CONSTRAINT UC_TaxFormHeaderIdTaxOfficeCyberId UNIQUE (TaxFormHeaderId,TaxOfficeCyberId)
);

CREATE TABLE IF NOT EXISTS ColorSettings ( 
    Id                                INT PRIMARY KEY AUTO_INCREMENT,
    Caption                           VARCHAR (255),
    TaxOfficeCyberId                  VARCHAR (255),
    TitleSmallColor                   VARCHAR (20),
    TitleColor                        VARCHAR (20),
    BackgroundColor                   VARCHAR (20),
    LeftPanelColor                    VARCHAR (20),
    RightPanelColor                   VARCHAR (20),
    ProjectorColor                    VARCHAR (20),
    FloorColor                        VARCHAR (20),
    GroutColor                        VARCHAR (20),
    LogoFileName                      VARCHAR (255),
    LogoMessage                       VARCHAR (255),
    CompanyName                       VARCHAR (255),
    LogoMessageColor                  VARCHAR (20),
    LogoMessageSize                   INT,
    CompanyNameColor                  VARCHAR (20),    
    CompanyNameSize                   INT,
    NameColor                         VARCHAR (20),    
    NameSize                          INT,
    OtherTextColor                    VARCHAR (20),    
    OtherTextSize                     INT,
    
    BackgroundFileName                VARCHAR (255),
    BackgroundRepeat                  CHAR (1), 
    BorderColor                       VARCHAR (20),
    BorderWidth                       INT,    

    FOREIGN KEY (TaxOfficeCyberId) REFERENCES TaxOffices(CyberId)
);

/*
ALTER TABLE TaxFormProposals ADD OfficeStatus CHAR (1) NOT NULL DEFAULT 'N';

ALTER TABLE TaxFormProposals ADD PayerStatus CHAR (1) NOT NULL DEFAULT 'N';

ALTER TABLE TaxFormProposals ADD OfficeNote VARCHAR (255);

ALTER TABLE TaxOffices ADD Activated CHAR (1) DEFAULT 'N';

ALTER TABLE TaxOffices ADD ActivationCode VARCHAR (255);

ALTER TABLE TaxOffices ADD ExpireDate TIMESTAMP;

UPDATE TaxOffices SET ExpireDate = "2021-01-31";

ALTER TABLE TaxOffices MODIFY COLUMN UltraViewerID VARCHAR (255);

UPDATE TaxOffices
SET UltraViewerID = ""
WHERE UltraViewerID IN ("Y", "N");

ALTER TABLE TaxPayers MODIFY COLUMN UltraViewerID VARCHAR (255);

UPDATE TaxPayers
SET UltraViewerID = ""
WHERE UltraViewerID IN ("Y", "N");

ALTER TABLE ColorSettings MODIFY COLUMN     TitleSmallColor                   VARCHAR (20);
ALTER TABLE ColorSettings MODIFY COLUMN     TitleColor                        VARCHAR (20);
ALTER TABLE ColorSettings MODIFY COLUMN     BackgroundColor                   VARCHAR (20);
ALTER TABLE ColorSettings MODIFY COLUMN     LeftPanelColor                    VARCHAR (20);
ALTER TABLE ColorSettings MODIFY COLUMN     RightPanelColor                   VARCHAR (20);
ALTER TABLE ColorSettings MODIFY COLUMN     ProjectorColor                    VARCHAR (20);
ALTER TABLE ColorSettings MODIFY COLUMN     FloorColor                        VARCHAR (20);
ALTER TABLE ColorSettings MODIFY COLUMN     GroutColor                        VARCHAR (20);
ALTER TABLE ColorSettings MODIFY COLUMN     LogoMessageColor                  VARCHAR (20);
ALTER TABLE ColorSettings MODIFY COLUMN     CompanyNameColor                  VARCHAR (20);
ALTER TABLE ColorSettings MODIFY COLUMN     BorderColor                       VARCHAR (20);

ALTER TABLE TaxItems ADD HasCount CHAR (1);
ALTER TABLE TaxItems ADD Mapping VARCHAR (255);

ALTER TABLE TaxFormValues ADD CountValue VARCHAR (255);
ALTER TABLE TaxFormValues ADD Note VARCHAR (255);

ALTER TABLE TaxPayers ADD SignatureFile VARCHAR (255);
ALTER TABLE TaxPayers ADD AppointmentDate DATETIME;
ALTER TABLE TaxPayers ADD PurposeOfMeeting VARCHAR (255);


*/

CREATE OR REPLACE VIEW V_TOCyberIDs AS
SELECT CyberId, BusinessName, CONCAT(Area, ' ', Phone) AS Phone FROM TaxOffices
UNION
SELECT CyberId, BusinessName, Phone FROM Efilers;

INSERT IGNORE INTO TaxForms(Id, TaxFormName)
VALUES  (1, 'Tax Document Checklist');
                     
INSERT IGNORE INTO TaxSections(Id, TaxFormId, TaxSectionName)
VALUES  (1, 1, 'Slips'), 
        (2, 1, 'Receipts'), 
        (3, 1, 'Other Documents');                     
        
INSERT IGNORE INTO TaxItems(Id, TaxSectionId, TaxItemName, TaxItemType)
VALUES  (1, 1, 'T3 (Mutual Funds)', 'B'),
        (2, 1, 'T4 (Employment Income)', 'B'),
        (3, 1, 'T4A (Statement of Pension, retirement, annuity and other income)', 'B'),
        (4, 1, 'T4E (EI Benefits)', 'B'),
        (5, 1, 'T4A-OAS (Old Age Security benefits)', 'B'),
        (6, 1, 'T4AP (CPP benefits)', 'B'),
        (7, 1, 'T4PS (Employee Profit-Sharing)', 'B'),
        (8, 1, 'T4 RSP (RRSP)', 'B'),
        (9, 1, 'T4 RIF (RRIF Income)', 'B'),
        (10, 1, 'T5 (Investment income, interest, dividends, certain capital gains, etc.)', 'B'),
        (11, 1, 'T5007 (Worker''s compensation/social assistance payment)', 'B'),
        (12, 1, 'T5008 (Stock Transaction)', 'B'),
        (13, 1, 'T5013 (Partnership Income)', 'B'),
        (14, 1, 'T2200 (Conditions of employment/allowable employment expenses)', 'B'),
        (15, 1, 'T2202A (Tuition)', 'B'),
        (16, 2, 'RRSP contribution slips', 'B'),
        (17, 2, 'Professional or union dues', 'B'),
        (18, 2, 'Medical expense', 'B'),
        (19, 2, 'Public Transit Pass for seniors', 'B'),
        (20, 2, 'Charitable/Political Donation Receipts', 'B'),
        (21, 2, 'Interest paid on your student loans', 'B'),
        (22, 2, 'Child care expense', 'B'),
        (23, 2, 'Moving expenses', 'B'),
        (24, 2, 'Receipts for your rent/property tax', 'B'),
        (25, 3, 'Personal Info (SIN#, D.O.B, Current address, phone#, etc.)', 'B'),
        (26, 3, 'Dependants Info (SIN#)', 'B'),
        (27, 3, 'Canada Permanent Residence Card (if new immigrant)', 'B'),
        (28, 3, 'Any life changes? (Marriage, new child, etc.)', 'B'),
        (29, 3, 'Last year''s notice of assessment/reassessment', 'B'),
        (30, 3, 'Latest Bank Information (for direct deposit)', 'B'),
        (31, 3, 'Branch No. (5 digits), Institution No. (3 digits), Account No. (up to 12 digits)', 'S'),
        (32, 3, 'Capital gains/losses for stocks, bonds, real-estate, etc.', 'B'),
        (33, 3, 'Installment Tax Payments', 'B'),
        (34, 3, 'Rental Income & expense', 'B'),
        (35, 3, 'Self-Employment Income & Expense', 'B'),
        (36, 3, 'Other documents as needed', 'B');

DROP PROCEDURE IF EXISTS Change_Office_CyberId;

DELIMITER //
CREATE PROCEDURE Change_Office_CyberId (IN inCyberId VARCHAR(255), IN inNewCyberId VARCHAR(255))
BEGIN
    SET foreign_key_checks = 0;

    UPDATE TaxOffices SET CyberId = inNewCyberId WHERE CyberId = inCyberId;
    UPDATE TaxPayers SET TaxOfficeCyberId = inNewCyberId WHERE TaxOfficeCyberId = inCyberId;
    UPDATE EncrPsw SET TaxOfficeCyberId = inNewCyberId WHERE TaxOfficeCyberId = inCyberId;
    UPDATE TaxFormProposals SET TaxOfficeCyberId = inNewCyberId WHERE TaxOfficeCyberId = inCyberId;

    SET foreign_key_checks = 1;
END//

DELIMITER ;
       
/*
DROP TRIGGER IF EXISTS TaxOffices_Update;

CREATE TRIGGER TaxOffices_Update BEFORE UPDATE ON TaxOffices FOR EACH ROW 
BEGIN 
    IF (IFNULL(OLD.Street, "") <> IFNULL(NEW.Street, "") OR 
        IFNULL(OLD.City, "") <> IFNULL(NEW.City, "") OR 
        IFNULL(OLD.Province, "") <> IFNULL(NEW.Province, "") OR 
        IFNULL(OLD.Postal, "") <> IFNULL(NEW.Postal, "")) THEN 
       
       SET NEW.Latitude = ""; 
       SET NEW.Longitude = ""; 
    END IF; 
END;

DROP TRIGGER IF EXISTS Efilers_Update;

CREATE TRIGGER Efilers_Update BEFORE UPDATE ON Efilers FOR EACH ROW 
BEGIN 
    IF (IFNULL(OLD.Street, "") <> IFNULL(NEW.Street, "") OR 
        IFNULL(OLD.City, "") <> IFNULL(NEW.City, "") OR 
        IFNULL(OLD.Province, "") <> IFNULL(NEW.Province, "") OR 
        IFNULL(OLD.Postal, "") <> IFNULL(NEW.Postal, "")) THEN 
       
       SET NEW.Latitude = ""; 
       SET NEW.Longitude = ""; 
    END IF; 
END;
*/