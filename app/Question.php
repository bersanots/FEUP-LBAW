<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Question extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;

  protected $primaryKey = 'question_id';

  protected $table = 'question';

  /**
   * The user this question belongs to
   */
  public function user() {
    return $this->belongsTo('App\User', 'author', 'user_id');
  }

  /**
   * Answers inside this question
   */
  public function answers() {
    return $this->hasMany('App\Answer', 'question_id');
  }
}
