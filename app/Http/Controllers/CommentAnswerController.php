<?php

namespace App\Http\Controllers;

use App\CommentAnswer;

use Illuminate\Http\Request;

class CommentAnswerController extends Controller
{
  /**
   * Creates a new comment in an answer.
   *
   * @param  int  $answer_id
   * @param  Request request containing the description
   * @return Response
   */
  public function create(Request $request, $answer_id)
  {
    $comment_a = new CommentAnswer();
    $comment_a->answer_id = $answer_id;

    $this->authorize('create', $comment_a);

    $comment_a->description = $request->input('description');
    $comment_a->author = Auth::user()->id;
    $comment_a->save();

    return $comment_a;
  }

    /**
     * Updates the state of an individual comment.
     *
     * @param  int  $id
     * @param  Request request containing the new state
     * @return Response
     */
    public function update(Request $request, $id)
    {
      $comment_a = CommentAnswer::find($id);

      $this->authorize('update', $comment_a);

      $comment_a->save();

      return $comment_a;
    }

    /**
     * Deletes an individual comment.
     *
     * @param  int  $id
     * @return Response
     */
    public function delete(Request $request, $id)
    {
      $comment_a = CommentAnswer::find($id);

      $this->authorize('delete', $comment_a);
      $comment_a->delete();

      return $comment_a;
    }

}
