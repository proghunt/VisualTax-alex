<?php

require_once "apicontroller.php";

header($_SERVER["SERVER_PROTOCOL"] . " 200 OK");
header("Content-Type: application/json; charset=UTF-8");

//send_activation_message('vitalik.ventik@gmail.com', 'test', 'test', '123456', 'code');

echo json_encode(processApiRequest());

?>