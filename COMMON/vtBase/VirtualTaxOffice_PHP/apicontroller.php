<?php 

// Include config file
require_once "config.php";

use PHPMailer\PHPMailer\PHPMailer;    
require 'thirdparty/PHPMailer/src/PHPMailer.php';
require 'thirdparty/PHPMailer/src/SMTP.php';

/*ini_set("display_errors", 1);
error_reporting(E_ALL);*/

$checkbox_readonly = " onclick='return false;' ";

/*$conn = new PDO("mysql:host=".DB_SERVER.";dbname=".DB_NAME, DB_USERNAME, DB_PASSWORD);
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$taxoffices_db = $conn;
$taxpayers_db = $conn;*/

set_error_handler(function($errno, $errstr, $errfile, $errline ){
    throw new ErrorException($errstr, $errno, 0, $errfile, $errline);
});

function logout() {
    if (session_id()) {        
        // Unset all of the session variables
        $_SESSION = array();
         
        // Destroy the session.
        session_destroy();
         
        // Redirect to login page
        header("location: index.php");
        exit;
    }
}

function is_empty($value) {
    return strval($value) == "";
}

function same_text($value1, $value2) {
    return strtoupper($value1) == strtoupper($value2);
}

function generate_random_string($length, $characters) {
    $characters_length = strlen($characters);
    $result = '';
    for ($i = 0; $i < $length; $i++) {
        $result .= $characters[rand(0, $characters_length - 1)];
    }
    return $result;
}

function generate_cyberid() {
    return generate_random_string(6, '0123456789');
}

function generate_password($len = 10) {
    return generate_random_string($len, '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
}

function restore_session() {
    if (session_id() == '') {
        if($_SERVER["REQUEST_METHOD"] == "POST") {
            if (isset($_POST["SessionId"])) {
                session_id($_POST["SessionId"]);
                session_start(); 
            } 
        }
        elseif($_SERVER["REQUEST_METHOD"] == "GET") {
            if (isset($_GET["SessionId"])) {
                session_id($_GET["SessionId"]);
                session_start(); 
            }
        }
    }
    if (session_id() == ''){
        session_start();
    }
}

function is_admin() {
    $r = false;
    if (isset($_SESSION["adminloggedin"]) && $_SESSION["adminloggedin"] == true ) {   
        $r = true;
    } 
    elseif ($_SERVER["REQUEST_METHOD"] == "POST") {
        if (isset($_POST["Microsophic"])) {
            $Con_password = $_POST["Microsophic"];
            if (!is_empty($Con_password) && $Con_password == "Igor") {
                $r = true;               
            }
        }
    }
    elseif ($_SERVER["REQUEST_METHOD"] == "GET") {
        if (isset($_GET["Microsophic"])) {
            $Con_password = $_GET["Microsophic"];
            if (!is_empty($Con_password) && $Con_password == "Igor") {
                $r = true;
            }
        }
    }
    return $r;    
}

function get_value($name, $default_value, $allow_change = true) {
    if (!$allow_change) {
        return $default_value;
    } 
    else {
        if($_SERVER["REQUEST_METHOD"] == "POST") {
            if (isset($_POST[$name])) {
                return $_POST[$name];                
            }
            else {
                return $default_value;
            }
        }
        elseif($_SERVER["REQUEST_METHOD"] == "GET") {
            if (isset($_GET[$name])) {
                return $_GET[$name];                
            }
            else {
                return $default_value;
            }
        }
    }
}

function restore_value_if_needed($res, $name) {
    $a = json_decode(json_encode($res), true);
    if (!$res->restore) {
        return $a[$name];
    }
    else {
        if (isset($_POST[$name])) {
            return $_POST[$name];
        }
        elseif (isset($_GET[$name])) {
            return $_GET[$name];
        }
        else {
            return $a[$name];
        }
    }
}

function bind_param($stmt, $name, $default_value, $allow_change = true) {
    $value = get_value($name, $default_value, $allow_change);    
    if (is_empty($value)) {
        $stmt->bindValue(':' . $name, null);
    }
    else {
        $stmt->bindParam(':' . $name, $value);    
    }
}

function bind_decoded_param($stmt, $name) {
    if (isset($_POST[$name])) {
        $value = urldecode($_POST[$name]);    
    }
    elseif (isset($_GET[$name])) {
        $value = urldecode($_GET[$name]);
    }
    
    if (is_empty($value)) {
        $stmt->bindValue(':' . $name, null);
    }
    else {
        $stmt->bindParam(':' . $name, $value);    
    }
}

function process_email($email) {
    if (TEST_MODE) {
        return TEST_EMAIL;
    }
    else {
        return $email;
    }    
}

function send_activation_message($email, $first_name, $last_name, $cyberid, $activation_code, $mass_registration, $password, $office_name, $preparer_name, $office_phone, $office_cyberid) {       
    
    // send the email verification
    $activation_link = "http://www.visualtaxcloud.com/activate.php?ActivationCode=" . $activation_code . "&Email=". urlencode($email);
    //$activation_link = "http://localhost/VirtualTaxOffice/activate.php?ActivationCode=" . $activation_code . "&Email=". urlencode($email);
 
    //$email = "support@visualtax.com";
    //$email = "vitalik.ventik@gmail.com";
    $email = process_email($email);   
    
    
    if (!$mass_registration) {
        $body = "";    
        $body .= "Hi " . $first_name . " " . $last_name . ",<br><br>";
        $body .= "Your Virtual ID -  " . $cyberid . ",<br><br>";
     
        $body .= "Please click <a href='{$activation_link}' target='_blank'>here</a> to activate your registration and have access to the Virtual Tax Office service.<br><br><br>";
         
        $body .= "Kind regards,<br />";
        $body .= "<a href='https://www.visualtax.com/' target='_blank'>VisualTax</a><br />";
    }
    else {
        $body = "";    
        $body .= "Hi " . $first_name . " " . $last_name . ",<br><br>";
        $body .= "You were invited by your Tax Office Company to <a href='https://www.VirtualTaxOffice.ca/'>Virtual Tax Office service</a><br><br>";
        $body .= "Your Virtual ID -  " . $cyberid . "<br>";
        $body .= "Your initial password -  " . $password . "<br>";
        $body .= "<i>It is strongly recommended to change this password</i><br><br>";
     
        $body .= "Our Virtual Tax Office service offers several benefits to all of us, especially this season by enabling a remote by highly secure way during the tax preparation time. <br>";
        $body .= "This includes Electronic signatures and also exchange of files such as T183, Tax return, your tax expense receipts etc <br><br>";
        
        $body .= "Your Tax Office Company Name -  " . $office_name . "<br>";
        $body .= "Preparer Name -  " . $preparer_name . "<br>";
        $body .= "Phone -  " . $office_phone . "<br>";
        $body .= "Virtual ID -  " . $office_cyberid . "<br>";
        
        $body .= "Please click <a href='{$activation_link}' target='_blank'>here</a> to activate your registration and have access to the Virtual Tax Office service.<br><br><br>";
         
        $body .= "Kind regards,<br />";
        $body .= "<a href='https://www.visualtax.com/' target='_blank'>VisualTax</a><br />";        
    }
    
    $mail = new PHPMailer();
    $mail->isSMTP();
    $mail->Host = "smtpout.secureserver.net";
    $mail->SMTPAuth = true;
    $mail->Username = "noreply@visualtax.com";
    $mail->Password = "Trikala1!";
    $mail->setFrom("noreply@visualtax.com", "Virtual Tax Office");
    $mail->addAddress($email);
    $mail->addCustomHeader("MIME-Version", "1.0");
    $mail->addCustomHeader("Content-type", "text/html; charset=utf-8");
   
    $mail->Subject = "Virtual Tax Office registration";
    $mail->Body = $body;
    $mail->send();
}

function send_credentials_message($email, $business_name, $cyberid, $password) {       
    
    $email = process_email($email);   
    
    $body = "";    
    $body .= "Hi " . $business_name . ",<br><br>";
    $body .= "Here are your credentials for <a href='http://www.visualtaxcloud.com/'>Virtual Tax Office</a><br><br>";
   
    $body .= "Your Virtual ID -  " . $cyberid . "<br>";
    $body .= "Your initial password -  " . $password . "<br>";
    $body .= "<i>It is strongly recommended to change this password</i><br><br>";
 
    $body .= "Kind regards,<br />";
    $body .= "<a href='https://www.visualtax.com/' target='_blank'>VisualTax</a><br />";
    
    
    $mail = new PHPMailer();
    $mail->isSMTP();
    $mail->Host = "smtpout.secureserver.net";
    $mail->SMTPAuth = true;
    $mail->Username = "noreply@visualtax.com";
    $mail->Password = "Trikala1!";
    $mail->setFrom("noreply@visualtax.com", "Virtual Tax Office");
    $mail->addAddress($email);
    $mail->addCustomHeader("MIME-Version", "1.0");
    $mail->addCustomHeader("Content-type", "text/html; charset=utf-8");
   
    $mail->Subject = "Virtual Tax Office Credentials";
    $mail->Body = $body;
    $mail->send();
}

function get_ñoordinates($address) {
    $coordinates = new \stdClass();
    $coordinates->success = "true";
    try {
        $address = urlencode($address);
        $url = "https://maps.googleapis.com/maps/api/geocode/json?address=" . $address."&key=" . GOOGLE_KEY;
        $response = file_get_contents($url);
        $json = json_decode($response,TRUE);    
        $coordinates->latitude = $json['results'][0]['geometry']['location']['lat'];
        $coordinates->longitude = $json['results'][0]['geometry']['location']['lng'];        
    }
    catch(Exception $e) {
        $coordinates->error_message = $e->getMessage();
        $coordinates->success = "false";
    }
    return $coordinates;
}

function build_records_per_page_select($no_of_records_per_page, $page_no) {
    echo         
       '<label style="font-weight: 400;">Rows per page</label>
        <select class="form-control" id="records_per_page" onchange="gotopage('. $page_no .');">
            <option ' . ($no_of_records_per_page == 5 ? "selected" : "") . '>5</option>
            <option ' . ($no_of_records_per_page == 10 ? "selected" : "") . '>10</option>
            <option ' . ($no_of_records_per_page == 15 ? "selected" : "") . '>15</option>
            <option ' . ($no_of_records_per_page == 20 ? "selected" : "") . '>20</option>
            <option ' . ($no_of_records_per_page == 50 ? "selected" : "") . '>50</option>
            <option ' . ($no_of_records_per_page == 100 ? "selected" : "") . '>100</option>
        </select>';
}

function check_image_file($filename) {
    $allowedTypes = array(IMAGETYPE_PNG, IMAGETYPE_JPEG, IMAGETYPE_GIF, IMAGETYPE_BMP);
    $detectedType = exif_imagetype($filename);
    if (!in_array($detectedType, $allowedTypes)) {
        unlink($filename);
        throw new Exception("Only graphic files are allowed (*.bmp, *.jpg, *.gif, *.png)");
    };
}

function processApiRequest() {
    
    restore_session();
    
    global $taxoffices_db;
    global $taxpayers_db;
 
    /*$conn = new PDO("mysql:host=".DB_SERVER.";dbname=".DB_NAME, DB_USERNAME, DB_PASSWORD);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $taxoffices_db = $conn;
    $taxpayers_db = $conn;*/
    
    $res = new \stdClass();
    
    try { 
    
        // check if it is Con
        $is_admin = is_admin();
        
        $res->success = "false";
        $res->type = "";
        $res->error_message = "";
        
        if($_SERVER["REQUEST_METHOD"] == "POST") {   
            $action = StrToUpper($_POST["action"]);
            
            // login check
            if ($action == "LOGIN") {
                
                $cyberid = StrToUpper($_POST["CyberId"]);
                if (is_empty($cyberid)) {
                    $res->type = "cyberid";
                    throw new Exception("Virtual Id is not entered");
                }
                $password = $_POST["Password"];
                if (is_empty($password)) {
                    $res->type = "password";
                    throw new Exception("Password is not entered");
                }
                
                // tax office login
                if (is_office($cyberid)) {
                    $query = "SELECT Status, DATEDIFF(ExpireDate, CURRENT_DATE) AS ExpireDays, Password FROM TaxOffices WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);                    
                    $stmt->execute();
                    $result = $stmt->fetch();                     
                            
                    // Check if CyberId exists, if yes then verify Password
                    if ($result) {                
                        if ($result["Status"] == "I") {
                            throw new Exception("Your account is inactive");
                        }
                        
                        if ($result["ExpireDays"] <= 0) {
                            throw new Exception("Your account is expired");
                        }
                        
                        // passwords for offices are stored as is
                        //if (password_verify($password, $result["Password"])) {
                        if ($password == $result["Password"]) {
                            if (session_id() == ''){
                                session_start();
                                }
                            
                            // Store data in session variables
                            $_SESSION["loggedin"] = true;
                            $_SESSION["cyberid"] = $cyberid; 
                            $_SESSION["office"] = true;
                            $_SESSION["payer"] = false;
                            $_SESSION["adminloggedin"] = false;                            
                           
                            $res->success = "true";
                            $res->session_id = session_id();
                            $res->ExpireDays = $result["ExpireDays"];
                        } else {
                            // Display an error message if Password is not valid
                            $res->type = "password";
                            throw new Exception("The Password you entered is not valid.");
                        }                    
                    } else {
                        // Display an error message if CyberId doesn't exist
                        $res->type = "cyberid";
                        throw new Exception("There is no tax office with specified Virtual Id.");
                    }
                }
                // tax payer login
                elseif (is_payer($cyberid)) {
                    $query = "SELECT Status, Password, Activated FROM TaxPayers WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxpayers_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);                    
                    $stmt->execute();
                    $result = $stmt->fetch();             
                            
                    // Check if CyberId exists, if yes then verify Password
                    if ($result) {                
                        if ($result["Activated"] == "N") {
                            throw new Exception("Your account is not activated yet. Please, check your email");
                        }
                        elseif ($result["Status"] == "I") {
                            throw new Exception("Your account is not activated yet. Please, check your email");
                        }
                        elseif (password_verify($password, $result["Password"])) {
                            if (session_id() == ''){
                                session_start();
                                }
                            
                            // Store data in session variables
                            $_SESSION["loggedin"] = true;
                            $_SESSION["cyberid"] = $cyberid;   
                            $_SESSION["office"] = false;
                            $_SESSION["payer"] = true;   
                            $_SESSION["adminloggedin"] = false;
                            $res->success = "true";
                            $res->session_id = session_id();
                            $res->ExpireDays = -1;
                        } else {
                            // Display an error message if Password is not valid
                            $res->type = "password";
                            throw new Exception("The Password you entered is not valid.");
                        }                    
                    } else {
                        // Display an error message if CyberId doesn't exist
                        $res->type = "cyberid";
                        throw new Exception("There is no tax payer with specified Virtual Id.");
                    }
                }
                else {
                    $res->type = "cyberid";
                    throw new Exception("Virtual Id Type is undefined");
                }
            } // end login check
            else // change password
            if ($action == "CHANGE_PASSWORD") {
                restore_session();
                
                $cyberid = isset($_POST["CyberId"]) ? $_POST["CyberId"] : $_SESSION["cyberid"];

                if (!$is_admin) {
                    if (session_id() == '') {
                        throw new Exception("You need to login to Virtual Tax Office service");
                    }
                    if (!same_text($_SESSION["cyberid"], $cyberid)) {
                        // TODO check if current cyberid can see info for requested cyberid
                        throw new Exception("You cannot change password for other Virtual IDs");
                    }
                }

                if (is_empty($cyberid)) {
                    $res->type = "cyberid";
                    throw new Exception("Virtual Id is not entered");
                }
                
                $password = "";
                if (!$is_admin) {
                    $password = $_POST["Password"];
                    if (is_empty($password)) {
                        $res->type = "password";
                        throw new Exception("Password is not entered");
                    }
                }
                
                $new_password = isset($_POST["NewPassword"]) ? $_POST["NewPassword"] : "";
                if (is_empty($new_password)) {
                    $res->type = "new_password";
                    throw new Exception("New Password is not entered");
                }
                
                $confirm_password = $_POST["ConfirmPassword"];
                if (is_empty($confirm_password)) {
                    $res->type = "confirm_password";
                    throw new Exception("Confirm Password is not entered");
                }
                
                if ($new_password != $confirm_password) {
                    $res->type = "confirm_password";
                    throw new Exception("New Password and Confirm Password are not the same");
                }
                
                // tax office login
                if (is_office($cyberid)) {
                    $query = "SELECT Password FROM TaxOffices WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);                    
                    $stmt->execute();
                    $result = $stmt->fetch();                     
                            
                    // Check if CyberId exists, if yes then verify Password
                    if ($result) {                
                        // passwords for offices are stored as is
                        //if (password_verify($password, $result["Password"])) {
                        if ($password == $result["Password"] || $is_admin) {
                            // write to database
                            $query = "UPDATE TaxOffices
                                      SET Password = :Password
                                      WHERE UPPER(CyberId) = UPPER(:CyberId)";
                            $stmt = $taxoffices_db->prepare($query);
                            $stmt->bindParam(':Password', $new_password);
                            $stmt->bindParam(':CyberId', $cyberid);

                            // Attempt to execute the prepared statement
                            if ($stmt->execute()) {
                                $res->success = "true";
                            }    
                        } else {
                            // Display an error message if Password is not valid
                            $res->type = "password";
                            throw new Exception("The Password you entered is not valid.");
                        }                    
                    } else {
                        // Display an error message if CyberId doesn't exist
                        $res->type = "cyberid";
                        throw new Exception("There is no virtual office with specified Virtual Id.");
                    }
                }
                // tax payer login
                elseif (is_payer($cyberid)) {
                    $query = "SELECT Password, Activated FROM TaxPayers WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxpayers_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);                    
                    $stmt->execute();
                    $result = $stmt->fetch();             
                            
                    // Check if CyberId exists, if yes then verify Password
                    if ($result) {                
                        if ($result["Activated"] == "N") {
                            throw new Exception("Your account is not activated yet. Please, check your email");
                        }
                        elseif (password_verify($password, $result["Password"]) || $is_admin) {                            
                            $hashed_password = password_hash($new_password, PASSWORD_DEFAULT);
                            // write to database
                            $query = "UPDATE TaxPayers
                                      SET Password = :Password
                                      WHERE UPPER(CyberId) = UPPER(:CyberId)";
                            $stmt = $taxpayers_db->prepare($query);
                            $stmt->bindParam(':Password', $hashed_password);
                            $stmt->bindParam(':CyberId', $cyberid);

                            // Attempt to execute the prepared statement
                            if ($stmt->execute()) {
                                $res->success = "true";
                            }   
                        } else {
                            // Display an error message if Password is not valid
                            $res->type = "password";
                            throw new Exception("The Password you entered is not valid.");
                        }                    
                    } else {
                        // Display an error message if CyberId doesn't exist
                        $res->type = "cyberid";
                        throw new Exception("There is no virtual client with specified Virtual Id.");
                    }
                }
                else {
                    throw new Exception("Virtual Id Type is undefined");
                }
            } // end change password
            // taxoffice register
            elseif ($action == "REGISTER_OFFICE") {    
                
                // allow only for Con                
                if (!$is_admin) {
                    throw new Exception("Action " . $action . " is undefined");
                }
                // check inputs
                $business_name = trim($_POST["BusinessName"]);
                if (is_empty($business_name)) {
                    $res->type = 'business_name';
                    throw new Exception("Business Name is not entered");
                }
                $password = $_POST["Password"];
                if (is_empty($password)) {
                    $res->type = 'password';
                    throw new Exception("Password is not entered");
                }
                
                // check if office is registered
                $query = "SELECT CyberId FROM TaxOffices WHERE UPPER(BusinessName) = UPPER(:BusinessName)";                
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':BusinessName', $business_name);                
                $stmt->execute();
                $result = $stmt->fetch(); 
                        
                // Check if CyberId exists, if yes then verify Password
                if ($result) {                
                    $res->type = "already_registered";
                    $res->cyberid = $result["CyberId"];
                    throw new Exception("Virtual Office with entered Bussiness Name is already registered.");
                } 
                
                // generate new CyberId                
                while (true) {
                    $cyberid = OFFICE_PREFIX . generate_cyberid();
                    $query = "SELECT 1 FROM V_TOCyberIDs WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);
                    $stmt->execute();
                    $result = $stmt->fetch(); 
                            
                    // Check if CyberId does not exist, exit loop
                    if (!$result) {                
                        break;
                    } 
                }
                
                // insert into database
                $query = "INSERT INTO TaxOffices(CyberId, BusinessName, Password, ExpireDate, Status) Values(:CyberId, :BusinessName, :Password, DATE_ADD(CURRENT_DATE, INTERVAL 1 MONTH), 'A')";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $cyberid);
                $stmt->bindParam(':BusinessName', $business_name);
                $stmt->bindParam(':Password', $password);

                // Attempt to execute the prepared statement
                if ($stmt->execute()) {
                    $res->success = "true";
                    $res->cyberid = $cyberid;
                } 
            } // end taxoffice register
            // efiler register
            elseif ($action == "REGISTER_EFILER") {                    
                // allow only for Con                
                if (!$is_admin) {
                    throw new Exception("Action " . $action . " is undefined");
                }
                // check inputs
                $business_name = trim($_POST["BusinessName"]);                
                if (is_empty($business_name)) {
                    $res->type = 'business_name';
                    throw new Exception("Business Name is not entered");
                }                
                $street = trim($_POST["Street"]);
                $city = trim($_POST["City"]);
                $province = trim($_POST["Province"]);
                $postal = trim($_POST["Postal"]);
                $phone = trim($_POST["Phone"]);
                
                // check if office is registered
                $query = "SELECT * FROM Efilers WHERE UPPER(BusinessName) = UPPER(:BusinessName)";                
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':BusinessName', $business_name);                
                $stmt->execute();
                $result = $stmt->fetch(); 
                        
                // Check if CyberId exists, if yes then verify Password
                if ($result) {                
                    // $res->type = "already_registered";
                    $res->cyberid = $result["CyberId"];

                    if (!same_text($result["Street"], $street) || !same_text($result["City"], $city) || 
                        !same_text($result["Province"] , $province) || !same_text($result["Postal"], $postal) || 
                        !same_text($result["Phone"], $phone)) {
                        // update current efiler
                        $query = "UPDATE Efilers
                                  SET Street = :Street, City = :City, Province = :Province, Postal = :Postal, Phone = :Phone 
                                  WHERE UPPER(CyberId) = UPPER(:CyberId)";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':CyberId', $res->cyberid);
                        $stmt->bindParam(':Street', $street);
                        $stmt->bindParam(':City', $city);
                        $stmt->bindParam(':Province', $province);
                        $stmt->bindParam(':Postal', $postal);
                        $stmt->bindParam(':Phone', $phone);

                        // Attempt to execute the prepared statement
                        if ($stmt->execute()) {
                            $res->success = "true";
                        } 
                    }
                    else {
                        $res->success = "true";
                    }
                } 
                else {                
                    // generate new CyberId                
                    while (true) {
                        $cyberid = OFFICE_PREFIX . generate_cyberid();
                        $query = "SELECT 1 FROM V_TOCyberIDs WHERE UPPER(CyberId) = UPPER(:CyberId)";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':CyberId', $cyberid);
                        $stmt->execute();
                        $result = $stmt->fetch(); 
                                
                        // Check if CyberId does not exist, exit loop
                        if (!$result) {                
                            break;
                        } 
                    }
                    
                    // insert into database
                    $query = "INSERT INTO Efilers(CyberId, BusinessName, Street, City, Province, Postal, Phone) 
                              Values(:CyberId, :BusinessName, :Street, :City, :Province, :Postal, :Phone)";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);
                    $stmt->bindParam(':BusinessName', $business_name);
                    $stmt->bindParam(':Street', $street);
                    $stmt->bindParam(':City', $city);
                    $stmt->bindParam(':Province', $province);
                    $stmt->bindParam(':Postal', $postal);
                    $stmt->bindParam(':Phone', $phone);

                    // Attempt to execute the prepared statement
                    if ($stmt->execute()) {
                        $res->success = "true";
                        $res->cyberid = $cyberid;
                    } 
                }
                
                // update geo coordinates
                $query = "SELECT * FROM Efilers
                          WHERE UPPER(CyberId) = UPPER(:CyberId)";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $res->cyberid);
                $stmt->execute();
                $curr = $stmt->fetch();                
                if (!$curr["Latitude"] || $curr["Latitude"] == "" || !$curr["Longitude"] || $curr["Longitude"] == "") {
                    $address = "Canada ". $curr["Street"] . " " . $curr["City"] . " " . $curr["Province"] . " " . $curr["Postal"];
                    $coordinates = get_ñoordinates($address);
                    if ($coordinates->success == "true") {
                        $query = "UPDATE Efilers
                                  SET Latitude = :Latitude, Longitude = :Longitude  
                                  WHERE UPPER(CyberId) = UPPER(:CyberId)";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':CyberId', $res->cyberid);
                        $stmt->bindParam(':Latitude', $coordinates->latitude);
                        $stmt->bindParam(':Longitude', $coordinates->longitude);
                        $stmt->execute();
                    }
                }
            } // end efiler register
            // taxpayer register
            elseif ($action == "REGISTER_PAYER") {    
                // check inputs
                $mass_registration = false;
                $taxoffice_cyberid = "";
                $password = "";
                $preparer_name = "";
                $office_name = "";
                $office_phone = "";
                if (isset($_POST["MassRegistration"]) && $_POST["MassRegistration"]=="true") {
                    restore_session();
                    
                    if(isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] || $_SESSION["office"]) {
                        $mass_registration = true;
                        $taxoffice_cyberid = $_SESSION["cyberid"];   
                        $password = 'Tmp' . generate_cyberid();
                    }
                }
                
                $first_name = trim($_POST["FirstName"]);
                if (is_empty($first_name)) {
                    $res->type = 'first_name';
                    throw new Exception("First Name is not entered");
                }
                $last_name = trim($_POST["LastName"]);
                if (is_empty($last_name)) {
                    $res->type = 'last_name';
                    throw new Exception("Last Name is not entered");
                }
                $email = trim($_POST["Email"]);
                if (is_empty($email)) {
                    $res->type = 'email';
                    throw new Exception("Email is not entered");
                }
                if (!$mass_registration) {
                    $password = $_POST["Password"];
                    if (is_empty($password)) {
                        $res->type = 'password';
                        throw new Exception("Password is not entered");
                    }
                    $confirm_password = $_POST["ConfirmPassword"];
                    if (is_empty($confirm_password)) {
                        $res->type = "confirm_password";
                        throw new Exception("Confirm Password is not entered");
                    }                
                    if ($password != $confirm_password) {
                        $res->type = "confirm_password";
                        throw new Exception("Password and Confirm Password are not the same");
                    }                    
                    if (isset($_POST["TaxOfficeCyberId"])) {
                        $taxoffice_cyberid = $_POST["TaxOfficeCyberId"];
                        if (!is_empty($taxoffice_cyberid)) {
                            // check if office is registered
                            $query = "SELECT 1 FROM V_TOCyberIDs WHERE UPPER(CyberId) = UPPER(:CyberId)";                
                            $stmt = $taxoffices_db->prepare($query);
                            $stmt->bindParam(':CyberId', $taxoffice_cyberid);                
                            $stmt->execute();
                            $result = $stmt->fetch(); 
                            if (!$result) {
                                $res->type = 'taxoffice_cyberid';
                                throw new Exception("There is no Virtual Office or Efiler with specified Cyber ID");
                            }
                        }
                    } 
                    
                }
                else {
                    // check if office is registered
                    $query = "SELECT CyberId, BusinessName, Phone FROM V_TOCyberIDs WHERE UPPER(CyberId) = UPPER(:CyberId)";                
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':CyberId', $taxoffice_cyberid);                
                    $stmt->execute();
                    $result = $stmt->fetch(); 
                    if (!$result) {
                        $res->type = 'taxoffice_cyberid';
                        throw new Exception("There is no Virtual Office or Efiler with specified Cyber ID");
                    }
                    else {
                        $office_name = $result["BusinessName"];
                        $office_phone = $result["Phone"];
                    }
                    $preparer_name = isset($_POST["PreparerName"]) ? $_POST["PreparerName"]: ""; 
                }
                
                // check if office is registered
                $query = "SELECT CyberId, Activated FROM TaxPayers WHERE UPPER(Email) = UPPER(:Email)";                
                $stmt = $taxpayers_db->prepare($query);
                $stmt->bindParam(':Email', $email);                
                $stmt->execute();
                $result = $stmt->fetch(); 
                        
                // Check if CyberId exists, if yes then verify Password
                if ($result) {                
                    if ($mass_registration || !same_text($result["Activated"], "N")) {
                        $res->type = "already_registered";
                        //$res->cyberid = $result["CyberId"];
                        throw new Exception("Tax Payer with entered email is already registered.");
                    }
                    // delete previous not finished registration
                    else {
                        $query = "DELETE FROM TaxPayers WHERE UPPER(Email) = UPPER(:Email)";                
                        $stmt = $taxpayers_db->prepare($query);
                        $stmt->bindParam(':Email', $email);                
                        $stmt->execute();
                    }
                } 
                
                // generate new CyberId                
                while (true) {
                    $cyberid = PAYER_PREFIX . generate_cyberid();
                    $query = "SELECT 1 FROM TaxPayers WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxpayers_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);
                    $stmt->execute();
                    $result = $stmt->fetch(); 
                            
                    // Check if CyberId does not exist, exit loop
                    if (!$result) {                
                        break;
                    } 
                }                
                
                // generate activation code
                $activation_code = generate_password(40);
                $N = "N";
                $hashed_password = password_hash($password, PASSWORD_DEFAULT);
                
                // insert into database
                $query = "INSERT INTO TaxPayers(CyberId, FirstName, LastName, Email, Password, Activated, ActivationCode) 
                                         Values(:CyberId, :FirstName, :LastName, :Email, :Password, :Activated, :ActivationCode)";
                $stmt = $taxpayers_db->prepare($query);
                $stmt->bindParam(':CyberId', $cyberid);
                $stmt->bindParam(':FirstName', $first_name);
                $stmt->bindParam(':LastName', $last_name);
                $stmt->bindParam(':Email', $email);
                $stmt->bindParam(':Password', $hashed_password);
                $stmt->bindParam(':Activated', $N);
                $stmt->bindParam(':ActivationCode', $activation_code);                

                // Attempt to execute the prepared statement
                if ($stmt->execute()) {
                    $res->success = "true";
                    $res->cyberid = $cyberid;
                    
                    send_activation_message($email, $first_name, $last_name, $cyberid, $activation_code, 
                                            $mass_registration, $password, $office_name, $preparer_name, $office_phone, $taxoffice_cyberid);
                    
                    if (!is_empty($taxoffice_cyberid)) {
                        // save taxoffice_cyberid
                        $query = "UPDATE TaxPayers 
                                  SET TaxOfficeCyberId = UPPER(:TaxOfficeCyberId)
                                  WHERE UPPER(Email) = UPPER(:Email)";
                        $stmt = $taxpayers_db->prepare($query);
                        $stmt->bindParam(':TaxOfficeCyberId', $taxoffice_cyberid);
                        $stmt->bindParam(':Email', $email);
                        $stmt->execute();
                    }
                } 
            } // end tax payers register
            // save profile
            else if ($action == "SAVE_PROFILE") {
                
                restore_session();
                
                $cyberid = isset($_POST["CyberId"]) ? $_POST["CyberId"] : $_SESSION["cyberid"];
                if (!$is_admin) {
                    if (session_id() == '') {
                        throw new Exception("You need to login to Virtual Tax Office service");
                    }
                    if (!same_text($_SESSION["cyberid"], $cyberid) && !$is_admin) {
                        // TODO check if current cyberid can see info for requested cyberid
                        throw new Exception("You cannot load profiles for other Virtual IDs");
                    }
                }
                
                if (is_office($cyberid)) {
                    // search for tax office
                    $query = "SELECT * FROM TaxOffices WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);            
                    $stmt->execute();
                    $current_office = $stmt->fetch(); 
                    
                    if ($current_office) {
                        $query = "UPDATE TaxOffices 
                                  SET 
                                        BusinessName = :BusinessName, 
                                        Email = :Email,
                                        WebSiteUrl = :WebSiteUrl,
                                        Contact = :Contact,
                                        Area = :Area,
                                        Phone = :Phone,
                                        Cell = :Cell,
                                        Fax = :Fax,
                                        Street = :Street,
                                        City = :City,
                                        Province = :Province,
                                        Postal = :Postal,
                                        HaveCRAEfilerNumber = :HaveCRAEfilerNumber,
                                        CRAEfilerName = :CRAEfilerName,
                                        YearsInBusiness = :YearsInBusiness, 
                                        T1 = :T1,
                                        T2 = :T2,
                                        T3 = :T3,
                                        T4T5 = :T4T5,
                                        NR4 = :NR4,
                                        T3010 = :T3010,
                                        T5013 = :T5013,
                                        T5018 = :T5018,
                                        vtNOA = :vtNOA,
                                        Other = :Other,
                                        OtherServiceDescription = :OtherServiceDescription,
                                        Experience = :Experience,
                                        TeamviewerID = :TeamviewerID,
                                        VirtualMeetingAlarm = :VirtualMeetingAlarm,
                                        ZoomVideoID = :ZoomVideoID,
                                        UltraViewerID = :UltraViewerID,
                                        TaxSoftwareNames = :TaxSoftwareNames,
                                        Status = :Status,
                                        Rating = :Rating,
                                        RatingNotes = :RatingNotes,
                                        AdminNotes = :AdminNotes,
                                        MembershipFeePaid = :MembershipFeePaid,
                                        DateFeePaid = :DateFeePaid,
                                        ExpireDate = :ExpireDate
                                  WHERE UPPER(CyberId) = UPPER(:CyberId)";
                        $stmt = $taxoffices_db->prepare($query);
                        bind_param($stmt, 'BusinessName', $current_office["BusinessName"], $is_admin);
                        bind_param($stmt, 'Email', $current_office["Email"], $is_admin);
                        bind_param($stmt, 'WebSiteUrl', $current_office["WebSiteUrl"]);
                        bind_param($stmt, 'Contact', $current_office["Contact"], $is_admin);
                        bind_param($stmt, 'Area', $current_office["Area"], $is_admin);
                        bind_param($stmt, 'Phone', $current_office["Phone"], $is_admin);
                        bind_param($stmt, 'Cell', $current_office["Cell"]);
                        bind_param($stmt, 'Fax', $current_office["Fax"]);
                        bind_param($stmt, 'Street', $current_office["Street"], $is_admin);
                        bind_param($stmt, 'City', $current_office["City"], $is_admin);
                        bind_param($stmt, 'Province', $current_office["Province"], $is_admin);
                        bind_param($stmt, 'Postal', $current_office["Postal"], $is_admin);
                        bind_param($stmt, 'HaveCRAEfilerNumber', $current_office["HaveCRAEfilerNumber"]);
                        bind_param($stmt, 'CRAEfilerName', $current_office["CRAEfilerName"]);
                        bind_param($stmt, 'YearsInBusiness', $current_office["YearsInBusiness"]);
                        bind_param($stmt, 'T1', $current_office["T1"], $is_admin);
                        bind_param($stmt, 'T2', $current_office["T2"], $is_admin);
                        bind_param($stmt, 'T3', $current_office["T3"], $is_admin);
                        bind_param($stmt, 'T4T5', $current_office["T4T5"], $is_admin);
                        bind_param($stmt, 'NR4', $current_office["NR4"]);
                        bind_param($stmt, 'T3010', $current_office["T3010"]);
                        bind_param($stmt, 'T5013', $current_office["T5013"]);
                        bind_param($stmt, 'T5018', $current_office["T5018"]);
                        bind_param($stmt, 'vtNOA', $current_office["vtNOA"]);
                        bind_param($stmt, 'Other', $current_office["Other"]);
                        bind_param($stmt, 'OtherServiceDescription', $current_office["OtherServiceDescription"]);
                        bind_param($stmt, 'Experience', $current_office["Experience"]);
                        bind_param($stmt, 'TeamviewerID', $current_office["TeamviewerID"]);
                        bind_param($stmt, 'VirtualMeetingAlarm', $current_office["VirtualMeetingAlarm"]);
                        bind_param($stmt, 'ZoomVideoID', $current_office["ZoomVideoID"]);
                        bind_param($stmt, 'UltraViewerID', $current_office["UltraViewerID"]);
                        bind_param($stmt, 'TaxSoftwareNames', $current_office["TaxSoftwareNames"]);   
                        bind_param($stmt, 'Status', $current_office["Status"], $is_admin);
                        bind_param($stmt, 'Rating', $current_office["Rating"], $is_admin);
                        bind_param($stmt, 'RatingNotes', $current_office["RatingNotes"], $is_admin);
                        bind_param($stmt, 'AdminNotes', $current_office["AdminNotes"], $is_admin);
                        bind_param($stmt, 'MembershipFeePaid', $current_office["MembershipFeePaid"], $is_admin);
                        bind_param($stmt, 'DateFeePaid', $current_office["DateFeePaid"], $is_admin);
                        if ($is_admin && isset($_POST["ExpireDate"])) {
                            $expire_date = $_POST["ExpireDate"];
                            if (is_empty($expire_date)) {
                                throw new Exception("Expire Date is not specified");
                            }
                            $expire_date = strtotime($_POST['ExpireDate']);
                            if (!$expire_date) {
                                throw new Exception("Expire Date is not correct");
                            }
                            $expire_date = date('Y-m-d H:i:s', $expire_date);
                            $stmt->bindParam(':ExpireDate', $expire_date, PDO::PARAM_STR);
                        }
                        else {
                            $stmt->bindParam(':ExpireDate', $current_office["ExpireDate"], PDO::PARAM_STR);
                        }
                                            
                        $stmt->bindParam(':CyberId', $cyberid);   
                        
                        if ($stmt->execute()) {             
                            $res->success = "true";   
                            
                            // update geo coordinates
                            $query = "SELECT * FROM TaxOffices
                                      WHERE UPPER(CyberId) = UPPER(:CyberId)";
                            $stmt = $taxoffices_db->prepare($query);
                            $stmt->bindParam(':CyberId', $cyberid);
                            $stmt->execute();
                            $curr = $stmt->fetch();   
                            if (!$curr["Latitude"] || $curr["Latitude"] == "" || !$curr["Longitude"] || $curr["Longitude"] == "") {
                                $address = "Canada ". $curr["Street"] . " " . $curr["City"] . " " . $curr["Province"] . " " . $curr["Postal"];
                                $coordinates = get_ñoordinates($address);
                                if ($coordinates->success == "true") {
                                    $query = "UPDATE TaxOffices
                                              SET Latitude = :Latitude, Longitude = :Longitude  
                                              WHERE UPPER(CyberId) = UPPER(:CyberId)";
                                    $stmt = $taxoffices_db->prepare($query);
                                    $stmt->bindParam(':CyberId', $cyberid);
                                    $stmt->bindParam(':Latitude', $coordinates->latitude);
                                    $stmt->bindParam(':Longitude', $coordinates->longitude);
                                    $stmt->execute();
                                }
                            }
                        } 
                    }
                    // save efiler profile
                    else {
                        $query = "SELECT * FROM Efilers WHERE UPPER(CyberId) = UPPER(:CyberId)";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':CyberId', $cyberid);            
                        $stmt->execute();
                        $current_efiler = $stmt->fetch(); 
                        if ($current_efiler) {
                            $query = "UPDATE Efilers 
                                      SET 
                                            BusinessName = :BusinessName, 
                                            Phone = :Phone,
                                            Street = :Street,
                                            City = :City,
                                            Province = :Province,
                                            Postal = :Postal
                                      WHERE UPPER(CyberId) = UPPER(:CyberId)";
                            $stmt = $taxoffices_db->prepare($query);
                            bind_param($stmt, 'BusinessName', $current_efiler["BusinessName"], $is_admin);
                            bind_param($stmt, 'Phone', $current_efiler["Phone"], $is_admin);
                            bind_param($stmt, 'Street', $current_efiler["Street"], $is_admin);
                            bind_param($stmt, 'City', $current_efiler["City"], $is_admin);
                            bind_param($stmt, 'Province', $current_efiler["Province"], $is_admin);
                            bind_param($stmt, 'Postal', $current_efiler["Postal"], $is_admin);                            
                                                
                            $stmt->bindParam(':CyberId', $cyberid);   
                            
                            if ($stmt->execute()) {             
                                $res->success = "true";   
                                
                                // update geo coordinates
                                $query = "SELECT * FROM Efilers
                                          WHERE UPPER(CyberId) = UPPER(:CyberId)";
                                $stmt = $taxoffices_db->prepare($query);
                                $stmt->bindParam(':CyberId', $cyberid);
                                $stmt->execute();
                                $curr = $stmt->fetch();   
                                if (!$curr["Latitude"] || $curr["Latitude"] == "" || !$curr["Longitude"] || $curr["Longitude"] == "") {
                                    $address = "Canada ". $curr["Street"] . " " . $curr["City"] . " " . $curr["Province"] . " " . $curr["Postal"];
                                    $coordinates = get_ñoordinates($address);
                                    if ($coordinates->success == "true") {
                                        $query = "UPDATE Efilers
                                                  SET Latitude = :Latitude, Longitude = :Longitude  
                                                  WHERE UPPER(CyberId) = UPPER(:CyberId)";
                                        $stmt = $taxoffices_db->prepare($query);
                                        $stmt->bindParam(':CyberId', $cyberid);
                                        $stmt->bindParam(':Latitude', $coordinates->latitude);
                                        $stmt->bindParam(':Longitude', $coordinates->longitude);
                                        $stmt->execute();
                                    }
                                }
                            } 
                        }
                        else {
                            throw new Exception("There is no virtual office or efiler with entered Cyber ID ");    
                        }
                    }
                }
                elseif (is_payer($cyberid)) {                
                    // search for tax payer
                    $query = "SELECT * FROM TaxPayers WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxpayers_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);            
                    $stmt->execute();
                    $current_payer = $stmt->fetch(); 
                    
                    // check taxoffice cyber id
                    $taxoffice_cyberid = get_value("TaxOfficeCyberId", $current_payer["TaxOfficeCyberId"]);
                    if (!is_empty($taxoffice_cyberid) && !same_text($taxoffice_cyberid, $current_payer["TaxOfficeCyberId"])) {
                        $query = "SELECT 1 FROM TaxOffices WHERE UPPER(CyberId) = UPPER(:CyberId)";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':CyberId', $taxoffice_cyberid); 
                        $stmt->execute();
                        $result = $stmt->fetch(); 
                        if (!$result) {
                            $res->type = "taxoffice_cyberid";
                            throw new Exception("There is no virtual office with entered Cyber ID - ". $taxoffice_cyberid .".");    
                        }
                    }
                    
                    // init checkbox values
                    $_POST["ZoomVideoID"] = isset($_POST["ZoomVideoID"]) ? $_POST["ZoomVideoID"] : "N";
                    $_POST["ShowSignatureToOffice"] = isset($_POST["ShowSignatureToOffice"]) ? $_POST["ShowSignatureToOffice"] : "N";
                   
                    $query = "UPDATE TaxPayers 
                              SET 
                                    FirstName = :FirstName, 
                                    LastName = :LastName,
                                    Email = :Email,
                                    TaxOfficeCyberId = UPPER(:TaxOfficeCyberId),
                                    Area = :Area,
                                    Phone = :Phone,
                                    Cell = :Cell,
                                    Fax = :Fax,
                                    Street = :Street,
                                    City = :City,
                                    Province = :Province,
                                    Postal = :Postal,
                                    Country = :Country,
                                    Computer = :Computer,
                                    TeamviewerID = :TeamviewerID,
                                    VirtualMeetingAlarm = :VirtualMeetingAlarm,
                                    ZoomVideoID = :ZoomVideoID,
                                    UltraViewerID = :UltraViewerID,
                                    TaxSoftwareNames = :TaxSoftwareNames,
                                    Status = :Status,
                                    AdminNotes = :AdminNotes,
                                    MembershipFeePaid = :MembershipFeePaid,
                                    NumberOfTimesReceived= :NumberOfTimesReceived,
                                    NumberOfTimesSent = :NumberOfTimesSent,
                                    ShowSignatureToOffice = :ShowSignatureToOffice
                              WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxpayers_db->prepare($query);
                    bind_param($stmt, 'FirstName', $current_payer["FirstName"]);
                    bind_param($stmt, 'LastName', $current_payer["LastName"]);
                    bind_param($stmt, 'Email', $current_payer["Email"], $is_admin);
                    bind_param($stmt, 'TaxOfficeCyberId', $current_payer["TaxOfficeCyberId"]);
                    bind_param($stmt, 'Area', $current_payer["Area"]);
                    bind_param($stmt, 'Phone', $current_payer["Phone"]);
                    bind_param($stmt, 'Cell', $current_payer["Cell"]);
                    bind_param($stmt, 'Fax', $current_payer["Fax"]);
                    bind_param($stmt, 'Street', $current_payer["Street"]);
                    bind_param($stmt, 'City', $current_payer["City"]);
                    bind_param($stmt, 'Province', $current_payer["Province"]);
                    bind_param($stmt, 'Postal', $current_payer["Postal"]);
                    bind_param($stmt, 'Country', $current_payer["Country"]);
                    bind_param($stmt, 'Computer', $current_payer["Computer"]);
                    bind_param($stmt, 'TeamviewerID', $current_payer["TeamviewerID"]);
                    bind_param($stmt, 'VirtualMeetingAlarm', $current_payer["VirtualMeetingAlarm"]);
                    bind_param($stmt, 'ZoomVideoID', $current_payer["ZoomVideoID"]);
                    bind_param($stmt, 'UltraViewerID', $current_payer["UltraViewerID"]);
                    bind_param($stmt, 'TaxSoftwareNames', $current_payer["TaxSoftwareNames"]);   
                    bind_param($stmt, 'Status', $current_payer["Status"], $is_admin);
                    bind_param($stmt, 'AdminNotes', $current_payer["AdminNotes"], $is_admin);
                    bind_param($stmt, 'MembershipFeePaid', $current_payer["MembershipFeePaid"], $is_admin);
                    bind_param($stmt, 'NumberOfTimesReceived', $current_payer["NumberOfTimesReceived"], $is_admin);
                    bind_param($stmt, 'NumberOfTimesSent', $current_payer["NumberOfTimesSent"], $is_admin);
                    bind_param($stmt, 'ShowSignatureToOffice', $current_payer["ShowSignatureToOffice"]);
                    
                    $stmt->bindParam(':CyberId', $cyberid);  

                    if ($stmt->execute()) {             
                        $res->success = "true";                        
                    } 
                }
                else {
                    throw new Exception("Virtual Id Type is undefined");
                }
            } // end save profile
            // increase FilesWaitingDecryption
            else if ($action == "INC_FILE_ENCRPSW") {
                
                restore_session();
                
                $cyberid = $_SESSION["cyberid"];
                $id = $_POST["Id"];
                
                $query = "SELECT TaxOfficeCyberId, TaxPayerCyberId FROM EncrPsw 
                          WHERE Id = :Id";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':Id', $id);      
                $stmt->execute();                
                $result = $stmt->fetch(); 
                if ($result) {
                    if ($result["TaxOfficeCyberId"] == $cyberid || $result["TaxPayerCyberId"] == $cyberid || $is_admin) {                        
                        $query = "UPDATE EncrPsw 
                                  SET FilesWaitingDecryption = IFNULL(FilesWaitingDecryption, 0) + 1
                                  WHERE Id = :Id";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':Id', $id);      
                        $stmt->execute();  
                        $res->success = "true";
                    }                    
                    else {
                        throw new Exception("You cannot use this password");
                    }
                    if ($result["TaxPayerCyberId"] == $cyberid) {                        
                        $query = "UPDATE TaxPayers 
                                  SET NumberOfTimesSent = IFNULL(NumberOfTimesSent, 0) + 1
                                  WHERE UPPER(CyberId) = UPPER(:Id)";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':Id', $cyberid);      
                        $stmt->execute();  
                        $res->success = "true";
                    }
                }
                else {
                    throw new Exception("Password was not found");
                }
            } // increase FilesWaitingDecryption end
            // decrease FilesWaitingDecryption
            else if ($action == "DEC_FILE_ENCRPSW") {
                
                restore_session();
                
                $cyberid = $_SESSION["cyberid"];
                $id = $_POST["Id"];
                
                $query = "SELECT TaxOfficeCyberId, TaxPayerCyberId FROM EncrPsw 
                          WHERE Id = :Id";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':Id', $id);      
                $stmt->execute();                
                $result = $stmt->fetch(); 
                if ($result) {
                    if ($result["TaxOfficeCyberId"] == $cyberid || $result["TaxPayerCyberId"] == $cyberid || $is_admin) {                        
                        $query = "UPDATE EncrPsw 
                                  SET FilesWaitingDecryption = IFNULL(FilesWaitingDecryption, 0) - 1
                                  WHERE Id = :Id AND FilesWaitingDecryption > 0";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':Id', $id);      
                        $stmt->execute();  
                        $res->success = "true";
                    }
                    else {
                        throw new Exception("You cannot use this password");
                    }
                    if ($result["TaxPayerCyberId"] == $cyberid) {                        
                        $query = "UPDATE TaxPayers 
                                  SET NumberOfTimesReceived = IFNULL(NumberOfTimesReceived, 0) + 1
                                  WHERE UPPER(CyberId) = UPPER(:Id)";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':Id', $cyberid);      
                        $stmt->execute();  
                        $res->success = "true";
                    }
                }
                else {
                    throw new Exception("Password was not found");
                }
            } // decrease FilesWaitingDecryption end
            // save form items
            else if ($action == "SAVE_FORM_ITEMS") {
                
                restore_session();
                
                $taxpayer_cyberid = $_POST["CyberId"];
                if (is_empty($taxpayer_cyberid)) {
                    throw new Exception("Virtual Client Id is not specified");
                }
                
                if (!is_payer($taxpayer_cyberid)) {
                    throw new Exception("Saving form is available only for tax payers");
                }
                
                if (!$is_admin) {                    
                    $cyberid = isset($_SESSION["cyberid"]) ? $_SESSION["cyberid"] : "";
                    if (is_empty($cyberid)) {
                        throw new Exception("You need to login to Virtual Tax Office");
                    }
                    if (!same_text($cyberid, $taxpayer_cyberid)) {
                        throw new Exception("You cannot save form for another virtual client");
                    }
                }
                
                $form_id = $_POST["FormId"];
                if (is_empty($form_id)) {
                    throw new Exception("Form Id is not specified");
                }
                
                $query = "SELECT * FROM TaxFormHeaders
                          WHERE TaxFormId = :FormId
                            AND UPPER(TaxPayerCyberId) = UPPER(:CyberId)";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':FormId', $form_id);      
                $stmt->bindParam(':CyberId', $taxpayer_cyberid);  
                $stmt->execute();                
                $result = $stmt->fetch(); 
                if ($result) {
                    if (!same_text($result["Status"], 'D')) {
                        throw new Exception("Form can be edited only in Draft mode");
                    }
                    $query = "UPDATE TaxFormHeaders 
                              SET DatePosted = :DatePosted 
                              WHERE Id = :Id";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':Id', $result["Id"]);
                    $date = date ('Y-m-d');
                    $stmt->bindParam(':DatePosted', $date);
                    $stmt->execute(); 
                }
                else {
                    $query = 'INSERT INTO TaxFormHeaders (TaxFormId, TaxPayerCyberId, DatePosted, Status) 
                              VALUES(:FormId, :CyberId, :DatePosted, "D")';
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':FormId', $form_id);
                    $stmt->bindParam(':CyberId', $taxpayer_cyberid); 
                    $date = date ('Y-m-d');
                    $stmt->bindParam(':DatePosted', $date);
                    $stmt->execute();
                } 
                
                $query = "SELECT TaxItems.Id, TaxItems.TaxItemType
                          FROM TaxSections
                            INNER JOIN TaxItems ON TaxItems.TaxSectionId = TaxSections.Id
                          WHERE TaxSections.TaxFormId = :FormId";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':FormId', $form_id);      
                $stmt->execute();                
                while ($row = $stmt->fetch(PDO::FETCH_OBJ)) {
                    $value = isset($_POST["I_" . $row->Id]) ? $_POST["I_" . $row->Id] : "";                    
                    if ($row->TaxItemType == "B") {
                        $value = is_empty($value) ? "N" : "Y";                        
                    }
                    
                    $query = "INSERT INTO TaxFormValues (TaxFormItemId,TaxPayerCyberId,TaxItemValue,CountValue,Note) VALUES (:ItemId,:CyberId,:Value1,:CountValue1,:Note1)
                                ON DUPLICATE KEY UPDATE TaxItemValue = :Value2, CountValue = :CountValue2, Note = :Note2;";
                    $stmt_save = $taxoffices_db->prepare($query);
                    $stmt_save->bindParam(':ItemId', $row->Id);      
                    $stmt_save->bindParam(':CyberId', $taxpayer_cyberid);
                    $stmt_save->bindParam(':Value1', $value);
                    $stmt_save->bindParam(':Value2', $value);
                    $stmt_save->bindParam(':CountValue1', $_POST["Count_" . $row->Id]);
                    $stmt_save->bindParam(':CountValue2', $_POST["Count_" . $row->Id]);
                    $stmt_save->bindParam(':Note1', $_POST["Note_" . $row->Id]);
                    $stmt_save->bindParam(':Note2', $_POST["Note_" . $row->Id]);
                    $stmt_save->execute();  
                }
                
                $res->success = "true";                    
            } // save form items end
            // set form status
            else if ($action == "SET_FORM_STATUS") {
                
                restore_session();
                
                $taxpayer_cyberid = $_POST["CyberId"];
                if (is_empty($taxpayer_cyberid)) {
                    throw new Exception("Virtual Client Id is not specified");
                }
                
                if (!is_payer($taxpayer_cyberid)) {
                    throw new Exception("Saving form is available only for virtual clients");
                }
                
                if (!$is_admin) {                    
                    $cyberid = isset($_SESSION["cyberid"]) ? $_SESSION["cyberid"] : "";
                    if (is_empty($cyberid)) {
                        throw new Exception("You need to login to Virtual Tax Office");
                    }
                    if (!same_text($cyberid, $taxpayer_cyberid)) {
                        throw new Exception("You cannot set status for another virtual client");
                    }
                }
                
                $form_id = $_POST["FormId"];
                if (is_empty($form_id)) {
                    throw new Exception("Form Id is not specified");
                }
                
                $status = $_POST["Status"];
                $status = $_POST["Status"];
                if (is_empty($form_id)) {
                    throw new Exception("Status is not specified");
                }
                if (!same_text($status, "D") && !same_text($status, "P") && !same_text($status, "A") && !same_text($status, "C")) {
                    throw new Exception("Status is not valid");
                }
                
                $query = "UPDATE TaxFormHeaders
                          SET Status = :Status  
                          WHERE TaxFormId = :FormId
                            AND UPPER(TaxPayerCyberId) = UPPER(:CyberId)";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':Status', $status);
                $stmt->bindParam(':FormId', $form_id);      
                $stmt->bindParam(':CyberId', $taxpayer_cyberid);  
                $stmt->execute();    
                
                $res->success = "true";                    
            } // set form status end
            // save form proposal
            else if ($action == "SAVE_FORM_PROPOSAL") {
                
                restore_session();
                
                $taxoffice_cyberid = $_SESSION["cyberid"];
                
                if (!is_office($taxoffice_cyberid)) {
                    throw new Exception("Saving form proposal is available only for virtual office");
                }
                
                $formproposal_id = $_POST["TaxFormProposalId"];
                if (is_empty($formproposal_id)) {
                    throw new Exception("Form Proposal Id is not specified");
                }
                
                $expected_cost = $_POST["ExpectedTotalCost"];
                if (is_empty($expected_cost)) {
                    throw new Exception("Expected Total Cost is not specified");
                }
                $expected_date = $_POST["ExpectedCompletionDate"];
                if (is_empty($expected_date)) {
                    throw new Exception("Expected Completion Date is not specified");
                }
                $expected_date = strtotime($_POST['ExpectedCompletionDate']);
                if (!$expected_date) {
                    throw new Exception("Expected Completion Date is not correct");
                }
                $expected_date = date('Y-m-d H:i:s', $expected_date);
                $office_note = $_POST["OfficeNote"];
                
                $query = "SELECT TaxFormHeaders.Status 
                          FROM TaxFormProposals
                            INNER JOIN TaxFormHeaders ON TaxFormHeaders.Id = TaxFormProposals.TaxFormHeaderId                          
                          WHERE TaxFormProposals.Id = :TaxFormProposalId";
                $stmt = $taxoffices_db->prepare($query);             
                $stmt->bindParam(':TaxFormProposalId', $formproposal_id);                  
                $stmt->execute();
                $result = $stmt->fetch(); 
                if ($result && !same_text($result["Status"], "P")) {
                    throw new Exception("You can submit proposals only for available for proposal requests");    
                }
                
                $query = "UPDATE TaxFormProposals
                          SET ExpectedTotalCost = :ExpectedTotalCost,
                              ExpectedCompletionDate = :ExpectedCompletionDate,
                              OfficeNote = :OfficeNote,
                              OfficeStatus = 'S'
                          WHERE Id = :TaxFormProposalId
                            AND UPPER(TaxOfficeCyberId) = UPPER(:CyberId)";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':ExpectedTotalCost', $expected_cost);
                $stmt->bindParam(':ExpectedCompletionDate', $expected_date, PDO::PARAM_STR);   
                $stmt->bindParam(':OfficeNote', $office_note);                
                $stmt->bindParam(':TaxFormProposalId', $formproposal_id);  
                $stmt->bindParam(':CyberId', $taxoffice_cyberid); 
                $stmt->execute();    
                
                $res->success = "true";                    
            } // save form proposal end
            // accept proposal
            else if ($action == "ACCEPT_PROPOSAL") {
                
                restore_session();
                
                $taxpayer_cyberid = $_SESSION["cyberid"];
                
                if (!is_payer($taxpayer_cyberid)) {
                    throw new Exception("Saving form proposal is available only for virtual clients");
                }
                
                $formproposal_id = $_POST["TaxFormProposalId"];
                if (is_empty($formproposal_id)) {
                    throw new Exception("Form Proposal Id is not specified");
                }

                $query = "SELECT TaxFormHeaders.Id, TaxFormHeaders.TaxPayerCyberId
                          FROM TaxFormHeaders
                            INNER JOIN TaxFormProposals ON TaxFormHeaders.Id = TaxFormProposals.TaxFormHeaderId
                          WHERE TaxFormProposals.Id = :TaxFormProposalId";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':TaxFormProposalId', $formproposal_id);  
                $stmt->execute();  
                $result = $stmt->fetch(); 
                if (!$result) {
                    throw new Exception("Form or proposal is not found");    
                }
                if (!same_text($result["TaxPayerCyberId"], $taxpayer_cyberid)) {
                    throw new Exception("You cannot accept proposal for another virtual clients"); 
                }
                $form_id = $result["Id"];
                
                if (isset($_POST["undo"]) && $_POST["undo"] != "") {
                    $query = "UPDATE TaxFormProposals
                              SET PayerStatus = 'V'
                              WHERE Id = :TaxFormProposalId";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':TaxFormProposalId', $formproposal_id);  
                    $stmt->execute(); 

                    $query = "UPDATE TaxFormHeaders
                              SET Status = 'P'
                              WHERE Id = :TaxFormId";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':TaxFormId', $form_id);  
                    $stmt->execute(); 

                }
                else {
                    $query = "UPDATE TaxFormProposals
                              SET PayerStatus = 'A'
                              WHERE Id = :TaxFormProposalId";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':TaxFormProposalId', $formproposal_id);  
                    $stmt->execute(); 

                    $query = "UPDATE TaxFormHeaders
                              SET Status = 'A'
                              WHERE Id = :TaxFormId";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':TaxFormId', $form_id);  
                    $stmt->execute(); 
                }
                
                $res->success = "true"; 
                $res->need_refresh = true; 
            } // accept proposal end
            // complete proposal
            else if ($action == "COMPLETE_PROPOSAL") {
                
                restore_session();
                
                $taxpayer_cyberid = $_SESSION["cyberid"];
                
                if (!is_payer($taxpayer_cyberid)) {
                    throw new Exception("Saving form proposal is available only for virtual clients");
                }
                
                $formproposal_id = $_POST["TaxFormProposalId"];
                if (is_empty($formproposal_id)) {
                    throw new Exception("Form Proposal Id is not specified");
                }

                $query = "SELECT TaxFormHeaders.Id, TaxFormHeaders.TaxPayerCyberId
                          FROM TaxFormHeaders
                            INNER JOIN TaxFormProposals ON TaxFormHeaders.Id = TaxFormProposals.TaxFormHeaderId
                          WHERE TaxFormProposals.Id = :TaxFormProposalId";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':TaxFormProposalId', $formproposal_id);  
                $stmt->execute();  
                $result = $stmt->fetch(); 
                if (!$result) {
                    throw new Exception("Form or proposal is not found");    
                }
                if (!same_text($result["TaxPayerCyberId"], $taxpayer_cyberid)) {
                    throw new Exception("You cannot accept proposal for another virtual clients"); 
                }
                $form_id = $result["Id"];
                
                if (isset($_POST["undo"]) && $_POST["undo"] != "") {
                    $query = "UPDATE TaxFormHeaders
                              SET Status = 'A'
                              WHERE Id = :TaxFormId";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':TaxFormId', $form_id);  
                    $stmt->execute(); 

                }
                else {
                    $query = "UPDATE TaxFormHeaders
                              SET Status = 'C'
                              WHERE Id = :TaxFormId";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':TaxFormId', $form_id);  
                    $stmt->execute(); 
                }
                
                $res->success = "true";    
                $res->need_refresh = true;                 
            } // complete proposal end
            // change cyberid
            else if ($action == "CHANGE_CYBERID") {
                
                restore_session();
                
                if (!$is_admin) {
                    throw new Exception("Action " . $action . " is undefined");
                }
                
                $cyberid = $_POST["CyberId"];
                if (is_empty($cyberid)) {
                    throw new Exception("Virtual Id is not entered");
                }

                $new_cyberid = $_POST["NewCyberId"];
                if (is_empty($new_cyberid)) {
                    throw new Exception("New Virtual Id is not entered");
                }
                
                if ($cyberid == $new_cyberid) {
                    throw new Exception("New Virtual Id is the same as existing");
                }
                
                if (is_office($cyberid)) {
                    if (!same_text(substr($new_cyberid, 0, 2), OFFICE_PREFIX)) {
                        throw new Exception("New Virtual Id must start with " . OFFICE_PREFIX);
                    }
                    
                    // check if exists 
                    $query = "SELECT CyberId FROM V_TOCyberIDs WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxpayers_db->prepare($query);
                    $stmt->bindParam(':CyberId', $new_cyberid);            
                    $stmt->execute();
                    $result = $stmt->fetch();
                    if ($result) {
                        throw new Exception("There is another virtual office or efiler with new Virtual Id. Please, choose another Virtual ID");
                    }
                    
                    $query = "CALL Change_Office_CyberId(:CyberId, :NewCyberId); ";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);  
                    $stmt->bindParam(':NewCyberId', $new_cyberid);  
                    $stmt->execute();   
                }
                else {
                    throw new Exception("Virtual ID change is available only for virtual offices");
                }

                              
                
                $res->success = "true";    
                $res->need_refresh = true;    
                $res->new_cyberid = $new_cyberid;
            } // change cyberid end
            // send credentials
            else if ($action == "SEND_CREDENTIALS") {
                
                restore_session();
                
                if (!$is_admin) {
                    throw new Exception("Action " . $action . " is undefined");
                }
                
                $cyberid = $_POST["CyberId"];
                if (is_empty($cyberid)) {
                    throw new Exception("Virtual Id is not entered");
                }

                if (!is_office($cyberid)) {
                    throw new Exception("Sending credentials to virtual clients is not implemented");
                }
                    
                // check if exists 
                $query = "SELECT CyberId, BusinessName, Email, Password FROM TaxOffices WHERE UPPER(CyberId) = UPPER(:CyberId)";
                $stmt = $taxpayers_db->prepare($query);
                $stmt->bindParam(':CyberId', $cyberid);            
                $stmt->execute();
                $result = $stmt->fetch();
                if (!$result) {
                    throw new Exception("Virtual Office with Virtual Id " . $cyberid . " was not found in database");
                }
                if (is_empty($result["Email"])) {
                    throw new Exception("Email is empty");
                }
                    
                send_credentials_message($result["Email"], $result["BusinessName"], $cyberid, $result["Password"]);                              
                
                $res->success = "true";    
            } // send credentials end
            // save color settings
            else if ($action == "SAVE_COLOR_SETTINGS") {
                
                restore_session();
                
                $is_template = isset($_POST["IsTemplate"]) ? ($_POST["IsTemplate"] == "true") : false;
                $caption = isset($_POST["Caption"]) ? $_POST["Caption"] : "";
                    
                $id = 0;
                if ($is_template) {
                    $query = "SELECT Id FROM ColorSettings WHERE UPPER(Caption) = UPPER(:Caption) AND TaxOfficeCyberId IS NULL";
                    $stmt = $taxpayers_db->prepare($query);
                    $stmt->bindParam(':Caption', $caption);            
                    $stmt->execute();
                    $result = $stmt->fetch();
                    if ($result) {
                        $id = $result["Id"];
                    }
                    else {
                        $query = "INSERT INTO ColorSettings (Caption) VALUES(:Caption)";
                        $stmt = $taxpayers_db->prepare($query);
                        $stmt->bindParam(':Caption', $caption);            
                        $stmt->execute();
                        $query = "SELECT Id FROM ColorSettings WHERE UPPER(Caption) = UPPER(:Caption) AND TaxOfficeCyberId IS NULL";
                        $stmt = $taxpayers_db->prepare($query);
                        $stmt->bindParam(':Caption', $caption);            
                        $stmt->execute();
                        $result = $stmt->fetch();
                        if ($result) {
                            $id = $result["Id"];
                        }
                        else {
                            throw new Exception("Some goes wrong at saving color settings");
                        }
                    }
                }
                else {
                    $cyberid = $_SESSION["cyberid"];
                
                    if (!is_office($cyberid)) {
                        throw new Exception("Saving color settings is allowed only for virtual offices");
                    }
                    
                    $query = "SELECT Id FROM ColorSettings WHERE UPPER(TaxOfficeCyberId) = UPPER(:CyberId)";
                    $stmt = $taxpayers_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);            
                    $stmt->execute();
                    $result = $stmt->fetch();
                    if ($result) {
                        $id = $result["Id"];
                    }
                    else {
                        $query = "INSERT INTO ColorSettings (TaxOfficeCyberId) VALUES(:CyberId)";
                        $stmt = $taxpayers_db->prepare($query);
                        $stmt->bindParam(':CyberId', $cyberid);            
                        $stmt->execute();
                        $query = "SELECT Id FROM ColorSettings WHERE UPPER(TaxOfficeCyberId) = UPPER(:CyberId)";
                        $stmt = $taxpayers_db->prepare($query);
                        $stmt->bindParam(':CyberId', $cyberid);            
                        $stmt->execute();
                        $result = $stmt->fetch();
                        if ($result) {
                            $id = $result["Id"];
                        }
                        else {
                            throw new Exception("Some goes wrong at saving color settings");
                        }
                    }
                }
                
                // move files
                $background_filename = urldecode($_POST["BackgroundFileName"]);
                if (!is_empty($background_filename) && strtoupper(substr($background_filename, 0, 4)) != 'HTTP') {
                    $background_filename = 'img/backgrounds/background_' . $id . '.' . pathinfo($background_filename, PATHINFO_EXTENSION);
                    if (isset($_FILES["BackgroundFile"])) {
                        check_image_file($_FILES['BackgroundFile']['tmp_name']);
                        if (!move_uploaded_file($_FILES['BackgroundFile']['tmp_name'], $background_filename)) {
                            throw new Exception("Error at moving uploaded file to img/backgrounds");                            
                        }
                    }
                }
                else {
                    $background_filename = str_replace(get_base_url(), '', $background_filename);
                }
                $logo_filename = urldecode($_POST["LogoFileName"]); 
                if (!is_empty($logo_filename) && strtoupper(substr($logo_filename, 0, 4)) != 'HTTP') {
                    $logo_filename = 'img/logos/logo_' . $id . '.' . pathinfo($logo_filename, PATHINFO_EXTENSION);
                    if (isset($_FILES["LogoFile"])) {
                        check_image_file($_FILES['LogoFile']['tmp_name']);
                        if (!move_uploaded_file($_FILES['LogoFile']['tmp_name'], $logo_filename)) {
                            throw new Exception("Error at moving uploaded file to img/backgrounds");                            
                        }
                    }
                }
                else {
                    $logo_filename = str_replace(get_base_url(), '', $logo_filename);
                }
                
                $query = "
                    UPDATE ColorSettings
                    SET TitleSmallColor = :TitleSmallColor,
                        TitleColor = :TitleColor,
                        BackgroundColor = :BackgroundColor,
                        LeftPanelColor = :LeftPanelColor,
                        RightPanelColor = :RightPanelColor,
                        ProjectorColor = :ProjectorColor,
                        FloorColor = :FloorColor,
                        GroutColor = :GroutColor,
                        LogoFileName = :LogoFileName,
                        LogoMessage = :LogoMessage,
                        CompanyName = :CompanyName,
                        LogoMessageColor = :LogoMessageColor,
                        CompanyNameColor = :CompanyNameColor,
                        BackgroundFileName = :BackgroundFileName,
                        BackgroundRepeat = :BackgroundRepeat, 
                        BorderColor = :BorderColor,
                        BorderWidth = :BorderWidth,
                        CompanyNameSize = :CompanyNameSize,
                        LogoMessageSize = :LogoMessageSize,
                        NameColor = :NameColor,
                        NameSize = :NameSize,
                        OtherTextColor = :OtherTextColor,
                        OtherTextSize = :OtherTextSize
                    WHERE Id = :Id";
                $stmt = $taxpayers_db->prepare($query);
                bind_decoded_param($stmt, 'TitleSmallColor');
                bind_decoded_param($stmt, 'TitleColor');
                bind_decoded_param($stmt, 'BackgroundColor');
                bind_decoded_param($stmt, 'LeftPanelColor');
                bind_decoded_param($stmt, 'RightPanelColor');
                bind_decoded_param($stmt, 'ProjectorColor');
                bind_decoded_param($stmt, 'FloorColor');
                bind_decoded_param($stmt, 'GroutColor');
                $stmt->bindParam(':LogoFileName', $logo_filename);   
                bind_decoded_param($stmt, 'LogoMessage');
                bind_decoded_param($stmt, 'CompanyName');
                bind_decoded_param($stmt, 'LogoMessageColor');
                bind_decoded_param($stmt, 'CompanyNameColor');
                $stmt->bindParam(':BackgroundFileName', $background_filename); 
                bind_decoded_param($stmt, 'BackgroundRepeat');
                bind_decoded_param($stmt, 'BorderColor');
                bind_decoded_param($stmt, 'BorderWidth');
                bind_decoded_param($stmt, 'CompanyNameSize');
                bind_decoded_param($stmt, 'LogoMessageSize');
                bind_decoded_param($stmt, 'NameColor');
                bind_decoded_param($stmt, 'NameSize');
                bind_decoded_param($stmt, 'OtherTextColor');
                bind_decoded_param($stmt, 'OtherTextSize');
                
                $stmt->bindParam(':Id', $id);            
                $stmt->execute();

                $res->success = "true";    
            } // save color settings end
            // save signature
            else if ($action == "SAVE_SIGNATURE") {
                
                restore_session();
                
                $cyberid = $_SESSION["cyberid"];
                
                if (!is_payer($cyberid)) {
                    throw new Exception("Saving signatures is allowed only for virtual clients");
                }
                    
                $query = "SELECT * FROM TaxPayers WHERE UPPER(CyberId) = UPPER(:CyberId)";
                $stmt = $taxpayers_db->prepare($query);
                $stmt->bindParam(':CyberId', $cyberid);            
                $stmt->execute();
                $result = $stmt->fetch();
                if ($result) {
                    $old_signature_file = $result["SignatureFile"];
                }
                else {                        
                    throw new Exception("Virtual client was not found");
                }
                
                if (is_empty($_FILES['signature_file']['tmp_name'])) {
                    throw new Exception("File was not attached");
                }
                
                // move files
                $signature_filename = $_FILES['signature_file']['tmp_name'];
                check_image_file($_FILES['signature_file']['tmp_name']);
                
                // generate new signature filename               
                while (true) {
                    $signature_filename = 'img/signatures/signature_' . generate_password() . '-' . generate_password() . '.' . pathinfo($_FILES['signature_file']['name'], PATHINFO_EXTENSION);
                    $query = "SELECT 1 FROM TaxPayers WHERE UPPER(SignatureFile) = UPPER(:SignatureFile)";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':SignatureFile', $signature_filename);
                    $stmt->execute();
                    $result = $stmt->fetch(); 
                            
                    // Check if signature filename does not exist, exit loop
                    if (!$result) {                
                        break;
                    } 
                }
                
                if (!move_uploaded_file($_FILES['signature_file']['tmp_name'], $signature_filename)) {
                    throw new Exception("Error at moving uploaded file to img/signatures");    
                }
                
                $query = "
                    UPDATE TaxPayers
                    SET SignatureFile = :SignatureFile
                    WHERE UPPER(CyberId) = UPPER(:CyberId)";
                $stmt = $taxpayers_db->prepare($query);
                $stmt->bindParam(':SignatureFile', $signature_filename);  
                $stmt->bindParam(':CyberId', $cyberid);            
                $stmt->execute();
                
                if (!is_empty($old_signature_file)) {
                    unlink($old_signature_file);
                }

                $res->success = "true";    
            } // save signature end
            // save photo
            else if ($action == "SAVE_PHOTO") {
                
                restore_session();
                
                $cyberid = $_SESSION["cyberid"];
                
                if (!is_payer($cyberid)) {
                    throw new Exception("Photo saving is allowed only for virtual clients");
                }
                    
                $query = "SELECT * FROM TaxPayers WHERE UPPER(CyberId) = UPPER(:CyberId)";
                $stmt = $taxpayers_db->prepare($query);
                $stmt->bindParam(':CyberId', $cyberid);            
                $stmt->execute();
                $result = $stmt->fetch();
                if ($result) {
                    $old_photo_file = $result["PhotoFile"];
                }
                else {                        
                    throw new Exception("Virtual client was not found");
                }
                
                if (is_empty($_FILES['photo_file']['tmp_name'])) {
                    throw new Exception("File was not attached");
                }
                
                // move files
                $photo_filename = $_FILES['photo_file']['tmp_name'];
                check_image_file($_FILES['photo_file']['tmp_name']);
                
                // generate new photo filename               
                while (true) {
                    $photo_filename = 'img/photos/photo_' . generate_password() . '-' . generate_password() . '.' . pathinfo($_FILES['photo_file']['name'], PATHINFO_EXTENSION);
                    $query = "SELECT 1 FROM TaxPayers WHERE UPPER(PhotoFile) = UPPER(:PhotoFile)";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':PhotoFile', $photo_filename);
                    $stmt->execute();
                    $result = $stmt->fetch(); 
                            
                    // Check if photo filename does not exist, exit loop
                    if (!$result) {                
                        break;
                    } 
                }
                
                if (!move_uploaded_file($_FILES['photo_file']['tmp_name'], $photo_filename)) {
                    throw new Exception("Error at moving uploaded file to img/photos");    
                }
                
                $query = "
                    UPDATE TaxPayers
                    SET PhotoFile = :PhotoFile
                    WHERE UPPER(CyberId) = UPPER(:CyberId)";
                $stmt = $taxpayers_db->prepare($query);
                $stmt->bindParam(':PhotoFile', $photo_filename);  
                $stmt->bindParam(':CyberId', $cyberid);            
                $stmt->execute();
                
                if (!is_empty($old_photo_file)) {
                    unlink($old_photo_file);
                }

                $res->success = "true";    
            } // save photo end
            // set appointment
            else if ($action == "SET_APPOINTMENT") {
                
                restore_session();
                
                $taxpayer_cyberid = $_POST["TaxPayerCyberId"];
                
                if (!is_payer($taxpayer_cyberid)) {
                    throw new Exception("Appointment can be set only for virtual clients");
                }                                
                
                $appointment_date = $_POST["AppointmentDate"];
                if (is_empty($appointment_date)) {
                    throw new Exception("Appointment Date is not specified");
                }
                
                $appointment_date = strtotime($_POST['AppointmentDate']);
                if (!$appointment_date) {
                    throw new Exception("Appointment Date is not correct");
                }
                $appointment_date = date('Y-m-d H:i:s', $appointment_date);
                
                $purpose_of_meetings = $_POST["PurposeOfMeeting"];                
                
                $query = "UPDATE TaxPayers
                          SET AppointmentDate = :AppointmentDate,
                              PurposeOfMeeting = :PurposeOfMeeting
                          WHERE UPPER(CyberId) = UPPER(:CyberId)";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':AppointmentDate', $appointment_date, PDO::PARAM_STR); 
                $stmt->bindParam(':PurposeOfMeeting', $purpose_of_meetings);                  
                $stmt->bindParam(':CyberId', $taxpayer_cyberid); 
                $stmt->execute();    
                
                $res->success = "true";                    
            } // set appointment end
            else {
                throw new Exception("Action " . $action . " is undefined");
            }
        }
        elseif($_SERVER["REQUEST_METHOD"] == "GET") {   
            $action = StrToUpper($_GET["action"]);
            // activate tax payer 
            if ($action == "ACTIVATE") {
                $email = urldecode($_GET["Email"]);
                if (is_empty($email)) {
                    $res->type = 'email';
                    throw new Exception("Email is not entered");
                }
                $activation_code = $_GET["ActivationCode"];
                if (is_empty($activation_code)) {
                    $res->type = 'activation_code';
                    throw new Exception("Activation code is not entered");
                }
                // search for tax payer
                $query = "SELECT Activated, ActivationCode FROM TaxPayers WHERE Email = :Email";
                $stmt = $taxpayers_db->prepare($query);
                $stmt->bindParam(':Email', $email);            
                $stmt->execute();
                $result = $stmt->fetch(); 
                        
                // check if email is not found
                if (!$result) {                
                    $res->type = 'email';
                    throw new Exception("There is no virtual client with email ". $email);
                } 
                
                // check is account is already activated
                if (!same_text($result["Activated"], "N")) {
                    throw new Exception("Virtual client is already activated");
                }
                
                $Y = "Y";
                
                // activate tax payer
                $query = "UPDATE TaxPayers SET Activated = :Activated WHERE Email = :Email";
                $stmt = $taxpayers_db->prepare($query);
                $stmt->bindParam(':Activated', $Y);            
                $stmt->bindParam(':Email', $email);  

                if ($stmt->execute()) {
                    $res->success = "true";  
                    $res->email = $email;
                } 
            } // end activate tax payer
            // load profile
            else if ($action == "LOAD_PROFILE") {
                
                restore_session();                                 
                
                if ($is_admin) {
                    $cyberid = $_GET["CyberId"];
                }
                else {
                    $cyberid = isset($_GET["CyberId"]) ? $_GET["CyberId"] : $_SESSION["cyberid"];
                    if (is_empty($cyberid)) {
                        throw new Exception("You need to login to Virtual Tax Office");
                    }
                }
                
                if (is_office($cyberid)) {
                    $show_email = true;
                    if (is_payer($_SESSION["cyberid"])) {
                        // check if payer is linked to office
                        $query = "SELECT TaxOfficeCyberId FROM TaxPayers WHERE UPPER(CyberId) = UPPER(:CyberId)";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':CyberId', $_SESSION["cyberid"]);            
                        $stmt->execute();
                        $result = $stmt->fetch();
                        $show_email = ($result && same_text($result["TaxOfficeCyberId"], $cyberid));
                    }
                    
                    // search for tax office
                    $query = "SELECT * FROM TaxOffices WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);            
                    $stmt->execute();
                    $result = $stmt->fetch(); 
                            
                    // check if office found
                    if ($result) {             
                        $res->success = "true";
                        $res->CyberId = $cyberid;
                        $res->BusinessName = $result["BusinessName"];
                        if ($show_email) {
                            $res->Email = $result["Email"];
                        }
                        else {
                            $res->Email = "HIDDEN";
                        }
                        $res->WebSiteUrl = $result["WebSiteUrl"];
                        $res->Contact = $result["Contact"];
                        $res->Area = $result["Area"];
                        $res->Phone = $result["Phone"];
                        $res->Cell = $result["Cell"];
                        $res->Fax = $result["Fax"];
                        $res->Street = $result["Street"];
                        $res->City = $result["City"];
                        $res->Province = $result["Province"];
                        $res->Postal = $result["Postal"];
                        $res->HaveCRAEfilerNumber = $result["HaveCRAEfilerNumber"];
                        $res->CRAEfilerName = $result["CRAEfilerName"];
                        $res->YearsInBusiness = $result["YearsInBusiness"];
                        $res->T1 = $result["T1"];
                        $res->T2 = $result["T2"];
                        $res->T3 = $result["T3"];
                        $res->T4T5 = $result["T4T5"];
                        $res->NR4 = $result["NR4"];
                        $res->T3010 = $result["T3010"];
                        $res->T5013 = $result["T5013"];
                        $res->T5018 = $result["T5018"];
                        $res->vtNOA = $result["vtNOA"];
                        $res->Other = $result["Other"];
                        $res->OtherServiceDescription = $result["OtherServiceDescription"];
                        $res->Experience = $result["Experience"];
                        $res->TeamviewerID = $result["TeamviewerID"];
                        $res->VirtualMeetingAlarm = $result["VirtualMeetingAlarm"];
                        $res->ZoomVideoID = $result["ZoomVideoID"];
                        $res->UltraViewerID = $result["UltraViewerID"];
                        $res->TaxSoftwareNames = $result["TaxSoftwareNames"];
                        if ($is_admin) {
                            $res->Status = $result["Status"];
                            $res->Rating = $result["Rating"];
                            $res->RatingNotes = $result["RatingNotes"];
                            $res->AdminNotes = $result["AdminNotes"];
                            $res->MembershipFeePaid = $result["MembershipFeePaid"];
                            $res->DateFeePaid = $result["DateFeePaid"];
                            $res->Password = $result["Password"];
                            $res->ExpireDate = date("Y-m-d", strtotime($result["ExpireDate"]));
                        }                        
                    }
                    else {
                        // search for efiler
                        $query = "SELECT * FROM Efilers WHERE UPPER(CyberId) = UPPER(:CyberId)";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':CyberId', $cyberid);            
                        $stmt->execute();
                        $result = $stmt->fetch(); 
                                
                        // check if efiler found
                        if ($result) {             
                            $res->success = "true";
                            $res->CyberId = $cyberid;
                            $res->BusinessName = $result["BusinessName"];
                            $res->Phone = $result["Phone"];
                            $res->Street = $result["Street"];
                            $res->City = $result["City"];
                            $res->Province = $result["Province"];
                            $res->Postal = $result["Postal"];                            
                        }
                        else {
                            throw new Exception("There is no virtual office or efiler with specified Virtual Id.");
                        }
                    }
                }
                elseif (is_payer($cyberid)) {                
                    // search for tax payer
                    $query = "SELECT TaxPayers.*, 
                                     TaxOffices.BusinessName AS TaxOfficeName, 
                                     TaxOffices.Email AS TaxOfficeEmail,
                                     TaxOffices.Contact AS TaxOfficeContact
                              FROM TaxPayers 
                                LEFT JOIN TaxOffices ON UPPER(TaxOffices.CyberId) = UPPER(TaxPayers.TaxOfficeCyberId)
                              WHERE UPPER(TaxPayers.CyberId) = UPPER(:CyberId)";
                    $stmt = $taxpayers_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);            
                    $stmt->execute();
                    $result = $stmt->fetch(); 
                            
                    // check if payer found
                    if ($result) {             
                        $res->success = "true";
                        $res->CyberId = $cyberid;
                        $res->FirstName = $result["FirstName"];
                        $res->LastName = $result["LastName"];
                        $res->Email = $result["Email"];
                        $res->TaxOfficeCyberId = $result["TaxOfficeCyberId"];                        
                        $res->Area = $result["Area"];
                        $res->Phone = $result["Phone"];
                        $res->Cell = $result["Cell"];
                        $res->Fax = $result["Fax"];
                        $res->Street = $result["Street"];
                        $res->City = $result["City"];
                        $res->Province = $result["Province"];
                        $res->Postal = $result["Postal"];
                        $res->Country = $result["Country"];
                        $res->Computer = $result["Computer"];
                        $res->TeamviewerID = $result["TeamviewerID"];
                        $res->VirtualMeetingAlarm = $result["VirtualMeetingAlarm"];
                        $res->ZoomVideoID = $result["ZoomVideoID"];
                        $res->UltraViewerID = $result["UltraViewerID"];
                        $res->TaxSoftwareNames = $result["TaxSoftwareNames"];
                        $res->TaxOfficeName = $result["TaxOfficeName"];
                        $res->TaxOfficeEmail = $result["TaxOfficeEmail"];
                        $res->TaxOfficeContact = $result["TaxOfficeContact"];
                        if ($result["AppointmentDate"]) {                            
                            $res->AppointmentDate = date("Y-m-d H:i:s", strtotime($result["AppointmentDate"]));                            
                            $res->AppointmentDateT = str_replace('UTC', 'T', date("Y-m-dTH:i:s", strtotime($result["AppointmentDate"])));    
                        }
                        else {
                            $res->AppointmentDate = $result["AppointmentDate"];
                            $res->AppointmentDateT = $result["AppointmentDate"];
                        }
                        $res->PurposeOfMeeting = $result["PurposeOfMeeting"];
                        if ($is_admin) {
                            $res->Status = $result["Status"];
                            $res->AdminNotes = $result["AdminNotes"];                            
                            $res->MembershipFeePaid = $result["MembershipFeePaid"];
                            $res->NumberOfTimesReceived = $result["NumberOfTimesReceived"];
                            $res->NumberOfTimesSent = $result["NumberOfTimesSent"];
                        } 
                        if ($is_admin || same_text($cyberid, $_SESSION["cyberid"]) || (same_text($result["TaxOfficeCyberId"], $_SESSION["cyberid"]) && $result["ShowSignatureToOffice"] == "Y")) {
                            $res->SignatureFile = $result["SignatureFile"];
                        }
                        else {
                            $res->SignatureFile = "";
                        }
                        $res->PhotoFile = $result["PhotoFile"];
                        $res->ShowSignatureToOffice = $result["ShowSignatureToOffice"];
                        
                    }
                    else {
                        throw new Exception("There is no virtual office with specified Virtual Id.");
                    }
                }
                else {
                    throw new Exception("Virtual Id Type is undefined");
                }
            } // end load profile
            // list offices
            else if ($action == "LIST_OFFICES") {
                
                if (!$is_admin) {
                    // TODO check if current cyberid can see info for requested cyberid
                    throw new Exception("Action " . $action . " is undefined");
                }
                
                $page_no = isset($_GET["page_no"]) ? intval($_GET['page_no']) : 1;
                if (!isset($_SESSION["records_per_page"])) {
                    $_SESSION["records_per_page"] = intval(ROWS_PER_PAGE);
                }
                $no_of_records_per_page = isset($_GET["records_per_page"]) ? intval($_GET["records_per_page"]) : intval($_SESSION["records_per_page"]);
                $_SESSION["records_per_page"] = $no_of_records_per_page;

                $searchCyberId = isset($_GET["searchCyberId"]) ? $_GET['searchCyberId'] : "";
                $searchBusinessName = isset($_GET["searchBusinessName"]) ? $_GET['searchBusinessName'] : "";
                $searchEmail = isset($_GET["searchEmail"]) ? $_GET['searchEmail'] : "";                
                $searchPostal = isset($_GET["searchPostal"]) ? $_GET['searchPostal'] : "";   
                $searchStatus = isset($_GET["searchStatus"]) ? $_GET['searchStatus'] : "ALL";   
                                
                $searchCyberId = $searchCyberId . "%";
                $searchBusinessName = $searchBusinessName . "%";
                $searchEmail = $searchEmail . "%";
                $searchPostal = $searchPostal . "%";
                
                $where_sql = "";
                if ($searchStatus == "A") {
                    $where_sql = ' AND Status = "A"';
                }
                elseif ($searchStatus == "I") {
                    $where_sql = ' AND Status = "I"';
                }
                elseif ($searchStatus == "E") {
                    $where_sql = ' AND DATEDIFF(ExpireDate, CURRENT_DATE) <= 0';
                }
                
                $query = "SELECT COUNT(*) AS TotalCount 
                          FROM TaxOffices
                          WHERE UPPER(CyberId) LIKE UPPER(:CyberId) 
                            AND UPPER(IFNULL(BusinessName, '')) LIKE UPPER(:BusinessName) 
                            AND UPPER(IFNULL(Email, '')) LIKE UPPER(:Email)
                            AND UPPER(IFNULL(Postal, '')) LIKE UPPER(:Postal) " . $where_sql;
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $searchCyberId);       
                $stmt->bindParam(':BusinessName', $searchBusinessName);       
                $stmt->bindParam(':Email', $searchEmail);
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->execute();
                $result = $stmt->fetch();                 
                $total_rows = $result["TotalCount"];
                $total_pages = ceil($total_rows / $no_of_records_per_page);
                if ($page_no > $total_pages) {
                    $page_no = $total_pages;
                }
                if ($page_no <= 0) {
                    $page_no = 1;
                }
                $offset = ($page_no-1) * $no_of_records_per_page; 
                
                $query = "SELECT * FROM TaxOffices 
                          WHERE UPPER(CyberId) LIKE UPPER(:CyberId) 
                            AND UPPER(IFNULL(BusinessName, '')) LIKE UPPER(:BusinessName) 
                            AND UPPER(IFNULL(Email, '')) LIKE UPPER(:Email)
                            AND UPPER(IFNULL(Postal, '')) LIKE UPPER(:Postal) " . $where_sql . "
                          ORDER BY BusinessName LIMIT ". $offset ." , ". $no_of_records_per_page;
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $searchCyberId);       
                $stmt->bindParam(':BusinessName', $searchBusinessName);       
                $stmt->bindParam(':Email', $searchEmail);
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->execute();
                $result_array = [];
                while ($row = $stmt->fetch(PDO::FETCH_OBJ)) {
                    $result_array[] = $row;
                }                    
                $res->result = $result_array;                  
                $res->page_no = $page_no;
                $res->total_pages = $total_pages;
                $res->no_of_records_per_page = $no_of_records_per_page;
                $res->success = "true";

            } // end list offices
            // list efilers
            else if ($action == "LIST_EFILERS") {
                
                if (!$is_admin) {
                    // TODO check if current cyberid can see info for requested cyberid
                    throw new Exception("Action " . $action . " is undefined");
                }
                
                $page_no = isset($_GET["page_no"]) ? intval($_GET['page_no']) : 1;
                if (!isset($_SESSION["records_per_page"])) {
                    $_SESSION["records_per_page"] = intval(ROWS_PER_PAGE);
                }
                $no_of_records_per_page = isset($_GET["records_per_page"]) ? intval($_GET["records_per_page"]) : intval($_SESSION["records_per_page"]);
                $_SESSION["records_per_page"] = $no_of_records_per_page;
                
                $searchCyberId = isset($_GET["searchCyberId"]) ? $_GET['searchCyberId'] : "";
                $searchBusinessName = isset($_GET["searchBusinessName"]) ? $_GET['searchBusinessName'] : "";
                $searchPostal = isset($_GET["searchPostal"]) ? $_GET['searchPostal'] : "";   
                                
                $searchCyberId = $searchCyberId . "%";
                $searchBusinessName = $searchBusinessName . "%";
                $searchPostal = $searchPostal . "%";
                                
                $query = "SELECT COUNT(*) AS TotalCount 
                          FROM Efilers
                          WHERE UPPER(CyberId) LIKE UPPER(:CyberId)
                            AND UPPER(IFNULL(BusinessName, '')) LIKE UPPER(:BusinessName)
                            AND UPPER(IFNULL(Postal, '')) LIKE UPPER(:Postal)";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $searchCyberId);       
                $stmt->bindParam(':BusinessName', $searchBusinessName);                       
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->execute();
                $result = $stmt->fetch();                 
                $total_rows = $result["TotalCount"];
                $total_pages = ceil($total_rows / $no_of_records_per_page);
                if ($page_no > $total_pages) {
                    $page_no = $total_pages;
                }
                if ($page_no <= 0) {
                    $page_no = 1;
                }
                $offset = ($page_no-1) * $no_of_records_per_page; 
                
                $query = "SELECT * 
                          FROM Efilers 
                          WHERE UPPER(CyberId) LIKE UPPER(:CyberId)
                            AND UPPER(IFNULL(BusinessName, '')) LIKE UPPER(:BusinessName)
                            AND UPPER(IFNULL(Postal, '')) LIKE UPPER(:Postal)
                          ORDER BY BusinessName LIMIT ". $offset ." , ". $no_of_records_per_page;
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $searchCyberId);       
                $stmt->bindParam(':BusinessName', $searchBusinessName);                       
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->execute();
                $result_array = [];
                while ($row = $stmt->fetch(PDO::FETCH_OBJ)) {
                    $result_array[] = $row;
                }                    
                $res->result = $result_array;  
                $res->page_no = $page_no;
                $res->total_pages = $total_pages;
                $res->no_of_records_per_page = $no_of_records_per_page;
                $res->success = "true";

            } // end list efilers
            // list payers
            else if ($action == "LIST_PAYERS") {
                
                if (!$is_admin) {
                    // TODO check if current cyberid can see info for requested cyberid
                    throw new Exception("Action " . $action . " is undefined");
                }
                
                $page_no = isset($_GET["page_no"]) ? intval($_GET['page_no']) : 1;
                if (!isset($_SESSION["records_per_page"])) {
                    $_SESSION["records_per_page"] = intval(ROWS_PER_PAGE);
                }
                $no_of_records_per_page = isset($_GET["records_per_page"]) ? intval($_GET["records_per_page"]) : intval($_SESSION["records_per_page"]);
                $_SESSION["records_per_page"] = $no_of_records_per_page;               
                
                
                $searchCyberId = isset($_GET["searchCyberId"]) ? $_GET['searchCyberId'] : "";
                $searchLastName = isset($_GET["searchLastName"]) ? $_GET['searchLastName'] : "";
                $searchFirstName = isset($_GET["searchFirstName"]) ? $_GET['searchFirstName'] : "";
                $searchEmail = isset($_GET["searchEmail"]) ? $_GET['searchEmail'] : "";                
                $searchPostal = isset($_GET["searchPostal"]) ? $_GET['searchPostal'] : "";   
                $searchStatus = isset($_GET["searchStatus"]) ? $_GET['searchStatus'] : "ALL";   
                                
                $searchCyberId = $searchCyberId . "%";
                $searchLastName = $searchLastName . "%";
                $searchFirstName = $searchFirstName . "%";
                $searchEmail = $searchEmail . "%";
                $searchPostal = $searchPostal . "%";
                
                $where_sql = "";
                if ($searchStatus == "A") {
                    $where_sql = ' AND Status = "A"';
                }
                elseif ($searchStatus == "I") {
                    $where_sql = ' AND Status = "I"';
                }
                                
                $query = "SELECT COUNT(*) AS TotalCount 
                          FROM TaxPayers
                          WHERE UPPER(CyberId) LIKE UPPER(:CyberId) 
                            AND UPPER(IFNULL(LastName, '')) LIKE UPPER(:LastName) 
                            AND UPPER(IFNULL(FirstName, '')) LIKE UPPER(:FirstName) 
                            AND UPPER(IFNULL(Email, '')) LIKE UPPER(:Email)
                            AND UPPER(IFNULL(Postal, '')) LIKE UPPER(:Postal) " . $where_sql;
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $searchCyberId);       
                $stmt->bindParam(':LastName', $searchLastName);
                $stmt->bindParam(':FirstName', $searchFirstName);
                $stmt->bindParam(':Email', $searchEmail);
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->execute();
                $result = $stmt->fetch();                 
                $total_rows = $result["TotalCount"];
                $total_pages = ceil($total_rows / $no_of_records_per_page);
                if ($page_no > $total_pages) {
                    $page_no = $total_pages;
                }
                if ($page_no <= 0) {
                    $page_no = 1;
                }
                $offset = ($page_no-1) * $no_of_records_per_page; 
                
                $query = "SELECT * 
                          FROM TaxPayers 
                          WHERE UPPER(CyberId) LIKE UPPER(:CyberId) 
                            AND UPPER(IFNULL(LastName, '')) LIKE UPPER(:LastName) 
                            AND UPPER(IFNULL(FirstName, '')) LIKE UPPER(:FirstName) 
                            AND UPPER(IFNULL(Email, '')) LIKE UPPER(:Email)
                            AND UPPER(IFNULL(Postal, '')) LIKE UPPER(:Postal) " . $where_sql . "
                          ORDER BY LastName, FirstName LIMIT ". $offset ." , ". $no_of_records_per_page;
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $searchCyberId);       
                $stmt->bindParam(':LastName', $searchLastName);
                $stmt->bindParam(':FirstName', $searchFirstName);
                $stmt->bindParam(':Email', $searchEmail);
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->execute();
                $result_array = [];
                while ($row = $stmt->fetch(PDO::FETCH_OBJ)) {
                    $result_array[] = $row;
                }                    
                $res->result = $result_array;  
                if ($page_no > $total_pages) {
                    $page_no = $total_pages;
                }
                $res->page_no = $page_no;
                $res->total_pages = $total_pages;
                $res->no_of_records_per_page = $no_of_records_per_page;
                $res->success = "true";

            } // end list payers
            // list taxoffices
            else if ($action == "LIST_TAX_OFFICES_FOR_MAP") {
                
                /*if (!$is_admin) {
                    // TODO check if current cyberid can see info for requested cyberid
                    throw new Exception("Action " . $action . " is undefined");
                }*/
                
                $searchCyberId = isset($_GET["searchCyberId"]) ? $_GET['searchCyberId'] : "";
                $searchBusinessName = isset($_GET["searchBusinessName"]) ? $_GET['searchBusinessName'] : "";
                $searchEmail = isset($_GET["searchEmail"]) ? $_GET['searchEmail'] : "";
                $searchPostal = isset($_GET["searchPostal"]) ? $_GET['searchPostal'] : "";   
                                
                $searchCyberId = $searchCyberId . "%";
                $searchBusinessName = $searchBusinessName . "%";
                $searchEmail = $searchEmail . "%";
                $searchPostal = $searchPostal . "%";
                
                $query = "SELECT CyberId, BusinessName, Email, Postal, Latitude, Longitude 
                          FROM TaxOffices 
                          WHERE UPPER(CyberId) LIKE UPPER(:CyberId)
                            AND UPPER(IFNULL(BusinessName, '')) LIKE UPPER(:BusinessName)
                            AND UPPER(IFNULL(Postal, '')) LIKE UPPER(:Postal) 
                            AND UPPER(IFNULL(Email, '')) LIKE UPPER(:Email) 
                            AND IFNULL(Latitude, '') <> ''
                            AND IFNULL(Longitude, '') <> ''";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $searchCyberId);       
                $stmt->bindParam(':BusinessName', $searchBusinessName);  
                $stmt->bindParam(':Email', $searchEmail);                
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->execute();
                $result_array = [];
                while ($row = $stmt->fetch(PDO::FETCH_OBJ)) {
                    $row->Email = "";
                    $result_array[] = $row;
                }                    
                $res->points = $result_array;  
                $res->success = "true";
            } // end list taxoffices for map
            // list efilers
            else if ($action == "LIST_EFILERS_FOR_MAP") {
                
                /*if (!$is_admin) {
                    // TODO check if current cyberid can see info for requested cyberid
                    throw new Exception("Action " . $action . " is undefined");
                }*/
                
                $searchCyberId = isset($_GET["searchCyberId"]) ? $_GET['searchCyberId'] : "";
                $searchBusinessName = isset($_GET["searchBusinessName"]) ? $_GET['searchBusinessName'] : "";
                $searchPostal = isset($_GET["searchPostal"]) ? $_GET['searchPostal'] : "";   
                                
                $searchCyberId = $searchCyberId . "%";
                $searchBusinessName = $searchBusinessName . "%";
                $searchPostal = $searchPostal . "%";
                
                $query = "SELECT CyberId, BusinessName, Postal, Latitude, Longitude 
                          FROM Efilers 
                          WHERE UPPER(CyberId) LIKE UPPER(:CyberId)
                            AND UPPER(IFNULL(BusinessName, '')) LIKE UPPER(:BusinessName)
                            AND UPPER(IFNULL(Postal, '')) LIKE UPPER(:Postal) 
                            AND IFNULL(Latitude, '') <> ''
                            AND IFNULL(Longitude, '') <> ''";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $searchCyberId);       
                $stmt->bindParam(':BusinessName', $searchBusinessName);                       
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->execute();
                $result_array = [];
                while ($row = $stmt->fetch(PDO::FETCH_OBJ)) {
                    $result_array[] = $row;
                }                    
                $res->points = $result_array;  
                $res->success = "true";
            } // end list efilers for map
            // get encrpsw for files encryption
            else if ($action == "GET_FILE_ENCRPSW") {
                
                restore_session();
                
                $cyberid = $_SESSION["cyberid"];
                $taxpayer_cyberid = $_GET["TaxPayerCyberId"];
                $create_new = $_GET["CreateNew"];
                
                // get taxoffice_cyberid for specified tax payer
                $query = "SELECT TaxOfficeCyberId FROM TaxPayers 
                          WHERE UPPER(CyberId) = UPPER(:CyberId)";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $taxpayer_cyberid);      
                $stmt->execute();                
                $result = $stmt->fetch(); 
                if ($result) {
                    $taxoffice_cyberid = $result["TaxOfficeCyberId"];
                }
                else {
                    throw new Exception("There is no virtual client with specified Virtual Id");
                }
                
                // check if user can get password
                if (!same_text($cyberid, $taxoffice_cyberid) && !same_text($cyberid, $taxpayer_cyberid) && !is_admin) {
                    throw new Exception("You cannot get encryption password for specified Virtual Office Id and Virtual Client Id");    
                }
                
                $query = "SELECT Id, EncryptPsw FROM EncrPsw 
                          WHERE UPPER(TaxOfficeCyberId) = UPPER(:TaxOfficeCyberId) AND 
                                UPPER(TaxPayerCyberId) = UPPER(:TaxPayerCyberId) AND
                                FilesWaitingDecryption > 0
                          ORDER BY DateCreated DESC LIMIT 1";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':TaxOfficeCyberId', $taxoffice_cyberid);      
                $stmt->bindParam(':TaxPayerCyberId', $taxpayer_cyberid);
                $stmt->execute();                
                $result = $stmt->fetch(); 
                if ($result) {
                    $res->Id = $result["Id"];
                    $res->EncryptPsw = $result["EncryptPsw"];
                    $res->success = "true";
                }
                else {
                    if (!same_text($create_new, 'true')) {
                        throw new Exception("There is no active password for decryption");
                    }    
                    $encrypt_psw = generate_password();
                    $query = "INSERT INTO EncrPsw (TaxOfficeCyberId, TaxPayerCyberId, EncryptPsw, CreatedBy)
                              VALUES(UPPER(:TaxOfficeCyberId), UPPER(:TaxPayerCyberId), :EncryptPsw, :CreatedBy);";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':TaxOfficeCyberId', $taxoffice_cyberid);      
                    $stmt->bindParam(':TaxPayerCyberId', $taxpayer_cyberid);
                    $stmt->bindParam(':EncryptPsw', $encrypt_psw);
                    $created_by = "VT";
                    if ($cyberid == $taxoffice_cyberid) {
                        $created_by = OFFICE_PREFIX;
                    } 
                    elseif ($cyberid == $taxpayer_cyberid) {
                        $created_by = PAYER_PREFIX;
                    }
                    $stmt->bindParam(':CreatedBy', $created_by);
                    $stmt->execute(); 
                    $query = "SELECT Id, EncryptPsw FROM EncrPsw 
                              WHERE UPPER(TaxOfficeCyberId) = UPPER(:TaxOfficeCyberId) AND 
                                    UPPER(TaxPayerCyberId) = UPPER(:TaxPayerCyberId) 
                              ORDER BY DateCreated DESC LIMIT 1";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':TaxOfficeCyberId', $taxoffice_cyberid);      
                    $stmt->bindParam(':TaxPayerCyberId', $taxpayer_cyberid);
                    $stmt->execute();                
                    $result = $stmt->fetch(); 
                    if ($result) {
                        $res->Id = $result["Id"];
                        $res->EncryptPsw = $result["EncryptPsw"];
                        $res->success = "true";
                    }
                    else {
                        throw new Exception("Created password was not found");                        
                    }
                    
                }
            } // end encrspsw    
            // get taxpayer cyberid by email
            else if ($action == "GET_TAXPAYER_CYBERID_BY_EMAIL") {
                
                restore_session();
                
                $cyberid = $_SESSION["cyberid"];
                $email = $_GET["Email"];
                                
                // get taxpayer_cyberid for specified tax payer
                $query = "SELECT CyberId, TaxOfficeCyberId FROM TaxPayers 
                          WHERE UPPER(Email) = UPPER(:Email)";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':Email', $email);      
                $stmt->execute();                
                $result = $stmt->fetch(); 
                if ($result) {
                    // check if user can get cyberid
                    //if (strtoupper($cyberid) != strtoupper($result["TaxOfficeCyberId"]) && strtoupper($cyberid) != strtoupper($result["CyberId"]) && !$is_admin) {
                    if (!same_text($cyberid, $result["TaxOfficeCyberId"]) && !same_text($cyberid, $result["CyberId"]) && !$is_admin) {
                        throw new Exception("You cannot get CyberId for specified email, Virtual Client with this email should be linked to your Virtual Office");    
                    }
                    $res->CyberId = $result["CyberId"];
                    $res->success = "true";
                }
                else {
                    throw new Exception("There is no Virtual Client with specified email");
                }                
            } // end get taxpayer cyberid by email
            // list form items
            else if ($action == "LIST_FORM_ITEMS") {
                
                restore_session();
                
                $cyberid = isset($_GET["CyberId"]) ? $_GET["CyberId"] : $_SESSION["cyberid"]; 
                $form_id = isset($_GET["FormId"]) ? $_GET["FormId"] : 0;
                
                $res->AllowEdit = $_SESSION["cyberid"] == $cyberid;
                $res->AllowProposal = is_office($_SESSION["cyberid"]);
                
                $query = "SELECT *  
                          FROM TaxPayers
                          WHERE UPPER(CyberId) = UPPER(:CyberId)";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $cyberid);  
                $stmt->execute();
                $result = $stmt->fetch();           
                if (!$result) {
                    throw new Exception("Virtual client with Virtual Id " . $cyberid . " is not found");
                }
                $res->LastName = $result["LastName"];
                $res->FirstName = $result["FirstName"];
                $res->Area = $result["Area"];
                $res->Phone = $result["Phone"];
                $res->Email = $result["Email"];
                
                $formheader_id = 0;
                $query = "SELECT *  
                          FROM TaxFormHeaders
                          WHERE UPPER(TaxPayerCyberId) = UPPER(:CyberId)
                            AND TaxFormId = :FormId";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $cyberid);  
                $stmt->bindParam(':FormId', $form_id);  
                $stmt->execute();
                $result = $stmt->fetch();           
                if ($result) {
                    $formheader_id = $result["Id"];
                    $res->DatePosted = date("Y-m-d", strtotime($result["DatePosted"]));
                    if ($_SESSION["cyberid"] == $cyberid) {
                        $res->Readonly = !same_text($result["Status"], "D");
                    } else {
                        $res->Readonly = true;                        
                    }
                    $res->Status = $result["Status"];
                }
                else {
                    $res->DatePosted = date("Y-m-d");
                    $res->Readonly = !same_text($_SESSION["cyberid"], $cyberid);
                    $res->Status = "D";
                }
                
                $res->need_refresh = false;
                // mark as viewed
                if (is_office($_SESSION["cyberid"]) && $formheader_id != 0) {
                    $query = "SELECT *  
                              FROM TaxFormProposals
                              WHERE TaxFormHeaderId = :TaxFormHeaderId
                                AND UPPER(TaxOfficeCyberId) = UPPER(:TaxOfficeCyberId)";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':TaxFormHeaderId', $formheader_id);  
                    $stmt->bindParam(':TaxOfficeCyberId', $_SESSION["cyberid"]); 
                    $stmt->execute();
                    $result = $stmt->fetch();
                    if (!$result || $result["OfficeStatus"] == "N") {
                        $query = "INSERT INTO TaxFormProposals (TaxFormHeaderId, TaxOfficeCyberId, OfficeStatus) 
                                  VALUES (:TaxFormHeaderId, :TaxOfficeCyberId, 'V')
                                  ON DUPLICATE KEY UPDATE OfficeStatus = 'V';";
                        $stmt = $taxoffices_db->prepare($query);
                        $stmt->bindParam(':TaxFormHeaderId', $formheader_id);  
                        $stmt->bindParam(':TaxOfficeCyberId', $_SESSION["cyberid"]);  
                        $stmt->execute();
                        $res->need_refresh = true;
                    }
                }
                
                // get proposal info
                $query = "SELECT Id, ExpectedTotalCost, ExpectedCompletionDate, OfficeNote 
                          FROM TaxFormProposals
                          WHERE TaxFormHeaderId = :TaxFormHeaderId
                            AND UPPER(TaxOfficeCyberId) = UPPER(:TaxOfficeCyberId)";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':TaxFormHeaderId', $formheader_id);  
                $stmt->bindParam(':TaxOfficeCyberId', $_SESSION["cyberid"]); 
                $stmt->execute();
                $result = $stmt->fetch();           
                if ($result) {
                    $res->ProposalId = $result["Id"];
                    $res->ExpectedTotalCost = $result["ExpectedTotalCost"];
                    $date = $result["ExpectedCompletionDate"];
                    if ($date) { 
                        $date = date("Y-m-d", strtotime($date));
                    }
                    else {
                        $date = date("Y-m-d"); 
                    }
                    $res->ExpectedCompletionDate = $date;
                    $res->OfficeNote = $result["OfficeNote"];
                }
                else {
                    $res->ProposalId = 0;
                    $res->ExpectedTotalCost = 0;
                    $res->ExpectedCompletionDate = date("Y-m-d");   
                    $res->OfficeNote = "";
                }
                                
                $query = "SELECT *  
                          FROM TaxForms
                          WHERE Id = :Id";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':Id', $form_id);  
                $stmt->execute();
                $result = $stmt->fetch();           
                if (!$result) {
                    throw new Exception("Tax Form with Id " . $form_id . " is not found");
                }
                $res->TaxFormName = $result["TaxFormName"];
                
                $query = "SELECT TaxSections.Id AS SectionId, TaxSections.TaxSectionName
                          FROM TaxSections 
                          WHERE TaxFormId = :TaxFormId
                          ORDER BY Id";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':TaxFormId', $form_id);       
                $stmt->execute();
                $sections = [];
                while ($row = $stmt->fetch(PDO::FETCH_OBJ)) {
                    $items = [];
                    $query = "SELECT 
                                    TaxFormValues.TaxItemValue, TaxFormValues.CountValue, TaxFormValues.Note,
                                    TaxItems.Id As ItemId, TaxItems.TaxItemName, TaxItems.TaxItemType, TaxItems.HasCount 
                              FROM TaxItems 
                                LEFT JOIN TaxFormValues On TaxItems.Id = TaxFormValues.TaxFormItemId AND UPPER(TaxFormValues.TaxPayerCyberId) = UPPER(:TaxPayerCyberId)
                              WHERE TaxItems.TaxSectionId = :SectionId
                              ORDER BY TaxItems.Id";
                    $stmt_items = $taxoffices_db->prepare($query);
                    $stmt_items->bindParam(':TaxPayerCyberId', $cyberid);  
                    $stmt_items->bindParam(':SectionId', $row->SectionId);  
                    $stmt_items->execute();
                    while ($row_item = $stmt_items->fetch(PDO::FETCH_OBJ)) {
                        $items[] = $row_item;
                    }
                    $row->items = $items;
                    $sections[] = $row;
                }                    
                $res->CyberId = $cyberid;
                $res->result = $sections;                  
                $res->success = "true";

            } // end list form items
            // list service requests
            else if ($action == "LIST_SERVICE_REQUESTS") {
                
                $cyberid = "";
                if (!$is_admin) {
                    $cyberid = $_SESSION["cyberid"]; 
                    if (!is_office($cyberid)) { 
                        throw new Exception("You cannot view other requests");
                    }
                }
                
                $form_id = isset($_GET["FormId"]) ? $_GET["FormId"] : 0;
                
                $page_no = isset($_GET["page_no"]) ? intval($_GET['page_no']) : 1;
                if (!isset($_SESSION["records_per_page"])) {
                    $_SESSION["records_per_page"] = intval(ROWS_PER_PAGE);
                }
                $no_of_records_per_page = isset($_GET["records_per_page"]) ? intval($_GET["records_per_page"]) : intval($_SESSION["records_per_page"]);
                $_SESSION["records_per_page"] = $no_of_records_per_page;
                
                $searchFirstName = isset($_GET["searchFirstName"]) ? $_GET['searchFirstName'] : "";
                $searchLastName = isset($_GET["searchLastName"]) ? $_GET['searchLastName'] : "";
                $searchPostal = isset($_GET["searchPostal"]) ? $_GET['searchPostal'] : "";   
                $searchStatus = isset($_GET["searchStatus"]) ? $_GET['searchStatus'] : "P";   
                                
                $searchFirstName = $searchFirstName . "%";
                $searchLastName = $searchLastName . "%";
                $searchPostal = $searchPostal . "%";
                                
                $where_sql = "";
                if ($searchStatus == "P") {
                    $where_sql = 
                            "FROM TaxPayers
                                INNER JOIN TaxFormHeaders ON UPPER(TaxFormHeaders.TaxPayerCyberId) = UPPER(TaxPayers.CyberId)
                                LEFT JOIN TaxFormProposals ON TaxFormHeaders.Id = TaxFormProposals.TaxFormHeaderId AND UPPER(TaxFormProposals.TaxOfficeCyberId) = UPPER(:TaxOfficeCyberId)
                              WHERE UPPER(IFNULL(TaxPayers.LastName, '')) LIKE UPPER(:LastName) 
                                AND UPPER(IFNULL(TaxPayers.FirstName, '')) LIKE UPPER(:FirstName) 
                                AND UPPER(IFNULL(TaxPayers.Postal, '')) LIKE UPPER(:Postal)
                                AND TaxFormHeaders.TaxFormId = :FormId
                                AND TaxFormHeaders.Status = 'P'";
                } elseif ($searchStatus == "A" || $searchStatus == "C") {
                    $where_sql = 
                            "FROM TaxPayers
                                INNER JOIN TaxFormHeaders ON UPPER(TaxFormHeaders.TaxPayerCyberId) = UPPER(TaxPayers.CyberId)
                                INNER JOIN TaxFormProposals ON UPPER(TaxFormHeaders.Id) = UPPER(TaxFormProposals.TaxFormHeaderId) 
                              WHERE UPPER(IFNULL(TaxPayers.LastName, '')) LIKE UPPER(:LastName) 
                                AND UPPER(IFNULL(TaxPayers.FirstName, '')) LIKE UPPER(:FirstName) 
                                AND UPPER(IFNULL(TaxPayers.Postal, '')) LIKE UPPER(:Postal)
                                AND TaxFormHeaders.TaxFormId = :FormId
                                AND UPPER(TaxFormProposals.TaxOfficeCyberId) = UPPER(:TaxOfficeCyberId)
                                AND TaxFormHeaders.Status = 'A'
                                AND TaxFormProposals.PayerStatus = 'A'
                                AND TaxFormProposals.OfficeStatus = '" . ($searchStatus == "A" ? "S" : "C") . "'";
                }

                $query = "SELECT COUNT(*) AS TotalCount " . $where_sql;
                
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':LastName', $searchLastName);
                $stmt->bindParam(':FirstName', $searchFirstName);
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->bindParam(':FormId', $form_id);
                $stmt->bindParam(':TaxOfficeCyberId', $cyberid);
                $stmt->execute();
                $result = $stmt->fetch();                 
                $total_rows = $result["TotalCount"];
                $total_pages = ceil($total_rows / $no_of_records_per_page);
                if ($page_no > $total_pages) {
                    $page_no = $total_pages;
                }
                if ($page_no <= 0) {
                    $page_no = 1;
                }
                $offset = ($page_no-1) * $no_of_records_per_page; 
                
                $query = "SELECT 
                            TaxPayers.CyberId,
                            TaxPayers.LastName,
                            TaxPayers.FirstName,
                            TaxPayers.Street,
                            TaxPayers.City,
                            TaxPayers.Province,
                            TaxPayers.Postal,
                            TaxFormHeaders.DatePosted,
                            TaxFormProposals.OfficeStatus,
                            CASE WHEN IFNULL(TaxFormProposals.OfficeStatus, 'N') = 'N' THEN 'New'
                                 WHEN TaxFormProposals.OfficeStatus = 'V' THEN 'Already viewed'
                                 WHEN TaxFormProposals.OfficeStatus = 'S' THEN 'Proposal submited'
                            END AS OfficeStatusDesc "
                        . $where_sql .                          
                         " ORDER BY TaxPayers.LastName, TaxPayers.FirstName LIMIT ". $offset ." , ". $no_of_records_per_page;
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':LastName', $searchLastName);
                $stmt->bindParam(':FirstName', $searchFirstName);
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->bindParam(':FormId', $form_id);   
                $stmt->bindParam(':TaxOfficeCyberId', $cyberid);
             
                $stmt->execute();
                $result_array = [];
                while ($row = $stmt->fetch(PDO::FETCH_OBJ)) {
                    $row->DatePosted = date("Y-m-d", strtotime($row->DatePosted));
                    $result_array[] = $row;
                }                    
                $res->result = $result_array;  
                $res->page_no = $page_no;
                $res->total_pages = $total_pages;
                $res->no_of_records_per_page = $no_of_records_per_page;
                $res->success = "true";

            } // end list service requests
            // show proposals
            else if ($action == "SHOW_PROPOSALS") {
                
                $cyberid = $_SESSION["cyberid"];
                
                $form_id = isset($_GET["FormId"]) ? $_GET["FormId"] : 0;
                
                $page_no = isset($_GET["page_no"]) ? intval($_GET['page_no']) : 1;
                if (!isset($_SESSION["records_per_page"])) {
                    $_SESSION["records_per_page"] = intval(ROWS_PER_PAGE);
                }
                $no_of_records_per_page = isset($_GET["records_per_page"]) ? intval($_GET["records_per_page"]) : intval($_SESSION["records_per_page"]);
                $_SESSION["records_per_page"] = $no_of_records_per_page;
                
                $searchStatus = isset($_GET["searchStatus"]) ? $_GET['searchStatus'] : "N";   
                                
                $where_sql = "";
                if ($searchStatus == "N") {
                    $where_sql = " AND TaxFormProposals.PayerStatus = 'N' ";
                }
                
                $res->Status = "";
                $query = "SELECT Status
                          FROM TaxFormHeaders
                          WHERE UPPER(TaxPayerCyberId) = UPPER(:CyberId)
                            AND TaxFormId = :FormId";
                
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':FormId', $form_id);
                $stmt->bindParam(':CyberId', $cyberid);
                $stmt->execute();
                $result = $stmt->fetch(); 
                if ($result) {
                    $res->Status = $result["Status"];
                }

                $query = "SELECT COUNT(*) AS TotalCount 
                          FROM TaxFormHeaders
                            INNER JOIN TaxFormProposals ON TaxFormHeaders.Id = TaxFormProposals.TaxFormHeaderId
                            INNER JOIN TaxOffices ON UPPER(TaxOffices.CyberId) = UPPER(TaxFormProposals.TaxOfficeCyberId)
                          WHERE UPPER(TaxFormHeaders.TaxPayerCyberId) = UPPER(:CyberId)
                            AND TaxFormHeaders.TaxFormId = :FormId" . $where_sql;
                
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':FormId', $form_id);
                $stmt->bindParam(':CyberId', $cyberid);
                $stmt->execute();
                $result = $stmt->fetch();                 
                $total_rows = $result["TotalCount"];
                $total_pages = ceil($total_rows / $no_of_records_per_page);
                if ($page_no > $total_pages) {
                    $page_no = $total_pages;
                }
                if ($page_no <= 0) {
                    $page_no = 1;
                }
                $offset = ($page_no-1) * $no_of_records_per_page; 
                
                $query = "SELECT 
                            TaxFormProposals.Id,
                            TaxOffices.CyberId,
                            TaxOffices.BusinessName,
                            TaxOffices.Email,
                            TaxOffices.Contact,
                            TaxOffices.Area,
                            TaxOffices.Phone,
                            TaxFormProposals.ExpectedTotalCost,
                            TaxFormProposals.ExpectedCompletionDate,
                            TaxFormProposals.OfficeNote,
                            TaxFormProposals.PayerStatus
                          FROM TaxFormHeaders
                            INNER JOIN TaxFormProposals ON TaxFormHeaders.Id = TaxFormProposals.TaxFormHeaderId
                            INNER JOIN TaxOffices ON UPPER(TaxOffices.CyberId) = UPPER(TaxFormProposals.TaxOfficeCyberId)
                          WHERE UPPER(TaxFormHeaders.TaxPayerCyberId) = UPPER(:CyberId)
                            AND TaxFormHeaders.TaxFormId = :FormId" . $where_sql .                        
                         " ORDER BY CASE WHEN TaxFormProposals.PayerStatus = 'A' THEN 0 ELSE 1 END, TaxFormProposals.DateCreated LIMIT ". $offset ." , ". $no_of_records_per_page;
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':FormId', $form_id);
                $stmt->bindParam(':CyberId', $cyberid);
             
                $stmt->execute();
                $viewed_ids = "";
                $result_array = [];
                while ($row = $stmt->fetch(PDO::FETCH_OBJ)) {
                    $row->ExpectedCompletionDate = date("Y-m-d", strtotime($row->ExpectedCompletionDate));
                    $result_array[] = $row;
                    if ($row->PayerStatus == "N") {
                        if ($viewed_ids != "") {
                            $viewed_ids .= ",";
                        }
                        $viewed_ids .= $row->Id;
                    }
                } 
                
                // mark as viewed 
                $res->need_refresh = false;
                if ($viewed_ids != "") {                    
                    $res->need_refresh = true;
                    $query = "UPDATE TaxFormProposals
                              SET PayerStatus = 'V'
                              WHERE PayerStatus = 'N'   
                                AND TaxFormProposals.Id IN (" . $viewed_ids . ") ";
                    $stmt = $taxoffices_db->prepare($query);                
                    $stmt->execute();
                }
                
                $res->result = $result_array;  
                $res->page_no = $page_no;
                $res->total_pages = $total_pages;
                $res->no_of_records_per_page = $no_of_records_per_page;
                $res->success = "true";

            } // end show proposals
            // check office status
            elseif ($action == "CHECK_OFFICE_STATUS") {
                
                restore_session();
                
                $cyberid = $_GET["CyberId"];
                if (!$is_admin && $_SESSION["cyberid"] == "") {
                    throw new Exception("You need to login first");
                }
                
                $query = "SELECT Status, DATEDIFF(ExpireDate, CURRENT_DATE) AS ExpireDays, Email, BusinessName FROM TaxOffices WHERE UPPER(CyberId) = UPPER(:CyberId)";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $cyberid);                    
                $stmt->execute();
                $result = $stmt->fetch();                     
                        
                // Check if CyberId exists
                if ($result) {                
                    $res->ExpireDays = $result["ExpireDays"];  
                    $res->Status = $result["Status"];
                    $res->Email = $result["Email"];
                    $res->BusinessName = $result["BusinessName"];
                    $res->success = "true";                                        
                } else {
                    // Display an error message if CyberId doesn't exist
                    $res->type = "cyberid";
                    throw new Exception("There is no Virtual Office with specified Virtual Id.");
                }
            } // end check office status
            // encryption allowed
            elseif ($action == "ENCRYPTION_ALLOWED") {
                
                restore_session();
                
                $cyberid = $_SESSION["cyberid"];
                if (!$is_admin && $cyberid == "") {
                    throw new Exception("You need to login first");
                }
                
                if (is_office($cyberid) || $is_admin) {
                    $res->allowed = "true";  
                    $res->success = "true";                                                            
                }
                else {
                    $query = "SELECT MembershipFeePaid FROM TaxPayers WHERE UPPER(CyberId) = UPPER(:CyberId)";
                    $stmt = $taxoffices_db->prepare($query);
                    $stmt->bindParam(':CyberId', $cyberid);                    
                    $stmt->execute();
                    $result = $stmt->fetch();                     
                            
                    // Check if CyberId exists
                    if ($result) {                
                        if (floatval($result["MembershipFeePaid"]) > 0) {
                            $res->allowed = "true";    
                        }
                        else {
                            $res->allowed = "false";    
                        }                        
                        $res->success = "true";                                        
                    } else {
                        throw new Exception("There is no Virtual Client with specified Virtual Id.");
                    }
                }
            } // end encryption allowed
            // list color templates
            elseif ($action == "LIST_COLOR_TEMPLATES") {
                
                restore_session();
                
                $query = "SELECT 
                            *
                          FROM ColorSettings                            
                          WHERE UPPER(TaxOfficeCyberId) = UPPER(:CyberId) OR TaxOfficeCyberId IS NULL
                          ORDER BY 
                            CASE WHEN TaxOfficeCyberId IS NULL THEN 1 ELSE 0 END, 
                            CASE WHEN UPPER(Caption) = UPPER('Default') THEN 0 ELSE 1 END,
                            Caption";
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':CyberId', $_SESSION["cyberid"]);
             
                $stmt->execute();
                $result_array = [];
                while ($row = $stmt->fetch(PDO::FETCH_OBJ)) {
                    $logo_filename = $row->LogoFileName;
                    if (!is_empty($logo_filename) && strtoupper(substr($logo_filename, 0, 4)) != 'HTTP') {
                        $row->LogoFileName = get_base_url() . $logo_filename;
                    }
                    $background_filename = $row->BackgroundFileName;                    
                    if (!is_empty($background_filename) && strtoupper(substr($background_filename, 0, 4)) != 'HTTP') {
                        $row->BackgroundFileName = get_base_url() . $background_filename;
                    }
                    if (!is_empty($row->TaxOfficeCyberId)) {
                        $row->Caption = "< Current settings for " . $row->TaxOfficeCyberId . ' >';
                    }
                    $result_array[] = $row;                    
                } 
                
                $res->result = $result_array;                  
                $res->success = "true";
            } // end list color templates
            // list office clients
            else if ($action == "LIST_OFFICE_CLIENTS") {
                
                $cyberid = "";
                if (!$is_admin) {
                    $cyberid = $_SESSION["cyberid"]; 
                    if (!is_office($cyberid)) { 
                        throw new Exception("You cannot view other requests");
                    }
                }
                
                
                $page_no = isset($_GET["page_no"]) ? intval($_GET['page_no']) : 1;
                if (!isset($_SESSION["records_per_page"])) {
                    $_SESSION["records_per_page"] = intval(ROWS_PER_PAGE);
                }
                $no_of_records_per_page = isset($_GET["records_per_page"]) ? intval($_GET["records_per_page"]) : intval($_SESSION["records_per_page"]);
                $_SESSION["records_per_page"] = $no_of_records_per_page;
                
                $searchFirstName = isset($_GET["searchFirstName"]) ? $_GET['searchFirstName'] : "";
                $searchLastName = isset($_GET["searchLastName"]) ? $_GET['searchLastName'] : "";
                $searchPostal = isset($_GET["searchPostal"]) ? $_GET['searchPostal'] : "";   
                                
                $searchFirstName = $searchFirstName . "%";
                $searchLastName = $searchLastName . "%";
                $searchPostal = $searchPostal . "%";

                $query = "
                    SELECT COUNT(*) AS TotalCount 
                    FROM TaxPayers 
                    WHERE UPPER(TaxOfficeCyberId) = UPPER(:TaxOfficeCyberId)
                      AND UPPER(IFNULL(TaxPayers.LastName, '')) LIKE UPPER(:LastName) 
                      AND UPPER(IFNULL(TaxPayers.FirstName, '')) LIKE UPPER(:FirstName) 
                      AND UPPER(IFNULL(TaxPayers.Postal, '')) LIKE UPPER(:Postal)";
                
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':LastName', $searchLastName);
                $stmt->bindParam(':FirstName', $searchFirstName);
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->bindParam(':TaxOfficeCyberId', $cyberid);
                $stmt->execute();
                $result = $stmt->fetch();                 
                $total_rows = $result["TotalCount"];
                $total_pages = ceil($total_rows / $no_of_records_per_page);
                if ($page_no > $total_pages) {
                    $page_no = $total_pages;
                }
                if ($page_no <= 0) {
                    $page_no = 1;
                }
                $offset = ($page_no-1) * $no_of_records_per_page; 
                
                $query = "
                        SELECT 
                            TaxPayers.CyberId,
                            TaxPayers.LastName,
                            TaxPayers.FirstName,
                            TaxPayers.Street,
                            TaxPayers.City,
                            TaxPayers.Province,
                            TaxPayers.Postal,
                            TaxPayers.AppointmentDate,
                            TaxPayers.PurposeOfMeeting   
                        FROM TaxPayers 
                        WHERE UPPER(TaxOfficeCyberId) = UPPER(:TaxOfficeCyberId)
                          AND UPPER(IFNULL(TaxPayers.LastName, '')) LIKE UPPER(:LastName) 
                          AND UPPER(IFNULL(TaxPayers.FirstName, '')) LIKE UPPER(:FirstName) 
                          AND UPPER(IFNULL(TaxPayers.Postal, '')) LIKE UPPER(:Postal)                       
                        ORDER BY TaxPayers.LastName, TaxPayers.FirstName LIMIT ". $offset ." , ". $no_of_records_per_page;
                $stmt = $taxoffices_db->prepare($query);
                $stmt->bindParam(':LastName', $searchLastName);
                $stmt->bindParam(':FirstName', $searchFirstName);
                $stmt->bindParam(':Postal', $searchPostal);
                $stmt->bindParam(':TaxOfficeCyberId', $cyberid);
             
                $stmt->execute();
                $result_array = [];
                while ($row = $stmt->fetch(PDO::FETCH_OBJ)) {
                    if ($row->AppointmentDate) {                            
                        $row->AppointmentDate = date("Y-m-d H:i:s", strtotime($row->AppointmentDate));                           
                    }
                    $result_array[] = $row;
                }                    
                $res->result = $result_array;  
                $res->page_no = $page_no;
                $res->total_pages = $total_pages;
                $res->no_of_records_per_page = $no_of_records_per_page;
                $res->success = "true";

            } // end list office clients
            else {
                throw new Exception("Action " . $action . " is undefined");    
            }
        }
        else {
            throw new Exception("Method " . $_SERVER["REQUEST_METHOD"] . " is not supported");
        }
    } catch(Exception $e) {
        $res->error_message = $e->getMessage();
        $res->success = "false";
    }
    
    return $res;
}

?>