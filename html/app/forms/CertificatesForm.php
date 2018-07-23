<?php
namespace Vokuro\Forms;
use Phalcon\Forms\Form;
use Phalcon\Forms\Element\Text;
use Phalcon\Forms\Element\Select;
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

    $this->add($serial_number);
    $ca_label = new Text('ca_label', [
      'placeholder' => '',
      'aria-describedby' => 'name-addon',
      'class' => 'form-control'
    ]);
    $this->add($ca_label);

    $status=new Select('status', [
      "" => "view all",
      "revoked" => "view revoked",
      "good" => "view not revoked"
    ], [
      'class' => 'form-control'
    ]);
    $this->add($status);
  }
}
