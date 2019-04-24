<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Question;

class QuestionController extends Controller
{
    /**
     * Shows the question for a given id.
     *
     * @param  int  $id
     * @return Response
     */
    public function show($id)
    {
      $question = Question::find($id);

      $this->authorize('show', $question);

      return view('pages.question', ['question' => $question]);
    }

    /**
     * Shows all questions.
     *
     * @return Response
     */
    public function list()
    {
      if (!Auth::check()) return redirect('/login');

      $this->authorize('list', Question::class);

      $questions = Auth::user()->questions()->orderBy('id')->get();

      return view('pages.questions', ['questions' => $questions]);
    }

    /**
     * Creates a new question.
     *
     * @return Question The question created.
     */
    public function create(Request $request)
    {
      $question = new Question();

      $this->authorize('create', $question);

      $question->name = $request->input('name');
      $question->user_id = Auth::user()->id;
      $question->save();

      return $question;
    }

    public function delete(Request $request, $id)
    {
      $question = Question::find($id);

      $this->authorize('delete', $question);
      $question->delete();

      return $question;
    }
}
