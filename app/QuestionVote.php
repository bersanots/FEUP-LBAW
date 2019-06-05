<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;

class QuestionVote extends Model
{
    public $timestamps = false;

    protected $table = 'vote_q';

    public $incrementing = false;

    /**
     *  Let Laravel handle created_at without updated_at
     */
    public static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            $model->date = $model->freshTimestamp();
        });
    }

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
