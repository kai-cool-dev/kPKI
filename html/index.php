<?php
// Bootstrap
require_once($_SERVER["DOCUMENT_ROOT"]."/bootstrap.php");
echo $app->generate_header();
echo $app->generate_menue();
echo $app->generate_body();
echo $app->generate_footer();
?>
