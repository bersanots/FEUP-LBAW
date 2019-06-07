<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Question;
use App\User;

class ProfileController extends Controller
{
  
  public function viewProfile($username)
  {
    $user = User::where('username', $username) -> first();
    return view('pages.profile', ['user' => $user]);
  }

  public function viewEditProfile($username)
  {
    $user = User::where('username', $username) -> first();
    return view('pages.editProfile', ['user' => $user]);
  }

  public function editAccountDetails(Request $request)
  {
    //TODo check email and confirm password
    $user = Auth::user();
    $user->password = bcrypt($request->password);
    $user->save();
    return redirect()->route('profile', ['user' => $user->username]);
    // verifyUser();
  }

  public function editPersonalDetails(Request $request)
  {
    
    //TODO check same user
    //TODO validator request data
    $user = Auth::user();
    $user->description = $request->description;
    //TODO profile image
    $user->save();
    return redirect()->route('profile', ['user' => $user->username]);
  }

public function viewModeration($username)
{
  $user = User::where('username', $username) -> first();
  return view('pages.moderation',  ['user' => $user]);
}


  public function verifyUser($user_id)
  {
    if (Auth::user()->id != $user_id) {
      return view('pages.faq');
    }
  }
}
