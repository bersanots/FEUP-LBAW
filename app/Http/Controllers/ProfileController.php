<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Question;
use App\User;

class ProfileController extends Controller
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
   * 
   */

  public function viewProfile($username)
  {
    $user = User::where('username', $username) -> first();
    return view('pages.profile', ['username' => $user]);
  }

  public function viewEditProfile($username)
  {
    $user = User::where('username', $username) -> first();
    return view('pages.editProfile', ['user' => $user]);
  }

  public function editAccountDetails($user_id)
  {
    $user = User::find($user_id);
    // verifyUser();
  }
  public function editPersonalDetails($user_id)
  {
    $user = User::find($user_id);
    //TODO check same user
  }

  public function verifyUser($user_id)
  {
    if (Auth::user()->id != $user_id) {
      return view('pages.faq');
    }
  }
}