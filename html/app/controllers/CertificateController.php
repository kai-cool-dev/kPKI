<?php
namespace Vokuro\Controllers;
use Phalcon\Paginator\Adapter\Model as Paginator;
use Vokuro\Forms\CertificatesForm;
use Vokuro\Models\Certificates;
use Phalcon\Mvc\Model\Criteria;
use Phalcon\Tag;


/**
 * Handles the GUI for certificates
 */
class CertificateController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateBefore('private');
    }

    // List all Certificates
    public function indexAction()
    {
      $this->persistent->conditions = null;
      $this->view->form = new CertificatesForm();
    }

    // Create new SSL Certificate
    public function createAction()
    {

    }

    // Search for a Certificate
    public function searchAction()
    {
      $numberPage = 1;
      if ($this->request->isPost()) {
        $query = Criteria::fromInput($this->di, 'Vokuro\Models\Certificates', $this->request->getPost());
        $this->persistent->searchParams = $query->getParams();
      } else {
        $numberPage = $this->request->getQuery("page", "int");
      }
      $parameters = [];
      if ($this->persistent->searchParams) {
        $parameters = $this->persistent->searchParams;
      }
      $certs = Certificates::find($parameters);
      if (count($certs) == 0) {
        $this->flash->notice("The search did not find any certificates");
        return $this->dispatcher->forward([
          "action" => "index"
        ]);
      }
      $data = array();
      foreach ($certs as $key => $value) {
        $certinfo=$this->certinfo($value->pem);
        $data[$value->serial_number]["sans"]=$certinfo["sans"];
        $data[$value->serial_number]["subject"]=$certinfo["subject"]["names"];
      }
      $paginator = new Paginator([
        "data" => $certs,
        "limit" => 10,
        "page" => $numberPage
      ]);
      $this->view->page = $paginator->getPaginate();
      $this->view->data = $data;
    }

    public function certinfo($pem)
    {
      $data = array('certificate' => $pem );
      $data_string=json_encode($data);
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
      $data = json_decode($resp,true);
      return $data["result"];
    }

    // Show detailled information
    public function showAction($serial_number)
    {
      $certs = Certificates::findFirst([
        "serial_number = :serial_number:",
        "bind" => [
          "serial_number" => $serial_number
        ]
      ]);
      if (!$certs) {
        $this->flash->error("Certificate was not found");
        return $this->dispatcher->forward([
          'action' => 'index'
        ]);
      }
      $this->view->cert = $certs;
      $this->view->form = new CertificatesForm($certs, [
        'edit' => true
      ]);
    }

    // Revoke Certificate
    public function revokeAction()
    {

    }
}
