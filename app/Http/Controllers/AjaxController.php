<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests;
use App\Http\Controllers\Controller;

class AjaxController extends Controller
{
   public function vote(Request $request)
   {
      
      //dd($request->all());
      if (!Auth::check()) return route('login');
      //get data
      $post = $request->postID;
      $vote = $request->value;
      $user = Auth::user()->id;

      //checks if user voted
      $entry = Vote::where('user_id', $user)->where('question_id', $post)->first();
      if ($entry->count()) {
         $entry->vote = $vote;
      } else {
         $entry = new Vote;
         $entry->user_id = $user;
         $entry->post_id = $post;
      }
      $entry->save();
      return "This";
   }
}  
