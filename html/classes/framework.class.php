<?php
/**
 * Framework Class for ADACOR CA Webfrontend
 */
class APP
{

  private $configuration;
  private $mysqli;
  private $lang;

  // Getter / Setter
  public function getConfiguration() {
    return $this->configuration;
  }

  function __construct()
  {
    $this->debug("Initialize a new instance");
    if(file_exists($_SERVER["DOCUMENT_ROOT"]."/config/main.json"))
    {
      $this->configuration=json_decode(file_get_contents($_SERVER["DOCUMENT_ROOT"]."/config/main.json"),TRUE);
    }
    else
    {
      exit("No configuration file found!");
    }
    // Öffne MySQL Session
    $this->mysqli=$this->mysql_connect();
    //Lade Sprachpaket
    if(file_exists($_SERVER["DOCUMENT_ROOT"]."/assets/lang/".strtolower($this->configuration["language"]).".json"))
    {
      $this->lang=json_decode(file_get_contents($_SERVER["DOCUMENT_ROOT"]."/assets/lang/".strtolower($this->configuration["language"]).".json"),TRUE);
      $this->debug($this->lang);
    }
  }

  public function debug($data)
  {
    $output["REMOTE_ADDR"]=$_SERVER["REMOTE_ADDR"];
    $output["SERVER_PROTOCOL"]=$_SERVER["SERVER_PROTOCOL"];
    $output["DATA"]=$data;
    if($this->configuration["debug"]==true)
    {
      file_put_contents($_SERVER["DOCUMENT_ROOT"]."/log/debug.log",json_encode($output)."\n",FILE_APPEND);
    }
  }

  //
  // HTML Funktionen
  //
  private function generate_replace_envar($html)
  {
    $search = array();
    $replace = array();
    $search[] = '/COMPANY.NAME/';
    $replace[] = $this->configuration["company"]["name"];
    $search[] = '/APP.THEME/';
    $replace[] = $this->configuration["theme"];
    $search[] = '/APP.LANGUAGE/';
    $replace[] = strtolower($this->configuration["language"]);
    $search[] = '/DOMAIN.NAME/';
    $replace[] = $_SERVER["REQUEST_SCHEME"]."://".$_SERVER["HTTP_HOST"];
    $search[] = '/COPYRIGHT.TEXT/';
    $replace[] = $this->lang["copyright"]["text"];
    $search[] = '/COPYRIGHT.YEAR/';
    if(date("Y")==$this->configuration["year"])
    {
      $replace[] = $this->configuration["year"];
    }
    else
    {
      $replace[] = $this->configuration["year"]." - ".date("Y");
    }
    return preg_replace($search, $replace, $html);
  }

  public function generate_header()
  {
    $html=file_get_contents($_SERVER["DOCUMENT_ROOT"]."/views/header.view.html");
    return $this->generate_replace_envar($html);
  }

  public function generate_menue()
  {
    $html=file_get_contents($_SERVER["DOCUMENT_ROOT"]."/views/menue.view.html");
    return $this->generate_replace_envar($html);
  }

  public function generate_body()
  {
    $html="";
    return $this->generate_replace_envar($html);
  }

  public function generate_footer()
  {
    $html=file_get_contents($_SERVER["DOCUMENT_ROOT"]."/views/footer.view.html");
    return $this->generate_replace_envar($html);
  }


  //
  // CA Funktionen
  //

  public function ca_get_info()
  {
    $this->debug("ca_get_info");
    return $this->http_post("api/v1/cfssl/info",NULL);
  }

  public function ca_get_list()
  {
    $this->debug("ca_get_list");
    // str_replace ?? durch args
    $SQL="SELECT `serial_number`, `authority_key_identifier`, `ca_label`, `status`, `reason`, `expiry`, `revoked_at`, `pem` FROM `cfssl`.`certificates`";
    return $this->mysql_get($SQL);
  }

  public function ca_get_cert($serial)
  {
    $this->debug("ca_get_cert");
    // Öffne MySQL Session
    if(!$this->mysqli=$this->mysql_connect())
    {
      return false;
    }
    $serial=$this->mysqli->real_escape_string($serial);
    // str_replace ?? durch args
    $SQL="SELECT `serial_number`, `authority_key_identifier`, `ca_label`, `status`, `reason`, `expiry`, `revoked_at`, `pem` FROM `cfssl`.`certificates` WHERE  `serial_number`= ?;";
    $SQL=str_replace("?",$serial,$SQL);
    return $this->mysql_get($SQL);
  }

  //
  // CURL Funktionen
  //

  public function http_post($endpoint, $data)
  {
    $this->debug("http_post");
    $this->debug($endpoint);
    $curl = curl_init($this->configuration["backend"]["url"]."/".$endpoint);
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($data));
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($curl);
    curl_close($curl);
    return $response;
  }

  public function http_get($endpoint){
    $this->debug("http_get");
    $this->debug($endpoint);
    $curl = curl_init($this->configuration["backend"]["url"]."/".$endpoint);
    curl_setopt($curl, CURLOPT_GET, true);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($curl);
    curl_close($curl);
    return $response;
  }

  //
  // MYSQL Funktionen
  //

  public function mysql_get($SQL)
  {
    $this->debug("mysql_get");
    // SQL Laufen lassen
    $data=array();
    if($result = $this->mysqli->query($SQL))
    {
      while($row=$result->fetch_row())
      {
        $data[]=$row;
      }
    }
    else {
      $this->debug($result);
      return false;
    }
    // MySQL Session schließen
    $result->close();
    $this->mysqli->close();
    // return output
    return $data;
  }

  public function mysql_set($SQL)
  {

  }

  private function mysql_connect()
  {
    $mysqli = new mysqli($this->configuration["database"]["host"], $this->configuration["database"]["user"], $this->configuration["database"]["passwort"], $this->configuration["database"]["database"]);
    if ($mysqli->connect_error)
    {
      $this->debug($mysqli->connect_error);
      return false;
    }
    return $mysqli;
  }
}

?>
