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
