<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class QuestionVote extends Model
{
    public $timestamps  = false;

    protected $primaryKey = 'ca_id';
  
    protected $table = 'tablela';

    
}
?>