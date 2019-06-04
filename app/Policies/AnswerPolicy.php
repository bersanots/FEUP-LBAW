<?php

namespace App\Policies;

use App\User;
use App\Question;
use App\Answer;

use Illuminate\Auth\Access\HandlesAuthorization;

class AnswerPolicy
{
    use HandlesAuthorization;

    public function create(User $user, Answer $answer)
    {
      // User can only create answers in questions they own
      return $user->id == $answer->question->user_id;
    }

    public function update(User $user, Answer $answer)
    {
      // User can only update answers in questions they own
      return $user->id == $answer->question->user_id;
    }

    public function delete(User $user, Answer $answer)
    {
      // User can only delete answers in questions they own
      return $user->id == $answer->question->user_id;
    }
}
