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
      $paginator = new Paginator([
        "data" => $certs,
        "limit" => 10,
        "page" => $numberPage
      ]);
      $this->view->page = $paginator->getPaginate();
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
