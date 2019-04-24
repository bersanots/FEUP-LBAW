<?php

namespace App\Policies;

use App\User;
use App\Question;

use Illuminate\Auth\Access\HandlesAuthorization;
use Illuminate\Support\Facades\Auth;

class QuestionPolicy
{
    use HandlesAuthorization;

    /*public function show(User $user, Question $question)
    {
      // Only a question owner can see it
      return $user->id == $question->user_id;
    }

    public function list(User $user)
    {
      // Any user can list its own questions
      return Auth::check();
    }

    public function create(User $user)
    {
      // Any user can create a new question
      return Auth::check();
    }

    public function delete(User $user, Question $question)
    {
      // Only a question owner can delete it
      return $user->id == $question->user_id;
    }*/
}
