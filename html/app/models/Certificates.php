<?php
namespace Vokuro\Models;
use Phalcon\Mvc\Model;

/**
 * Certificates
 */
class Certificates extends Model
{
  public $serial_number;
  public $authority_key_identifier;
  public $ca_label;
  public $status;
  public $reason;
  public $expiry;
  public $revoked_at;
  public $pem;
}
