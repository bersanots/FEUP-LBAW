<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Answer extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;

  protected $primaryKey = 'answer_id';

  protected $table = 'answer';

  /**
   * The user this answer belongs to
   */
  public function user() {
    return $this->belongsTo('App\User', 'author', 'user_id');
  }

  /**
   * The question this answer belongs to.
   */
  public function question() {
    return $this->belongsTo('App\Question', 'question_id', 'question_id');
  }

  /**
   * Comments inside this answer
   */
  public function comments() {
    return $this->hasMany('App\CommentAnswer', 'answer_id');
  }
}
