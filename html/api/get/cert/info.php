<?php
// Bootstrap
require_once($_SERVER["DOCUMENT_ROOT"]."/bootstrap.php");
$app->debug("API START");
// Gibt die Zertifikat-Informationen zur übermittelten Serien-Nummer
$result["code"]=200;
$result["message"]="success";
$result["data"]=array();

if(empty($_REQUEST['serial']))
{
  $result["code"]=400;
  $result["message"]="Serial is empty";
  exit(json_encode($result));
}
// 1. Hole Zertifikat aus Datenbank
$certdata=$app->ca_get_cert($_REQUEST['serial']);
if($certdata==false || empty($certdata))
{
  $result["code"]=500;
  $result["message"]="No such certificate or serial not valid";
  exit(json_encode($result));
}
// 2. Sende PEM an API für die Certdaten
$data["certificate"]=$certdata[0][7];
$result=json_decode($app->http_post("api/v1/cfssl/certinfo",$data),TRUE);
if($result["success"]==false)
{
  $result["code"]=400;
  $result["message"]="Daemon Access Failed";
  $result["data"]=$result["errors"];
  exit(json_encode($result));
}
echo json_encode($result);

// Debug Output, Message wird unterdrückt
unset($result["data"]);
$app->debug($result);
?>
