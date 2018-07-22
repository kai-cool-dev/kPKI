<?php
namespace Vokuro\Forms;
use Phalcon\Forms\Form;
use Phalcon\Forms\Element\Text;
use Phalcon\Validation\Validator\PresenceOf;

class CertificatesForm extends Form
{
  public function initialize($entity = null, $options = null)
  {
    $serial_number = new Text('serial_number', [
      'placeholder' => '',
      'aria-describedby' => 'name-addon',
      'class' => 'form-control'
    ]);

    $serial_number->addValidators([
      new PresenceOf([
        'message' => 'The ca_label is required'
      ])
    ]);

    $this->add($serial_number);

    if($options["edit"]==true)
    {
      $ca_label = new Text('ca_label', [
        'placeholder' => '',
        'aria-describedby' => 'name-addon',
        'class' => 'form-control',
        'disabled' => true
      ]);
    }else {
      $ca_label = new Text('ca_label', [
        'placeholder' => '',
        'aria-describedby' => 'name-addon',
        'class' => 'form-control'
      ]);
    }
    $ca_label->addValidators([
      new PresenceOf([
        'message' => 'The ca_label is required'
      ])
    ]);
    $this->add($ca_label);
  }
}
