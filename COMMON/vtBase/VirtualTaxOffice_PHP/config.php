<?php

define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_NAME', 'VirtualTaxOffice');
define('GOOGLE_KEY', 'AIzaSyB4eiefnGoN5V12eS65KP-qJRiXLUGFH9U');
define('ROWS_PER_PAGE', '15');
//define('VERSION', '1.0.2');
define('VERSION', date('h-i-s, j-m-y'));
define('OFFICE_PREFIX', 'VO');
define('PAYER_PREFIX', 'VC');
if ($_SERVER['HTTP_HOST'] == 'localhost' || $_SERVER['HTTP_HOST'] == '192.168.1.147') {
    define('TEST_EMAIL', 'vitalik.ventik@gmail.com');
    define('TEST_MODE', true);
} 
else {
    define('TEST_EMAIL', 'support@visualtax.com');
    //define('TEST_MODE', false);
    define('TEST_MODE', true);
}

ini_set("display_errors", 1);
error_reporting(E_ALL);

$conn = new PDO("mysql:host=".DB_SERVER.";dbname=".DB_NAME, DB_USERNAME, DB_PASSWORD);
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$taxoffices_db = $conn;
$taxpayers_db = $conn;

function get_base_url() {
    return 'http://'.$_SERVER['HTTP_HOST'].dirname($_SERVER['PHP_SELF']) . '/';
} 

function init_setting($name, $default_value) {
    define($name, (session_id() != '' && isset($_SESSION[$name]) ? $_SESSION[$name] : $default_value));
}
  
// colors
function init_default_color_settings() {
    init_setting('TITLE_SMALL_COLOR', '#424242');
    init_setting('TITLE_COLOR', '#BEBEBE');
    init_setting('BACKGROUND_COLOR', '#EEEEEE');
    init_setting('LEFT_PANEL_COLOR', '#D3D3D3');
    init_setting('RIGHT_PANEL_COLOR', '#D3D3D3');
    init_setting('PROJECTOR_COLOR', '#FFFFFF');
    init_setting('FLOOR_COLOR', '#A9A9A9');
    init_setting('GROUT_COLOR', '#808080');
    init_setting('LOGO_FILENAME', get_base_url() . 'img/logo.png');
    init_setting('BACKGROUND_FILENAME', get_base_url() . 'img/default_background.jpg');
    init_setting('BACKGROUND_REPEAT', 'no-repeat');
    init_setting('BACKGROUND_SIZE', '100% 100%');
    init_setting('BORDER_COLOR', '#808080');
    init_setting('BORDER_WIDTH', '1');
    init_setting('BORDER', BORDER_WIDTH . 'px solid ' . BORDER_COLOR);
    init_setting('COMPANY_NAME', 'Visual Tax');
    init_setting('LOGO_MESSAGE', 'Meet and interact with your clients in your own suite of the Virtual Tax Office tower!');
    init_setting('COMPANY_NAME_COLOR', '#FF0000');
    init_setting('COMPANY_NAME_SIZE', '14');
    init_setting('LOGO_MESSAGE_COLOR', '#000000');    
    init_setting('LOGO_MESSAGE_SIZE', '14');
    init_setting('NAME_COLOR', '#000000');
    init_setting('NAME_SIZE', '14');
    init_setting('OTHER_TEXT_COLOR', '#000000');
    init_setting('OTHER_TEXT_SIZE', '14');
}

function is_office($value) {
    return substr($value, 0, 2) == OFFICE_PREFIX;
}

function is_payer($value) {
    return substr($value, 0, 2) == PAYER_PREFIX;
}

function init_color_settings() {
    // Initialize the session
    if (session_id() == ''){
        session_start();
    }
     
    $id = 0;
    global $taxoffices_db;
    
    if (isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] == true) {
        $cyberid = $_SESSION["cyberid"];
        if (is_office($cyberid)) {
            $query = "SELECT Id
                      FROM ColorSettings                            
                      WHERE UPPER(TaxOfficeCyberId) = UPPER(:CyberId)";
            $stmt = $taxoffices_db->prepare($query);
            $stmt->bindParam(':CyberId', $cyberid);
            $stmt->execute();
            $result = $stmt->fetch(); 
            if ($result) {
                $id = $result["Id"];
            }
        }
        elseif (is_payer($cyberid)) {
            $query = "SELECT Id
                      FROM ColorSettings                            
                      WHERE TaxOfficeCyberId IN (SELECT TaxPayers.TaxOfficeCyberId FROM TaxPayers WHERE UPPER(TaxPayers.CyberId) = UPPER(:CyberId))";
            $stmt = $taxoffices_db->prepare($query);
            $stmt->bindParam(':CyberId', $cyberid);
            $stmt->execute();
            $result = $stmt->fetch(); 
            if ($result) {
                $id = $result["Id"];
            }
        }        
    }
    if ($id == 0) {
        $query = "SELECT Id
                  FROM ColorSettings                            
                  WHERE UPPER(Caption) = UPPER('Default')";
        $stmt = $taxoffices_db->prepare($query);
        $stmt->execute();
        $result = $stmt->fetch(); 
        if ($result) {
            $id = $result["Id"];
        }
    }
    if ($id != 0) {
        $query = "SELECT *
                  FROM ColorSettings                            
                  WHERE Id = :Id";
        $stmt = $taxoffices_db->prepare($query);
        $stmt->bindParam(':Id', $id);
        $stmt->execute();
        $result = $stmt->fetch(); 
        if ($result) {
            init_setting('TITLE_SMALL_COLOR', $result["TitleSmallColor"]);
            init_setting('TITLE_COLOR', $result["TitleColor"]);
            init_setting('BACKGROUND_COLOR', $result["BackgroundColor"]);
            init_setting('LEFT_PANEL_COLOR', $result["LeftPanelColor"]);
            init_setting('RIGHT_PANEL_COLOR', $result["RightPanelColor"]);
            init_setting('PROJECTOR_COLOR', $result["ProjectorColor"]);
            init_setting('FLOOR_COLOR', $result["FloorColor"]);
            init_setting('GROUT_COLOR', $result["GroutColor"]);
            init_setting('LOGO_FILENAME', $result["LogoFileName"]);
            init_setting('BACKGROUND_FILENAME', $result["BackgroundFileName"]);
            if (strtoupper($result["BackgroundRepeat"]) == 'Y') {
                init_setting('BACKGROUND_REPEAT', 'repeat');
                init_setting('BACKGROUND_SIZE', 'auto');
            } 
            else {
                init_setting('BACKGROUND_REPEAT', 'no-repeat');
                init_setting('BACKGROUND_SIZE', '100% 100%');
            }
            init_setting('BORDER_COLOR', $result["BorderColor"]);
            init_setting('BORDER_WIDTH', $result["BorderWidth"]);
            init_setting('BORDER', $result["BorderWidth"] . 'px solid ' . $result["BorderColor"]);
            init_setting('COMPANY_NAME', $result["CompanyName"]);
            init_setting('LOGO_MESSAGE', $result["LogoMessage"]);
            init_setting('COMPANY_NAME_COLOR', $result["CompanyNameColor"]);
            init_setting('COMPANY_NAME_SIZE', $result["CompanyNameSize"]);
            init_setting('LOGO_MESSAGE_COLOR', $result["LogoMessageColor"]);
            init_setting('LOGO_MESSAGE_SIZE', $result["LogoMessageSize"]);
            init_setting('NAME_COLOR', $result["NameColor"]);
            init_setting('NAME_SIZE', $result["NameSize"]);
            init_setting('OTHER_TEXT_COLOR', $result["OtherTextColor"]);
            init_setting('OTHER_TEXT_SIZE', $result["OtherTextSize"]);
        }
    }
    else {
        init_default_color_settings();
    }
}
?>