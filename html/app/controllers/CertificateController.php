<?php
namespace Vokuro\Controllers;
use Phalcon\Paginator\Adapter\Model as Paginator;
use Vokuro\Models\Certificates;


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
      $identity = $this->auth->getIdentity();

      $certs = Certificates::find("public = '1' OR userid = '".$identity["id"]."'");
      if (count($users) == 0) {
          $this->flash->notice("The search did not find any users");
      }

      $paginator = new Paginator([
          "data" => $certs,
          "limit" => 10,
          "page" => $numberPage
      ]);
      var_dump($certs);
      $this->view->page = $paginator->getPaginate();
    }

    // Create new SSL Certificate
    public function createAction()
    {

    }

    // Search for a Certificate
    public function searchAction()
    {

    }

    // Show detailled information
    public function showAction()
    {

    }

    // Revoke Certificate
    public function revokeAction()
    {

    }
}
