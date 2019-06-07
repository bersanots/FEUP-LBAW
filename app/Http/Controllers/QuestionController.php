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

      $questions = Question::orderBy('creation_date', 'DESC')->get();

      return view('pages.questions', ['questions' => $questions]);
    }

    /**
     * Shows all questions by logged user.
     *
     * @return Response
     */
    public function listUserQuestions()
    {
      if (!Auth::check()) return redirect('/login');

      $this->authorize('list', Question::class);

      $questions = Auth::user()->questions()->orderBy('creation_date', 'DESC')->get();

      return view('pages.questions', ['questions' => $questions]);
    }

    /**
     * Shows all questions from a category.
     *
     * @return Response
     */
    public function listCategoryQuestions($category, $followed = null)
    {
      if (!Auth::check()) return redirect('/login');

      $this->authorize('list', Question::class);

      if($followed) {
        if($category == "all")
          $questions = Auth::user()->followed()->orderBy('creation_date', 'DESC')->get();
        else
          $questions = Auth::user()->followed()->where('category', $category)->orderBy('creation_date', 'DESC')->get();
      } else {
        if($category == "all")
          $questions = Question::orderBy('creation_date', 'DESC')->get();
        else
          $questions = Question::where('category', $category)->orderBy('creation_date', 'DESC')->get();
      }

      return view('pages.questions', ['questions' => $questions]);
    }

    /**
     * Shows all questions that match the search.
     *
     * @return Response
     */
    public function listQuestionsBySearch(Request $request)
    {
      if (!Auth::check()) return redirect('/login');

      $this->authorize('list', Question::class);

      if(!$request->text)
        return QuestionController::list();

      $questions = DB::select("SELECT DISTINCT question.question_id, question.title, question.description, question.creation_date, question.score, 
      username AS question_author, ts_rank_cd((setweight(to_tsvector('english', question.title || ' ' || question.description), 'A') || 
      setweight(to_tsvector('english', answer.description), 'B')), plainto_tsquery(:search)) AS rank FROM question, users, answer 
      WHERE question.author = users.user_id AND question.question_id = answer.question_id 
      AND plainto_tsquery(:search) @@ (setweight(to_tsvector('english', question.title || ' ' || question.description), 'A') || 
      setweight(to_tsvector('english', answer.description), 'B')) ORDER BY rank DESC;", ['search' => $request->input('text')]);

      return view('pages.questions', ['questions' => $questions]);
    }

    /**
     * Show create a question page
     */

    public function ask()
    {
      if(!Auth::check()) return redirect('login');

      return view('pages.createQuestion');
    }

    /**
     * Creates a new question.
     *
     * @return Question The question created.
     */
    public function createQuestion(Request $request)
    {

      $question = new Question;

      $this->authorize('create', $question);

      $question->title = $request->input('title');
      $question->description = $request->input('description');
      $question->author = Auth::user()->user_id;
      $question->category = $request->category;
      $question->save();

      $redirect = "questions/".$question->question_id;

      return redirect($redirect);
    }

    public function delete(Request $request, $id)
    {
      $question = Question::find($id);

      $this->authorize('delete', $question);
      $question->delete();

      return $question;
    }
}
