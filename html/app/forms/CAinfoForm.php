<?php
namespace Vokuro\Forms;
use Phalcon\Forms\Form;
use Phalcon\Forms\Element\Select;

class CAinfoForm extends Form
{
  public function initialize($entity = null, $options = null)
  {
    $profiles=new Select('profile', [
      "default",
      "ocsp",
      "intermediate",
      "server",
      "client"
    ], [
      'class' => 'form-control'
    ]);
    $this->add($profiles);
  }
}
