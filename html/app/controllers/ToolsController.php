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
      if ($this->request->isPost()) {
        echo "POST";
      } else {
        echo "GET";
      }
    }

    public function hostinfoAction()
    {

    }
}
