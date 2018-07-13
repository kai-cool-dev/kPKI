<?php
namespace Vokuro\Controllers;

/**
 * Display the default index page.
 */
class ToolsController extends ControllerBase
{

    /**
     * Default action. Set the public layout (layouts/public.volt)
     */
    public function initialize()
    {
        $this->view->setTemplateBefore('public');
    }

    public function certinfoAction()
    {

    }
}
