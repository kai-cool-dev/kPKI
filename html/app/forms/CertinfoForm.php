<?php
namespace Vokuro\Forms;
use Phalcon\Forms\Form;
use Phalcon\Forms\Element\Text;
use Phalcon\Validation\Validator\PresenceOf;

class CertinfoForm extends Form
{
  public function initialize($entity = null, $options = null)
  {
    $host = new Text('domain', [
      'placeholder' => 'pki.server.pep',
      'class' => 'form-control'
    ]);
    $host->addValidators([
      new PresenceOf([
        'message' => 'The domain is required'
      ])
    ]);
    $this->add($host);
  }
}
