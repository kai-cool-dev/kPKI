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
      $numberPage = $this->request->getQuery("page", "int");
      $certs = Certificates::find([
        "public = :public: OR userid = :userid:",
        "bind" => [
          "public" => "1",
          "userid" => $identity["id"],
        ],
      ]);
      if (count($certs) == 0) {
          $this->flash->notice("The search did not find any users");
      }

      $paginator = new Paginator([
          "data" => $certs,
          "limit" => 10,
          "page" => $numberPage
      ]);
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
