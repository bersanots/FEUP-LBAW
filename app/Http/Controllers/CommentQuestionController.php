<?php

namespace App\Http\Controllers;

use App\CommentQuestion;

use Illuminate\Http\Request;

class CommentQuestionController extends Controller
{
  /**
   * Creates a new comment in a question.
   *
   * @param  int  $question_id
   * @param  Request request containing the description
   * @return Response
   */
  public function create(Request $request, $question_id)
  {
    $comment_q = new CommentQuestion();
    $comment_q->question_id = $question_id;

    $this->authorize('create', $comment_q);

    $comment_q->description = $request->input('description');
    $comment_q->save();

    return $comment_q;
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
      $comment_q = CommentQuestion::find($id);

      $this->authorize('update', $comment_q);

      $comment_q->save();

      return $comment_q;
    }

    /**
     * Deletes an individual comment.
     *
     * @param  int  $id
     * @return Response
     */
    public function delete(Request $request, $id)
    {
      $comment_q = CommentQuestion::find($id);

      $this->authorize('delete', $comment_q);
      $comment_q->delete();

      return $comment_q;
    }

}
