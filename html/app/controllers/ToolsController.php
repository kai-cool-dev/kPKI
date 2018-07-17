<?php
namespace Vokuro\Controllers;
use Vokuro\Forms\CertinfoForm;
use Vokuro\Forms\HostinfoForm;

/**
 * Display the default index page.
 */
class ToolsController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateBefore('public');
    }

    public function certinfoAction()
    {
      $this->view->form = new CertinfoForm();
      if ($this->request->isPost()) {
        $request=$this->request->getPost();
        $data=$this->docertinfo($request);
        if($data["success"]==false || empty($data))
        {
          $this->flash->error("Could not recieve SSL Certificate");
          return false;
        }
        $this->view->names=$data["result"]["sans"];
        $this->view->subject=$data["result"]["subject"];
        $this->view->issuer=$data["result"]["issuer"];
        $this->view->serial_number=$data["result"]["serial_number"];
        $this->view->not_before=$data["result"]["not_before"];
        $this->view->not_after=$data["result"]["not_after"];
        $this->view->sigalg=$data["result"]["sigalg"];
        $this->view->authority_key_id=$data["result"]["authority_key_id"];
        $this->view->pem=$data["result"]["pem"];
      }
    }

    private function docertinfo($domain)
    {
      $data_string=json_encode($domain);
      // Get cURL resource
      $curl = curl_init();
      // Set some options - we are passing in a useragent too here
      curl_setopt_array($curl, array(
        CURLOPT_RETURNTRANSFER => 1,
        CURLOPT_URL => $this->config["cfssl"]["remotes"]["caserver"] . '/api/v1/cfssl/certinfo',
        CURLOPT_USERAGENT => 'kPKI Frontend GUI',
        CURLOPT_HTTPHEADER => array(
          'Content-Type: application/json',
          'Content-Length: ' . strlen($data_string)),
        CURLOPT_POST => 1,
        CURLOPT_POSTFIELDS => $data_string
      ));
      // Send the request & save response to $resp
      $resp = curl_exec($curl);
      // Close request to clear up some resources
      curl_close($curl);
      return json_decode($resp,true);
    }

    public function hostinfoAction()
    {
      $this->view->form = new HostinfoForm();
      if ($this->request->isPost()) {
        $request=$this->request->getPost();
        $data=$this->dohostinfo($request);
        if($data["success"]==false || empty($data))
        {
          $this->flash->error("Could not connect");
          return false;
        }
        $this->view->connectivity=$data["result"]["Connectivity"];
        $this->view->tlssession=$data["result"]["TLSSession"]["SessionResume"];
        $this->view->ciphersuite=$data["result"]["TLSHandshake"]["CipherSuite"];
      }
    }

    public function dohostinfo($host)
    {
      // Get cURL resource
      $curl = curl_init();
      // Set some options - we are passing in a useragent too here
      curl_setopt_array($curl, array(
        CURLOPT_RETURNTRANSFER => 1,
        CURLOPT_URL => $this->config["cfssl"]["remotes"]["caserver"] . '/api/v1/cfssl/scan?host='.$host["domain"],
        CURLOPT_USERAGENT => 'kPKI Frontend GUI',
        CURLOPT_HTTPHEADER => array(
          'Content-Type: application/json',
          'Content-Length: ' . strlen($data_string)),
        CURLOPT_POST => 0
      ));
      // Send the request & save response to $resp
      $resp = curl_exec($curl);
      // Close request to clear up some resources
      curl_close($curl);
      return json_decode($resp,true);
    }
}
