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
    $user = User::where('username', $username)->first();
    return view('pages.profile', ['user' => $user]);
  }

  public function viewEditProfile($username)
  {
    $user = User::where('username', $username)->first();
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

  public function editPersonalDetails(Request $request, $user_id)
  {
    $user = Auth::user();

    if ($user->user_id != $user_id)
      abort(404);

      dd($request->hasfile('image'));
    if ($request->hasfile('image')) {
      $file = $request->file('business_logo');
      $extension = $file->getClientOriginalExtension(); // getting image extension
      $filename = time() . '.' . $extension;
      $file->move('uploads/logos/', $filename);
    }

    $user->description = $request->description;
    $user->picture = "pictures/" . $request->image;
    $user->save();
    return redirect()->route('profile', ['user' => $user->username]);
  }

  public function viewModeration($username)
  {
    $user = User::where('username', $username)->first();
    return view('pages.moderation',  ['user' => $user]);
  }


  public function verifyUser($user_id)
  {
    if (Auth::user()->id != $user_id) {
      return view('pages.faq');
    }
  }
}
