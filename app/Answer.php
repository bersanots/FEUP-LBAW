<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Answer extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;

  /**
   * The question this answer belongs to.
   */
  public function question() {
    return $this->belongsTo('App\Question');
  }
}
