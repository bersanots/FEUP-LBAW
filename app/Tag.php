<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Tag extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;

  protected $primaryKey = 'tag_id';

  protected $table = 'tag';

  /**
   * The questions marked with this tag
   */
  public function questions()
  {
    return $this->belongsToMany('App\Question', 'tag_question', 'tag_id', 'question_id');
  }

}
