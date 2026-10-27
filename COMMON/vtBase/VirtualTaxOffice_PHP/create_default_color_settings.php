<?php

require_once "apicontroller.php";

header($_SERVER["SERVER_PROTOCOL"] . " 200 OK");
header("Content-Type: application/json; charset=UTF-8");

init_default_color_settings();

$_SERVER["REQUEST_METHOD"] = "POST";
$_POST["action"] = "SAVE_COLOR_SETTINGS";
$_POST["IsTemplate"] = "true";
$_POST["Caption"] = "Default";
$_POST["TitleSmallColor"] = TITLE_SMALL_COLOR;
$_POST["TitleColor"] = TITLE_COLOR;
$_POST["BackgroundColor"] = BACKGROUND_COLOR;
$_POST["LeftPanelColor"] = LEFT_PANEL_COLOR;
$_POST["RightPanelColor"] = RIGHT_PANEL_COLOR;
$_POST["ProjectorColor"] = PROJECTOR_COLOR;
$_POST["FloorColor"] = FLOOR_COLOR;
$_POST["GroutColor"] = GROUT_COLOR;
$_POST["LogoFileName"] = LOGO_FILENAME;
$_POST["LogoMessage"] = LOGO_MESSAGE;
$_POST["CompanyName"] = COMPANY_NAME;
$_POST["LogoMessageColor"] = LOGO_MESSAGE_COLOR;
$_POST["CompanyNameColor"] = COMPANY_NAME_COLOR;
$_POST["BackgroundFileName"] = BACKGROUND_FILENAME;
$_POST["BackgroundRepeat"] = BACKGROUND_REPEAT == "no-repeat" ? "N" : "Y";
$_POST["BorderColor"] = BORDER_COLOR;
$_POST["BorderWidth"] = BORDER_WIDTH;

echo json_encode(processApiRequest());

?>