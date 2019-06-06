<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests;
use App\Http\Controllers\Controller;
use Auth;
use App\QuestionVote;
use App\QuestionFavourite;
use App\AnswerVote;

class AjaxController extends Controller
{

   public function getVoteValue(Request $request)
   {
      if (Auth::check()) {
         $question = $request->question_id;
         $user = Auth::user()->user_id;

         //checks if user voted
         $entry = QuestionVote::where('user_id', $user)->where('question_id', $question)->first();
         $favEntry = QuestionFavourite::where('user_id', $user)->where('question_id', $question)->first();


         if ($entry != null) {
            $vote = $entry->value;
         } else {
            $vote = 0;
         }

         if ($favEntry != null)
            $favourite = true;
         else
            $favourite = false;

         return json_encode(array('vote' => $vote, 'favourite' => $favourite));
      }
   }

   public function questionVote(Request $request)
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

   public function favourite(Request $request)
   {
      if (!Auth::check()) return route('login');
      $question = $request->question_id;
      $user = Auth::user()->user_id;

      //check if user favourited
      $entry = QuestionFavourite::where('user_id', $user)->where('question_id', $question)->first();
      if ($entry != null) {
         $entry->delete();
         $favouriteValue = false;
      } else {
         $newEntry = new QuestionFavourite;
         $newEntry->user_id = $user;
         $newEntry->question_id = $question;
         $favouriteValue = true;
         $newEntry->save();
      }
      return json_encode($favouriteValue);
   }

   public function answerVote(Request $request)
   {
      if (!Auth::check()) return route('login');

      $answer = $request->answer_id;
      $vote = $request->value;
      $user = Auth::user()->user_id;

      $entry = AnswerVote::where('user_id', $user)->where('answer_id', $answer)->first();
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
         $newEntry = new AnswerVote;
         $newEntry->user_id = $user;
         $newEntry->answer_id = $answer;
         $newEntry->value = $vote;
         $voteValue = $vote;
         $newEntry->save();
      }
      $countUp = AnswerVote::where('answer_id', $answer)->where('value', 1)->count();
      $countDown = AnswerVote::where('answer_id', $answer)->where('value', -1)->count();

      $count = $countUp - $countDown;
      return json_encode(array('count' => $count, 'userVote' => $voteValue));
   }
}
