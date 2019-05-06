<?php

namespace App\Http\Controllers;

use App\Answer;
use App\Question;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class AnswerController extends Controller
{
  /**
   * Creates a new answer.
   *
   * @param  int  $question_id
   * @param  Request request containing the description
   * @return Response
   */
  public function create(Request $request, $question_id)
  {
    $answer = new Answer();
    $answer->question_id = $question_id;

    $this->authorize('create', $answer);

    $answer->description = $request->input('description');
    $answer->save();

    return $answer;
  }

    /**
     * Updates the state of an individual answer.
     *
     * @param  int  $id
     * @param  Request request containing the new state
     * @return Response
     */
    public function update(Request $request, $id)
    {
      $answer = Answer::find($id);

      $this->authorize('update', $answer);

      $answer->save();

      return $answer;
    }

    /**
     * Deletes an individual answer.
     *
     * @param  int  $id
     * @return Response
     */
    public function delete(Request $request, $id)
    {
      $answer = Answer::find($id);

      $this->authorize('delete', $answer);
      $answer->delete();

      return $answer;
    }

}
