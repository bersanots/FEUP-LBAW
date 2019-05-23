<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class CommentQuestion extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;

  protected $primaryKey = 'cq_id';

  protected $table = 'comment_question';

  /**
   * The user this comment belongs to
   */
  public function user() {
    return $this->belongsTo('App\User', 'author', 'user_id');
  }

  /**
   * The question this comment belongs to.
   */
  public function question() {
    return $this->belongsTo('App\Question', 'question_id', 'question_id');
  }
}
