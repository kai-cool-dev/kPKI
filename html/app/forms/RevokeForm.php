<?php
namespace Vokuro\Forms;
use Phalcon\Forms\Form;
use Phalcon\Forms\Element\Hidden;
use Phalcon\Forms\Element\Text;
use Phalcon\Forms\Element\Select;
use Phalcon\Validation\Validator\PresenceOf;

class RevokeForm extends Form
{
  public function initialize($entity = null)
  {
    $serial_number = new Hidden('serial_number');
    $serial_number->addValidators([
      new PresenceOf([
        'message' => 'The serial_number is required'
      ])
    ]);
    $this->add($serial_number);

    $authority_key_id = new Hidden('authority_key_identifier');
    $authority_key_id->addValidators([
      new PresenceOf([
        'message' => 'The serial_number is required'
      ])
    ]);
    $this->add($authority_key_id);

    $reason=new Select('reason', [
      "unspecified",
      "keyCompromise",
      "cACompromise",
      "affiliationChanged",
      "superseded",
      "cessationOfOperation",
      "certificateHold",
      "removeFromCRL",
      "privilegeWithdrawn",
      "aACompromise"
    ], [
      'class' => 'form-control'
    ]);
    $this->add($reason);
  }
}
