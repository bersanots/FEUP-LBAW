<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests;
use App\Http\Controllers\Controller;
use Auth;
use App\QuestionVote;

class AjaxController extends Controller
{

   public function getVoteValue(Request $request)
   {
      if (Auth::check()) {
         $question = $request->question_id;
         $user = Auth::user()->user_id;

         //checks if user voted
         $entry = QuestionVote::where('user_id', $user)->where('question_id', $question)->first();
         if ($entry != null) {
            return json_encode($entry->value);
         } else {
            return json_encode(0);
         }
      }
   }

   public function vote(Request $request)
   {
      if (!Auth::check()) return route('login');
      //get data
      $question = $request->question_id;
      $vote = $request->value;
      $user = Auth::user()->user_id;

      //checks if user voted
      $entry = QuestionVote::where('user_id', $user)->where('question_id', $question)->first();
      if ($entry != null) {
         if ($entry->value == $vote) {
            $entry->delete();
            $voteValue = 0;
         } else {
            $entry->value = $vote;
            $voteValue = $vote;
            $entry->save();
         }
      } else {
         $newEntry = new QuestionVote;
         $newEntry->user_id = $user;
         $newEntry->question_id = $question;
         $newEntry->value = $vote;
         $voteValue = $vote;
         $newEntry->save();
      }

      $countUp = QuestionVote::where('question_id', $question)->where('value', 1)->count();
      $countDown = QuestionVote::where('question_id', $question)->where('value', -1)->count();

      $count = $countUp - $countDown;
      return json_encode(array('count' => $count, 'userVote' => $voteValue));
   }
}
