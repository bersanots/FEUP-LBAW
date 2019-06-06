<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;

class QuestionFavourite extends Model
{
    public $timestamps = false;

    protected $table = 'follow';

    public $incrementing = false;

    /**
     * Necessary for composite primmary key 
     */
    protected function setKeysForSaveQuery(Builder $query)
    {
        $query
            ->where('user_id', '=', $this->getAttribute('user_id'))
            ->where('question_id', '=', $this->getAttribute('question_id'));

        return $query;
    }
}
