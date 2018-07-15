<?php
namespace Vokuro\Controllers;
use Vokuro\Forms\CertinfoForm;

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
    }

    public function hostinfoAction()
    {

    }
}
