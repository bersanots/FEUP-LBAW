<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Answer extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;

  /**
   * The user this question belongs to
   */
  public function user() {
    return $this->belongsTo('App\User');
  }

  /**
   * The question this answer belongs to.
   */
  public function question() {
    return $this->belongsTo('App\Question');
  }
}
