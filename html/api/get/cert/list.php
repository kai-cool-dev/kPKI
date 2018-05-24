<?php
// Bootstrap
require_once($_SERVER["DOCUMENT_ROOT"]."/bootstrap.php");
$app->debug("API START");
// Gibt die Zertifikat-Informationen zur übermittelten Serien-Nummer
$result["code"]=204;
$result["message"]="success";
$result["data"]=array();

// 1. Hole Zertifikate aus Datenbank
$certdata=$app->ca_get_list();
if($certdata==false)
{
  $result["code"]=500;
  $result["message"]="No Database connection";
  exit(json_encode($result));
}
$result["code"]=200;
$result["data"]=$certdata;
echo json_encode($result);

// Debug Output, Message wird unterdrückt
unset($result["data"]);
$app->debug($result);
?>
