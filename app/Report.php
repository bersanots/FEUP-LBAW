<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Report extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;

  protected $primaryKey = 'report_id';

  protected $table = 'report';

  /**
   * The user that made this report
   */
  public function author() {
    return $this->belongsTo('App\User', 'author', 'user_id');
  }

  /**
   * The user that this report targets
   */
  public function target() {
    return $this->belongsTo('App\User', 'target', 'user_id');
  }
}
