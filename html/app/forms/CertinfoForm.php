<?php
namespace Vokuro\Forms;
use Phalcon\Forms\Form;
use Phalcon\Forms\Element\Text;
class CertinfoForm extends Form
{
  public function initialize($entity = null, $options = null)
  {
    $name = new Text('host', [
      'placeholder' => 'www.server.pep',
      'class' => 'form-control'
    ]);
    $name->addValidators([
      new PresenceOf([
        'message' => 'The host is required'
      ])
    ]);
    $this->add($name);
  }
}
