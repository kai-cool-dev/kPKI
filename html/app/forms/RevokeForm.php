<?php
namespace Vokuro\Forms;
use Phalcon\Forms\Form;
use Phalcon\Forms\Element\Text;
use Phalcon\Validation\Validator\PresenceOf;

class RevokeForm extends Form
{
  public function initialize($entity = null, $sn)
  {
    $serial_number = new Text('serial_number', [
      'value' => $sn,
      'aria-describedby' => 'name-addon',
      'class' => 'form-control',
    ]);
    $serial_number->addValidators([
      new PresenceOf([
        'message' => 'The serial_number is required'
      ])
    ]);
    $this->add($serial_number);
  }
}
