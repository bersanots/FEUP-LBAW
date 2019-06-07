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

  /**
   * Comments inside this question
   */
  public function comments() {
    return $this->hasMany('App\CommentQuestion', 'question_id');
  }

  /**
   * The users that follow this question
   */
  public function followed()
  {
    return $this->belongsToMany('App\User', 'follow', 'question_id', 'user_id');
  }

      /**
     *  Let Laravel handle created_at without updated_at
     */
    public static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            $model->creation_date = $model->freshTimestamp();
        });
    }
}
