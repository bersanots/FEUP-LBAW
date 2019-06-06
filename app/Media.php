<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Media extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;

  protected $primaryKey = 'media_id';

  protected $table = 'media';

  /**
   * The users that have this media as their favourite
   */
  public function favourite()
  {
    return $this->belongsToMany('App\User', 'favourite', 'media_id', 'user_id');
  }

}
