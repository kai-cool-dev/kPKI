<?php
namespace Vokuro\Forms;
use Phalcon\Forms\Form;
use Phalcon\Forms\Element\Text;

class CertificatesForm extends Form
{
  public function initialize($entity = null, $options = null)
  {
    $name = new Text('serial_number', [
      'placeholder' => 'John Doe',
      'aria-describedby' => 'name-addon',
      'class' => 'form-control'
    ]);
    $name->addValidators([
      new PresenceOf([
        'message' => 'The name is required'
      ])
    ]);
    $this->add($name);
  }
}
