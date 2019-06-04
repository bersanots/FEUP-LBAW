<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class CommentAnswer extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;

  protected $primaryKey = 'ca_id';

  protected $table = 'comment_answer';

  /**
   * The user this comment belongs to
   */
  public function user() {
    return $this->belongsTo('App\User', 'author', 'user_id');
  }

  /**
   * The answer this comment belongs to.
   */
  public function answer() {
    return $this->belongsTo('App\Answer', 'answer_id', 'answer_id');
  }
}
