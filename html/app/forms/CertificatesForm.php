<?php
namespace Vokuro\Forms;
use Phalcon\Forms\Form;
use Phalcon\Forms\Element\Text;
use Phalcon\Validation\Validator\PresenceOf;

class CertificatesForm extends Form
{
  public function initialize($entity = null, $options = null)
  {
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
