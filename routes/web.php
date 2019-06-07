<?php
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

use Illuminate\Http\Request;
use App\Mail\ContactMail;
use Illuminate\Support\Facades\Mail;

Route::get('/', function () {
    return redirect('home');
});

//Homepage
Route::view('home', 'pages/home');

//Static pages
Route::view('faq', 'pages/faq');
Route::view('about', 'pages/about');
Route::view('contact', 'pages/contact');
Route::post('/contact', function (Request $request) {
    Mail::send(new ContactMail($request));
    return redirect('/');
});

// Questions
Route::get('questions/category/{name}/ask', 'QuestionController@ask');
Route::post('createQuestion', 'QuestionController@createQuestion')->name('createQuestion');
Route::get('questions', 'QuestionController@list');
Route::get('questions/{id}', 'QuestionController@show');
Route::get('questions/category/{category_name}/{followed?}', 'QuestionController@listCategoryQuestions');
Route::post('questions/search', 'QuestionController@listQuestionsBySearch')->name('search');

//Answers
Route::post('createAnswer/{question_id}', 'AnswerController@create')->name('createAnswer');
Route::delete('answer/{id}', 'AnswerController@delete')->name('deleteAnswer');

//Comments in Questions
Route::post('createCommentQuestion/{question_id}', 'CommentQuestionController@create')->name('createCommentQuestion');
Route::delete('commentQuestion/{id}', 'CommentQuestionController@delete')->name('deleteCommentQuestion');

//Comments in Answers
Route::post('createCommentAnswer/{answer_id}', 'CommentAnswerController@create')->name('createCommentAnswer');
Route::delete('commentAnswer/{id}', 'CommentAnswerController@delete')->name('deleteCommentAnswer');

// API
/*Route::put('api/questions', 'QuestionController@create');
Route::delete('api/questions/{question_id}', 'QuestionController@delete');
Route::put('api/questions/{question_id}/', 'AnswerController@create');
Route::post('api/answer/{id}', 'AnswerController@update');
Route::delete('api/answer/{id}', 'AnswerController@delete');*/

// Authentication
Route::get('login', 'Auth\LoginController@showLoginForm')->name('login');
Route::post('login', 'Auth\LoginController@login');
Route::get('logout', 'Auth\LoginController@logout')->name('logout');
Route::get('register', 'Auth\RegisterController@showRegistrationForm')->name('register');
Route::post('register', 'Auth\RegisterController@register');

//Profile
Route::get('users/{username}', 'ProfileController@viewProfile')->name('profile');
Route::get('users/{username}/edit', 'ProfileController@viewEditProfile');
Route::patch('users/{username}/edit/personal', 'ProfileController@editPersonalDetails')->name('editPersonal');
Route::patch('users/{username}/edit/account', 'ProfileController@editAccountDetails')->name('editAccount');

//AJAX
Route::post('questions/vote/question', 'AjaxController@questionVote');
Route::post('questions/getVoteValue', 'AjaxController@getVoteValue');
Route::post('questions/favourite', 'AjaxController@favourite');
Route::post('questions/vote/answer', 'AjaxController@answerVote');

//test
Route::view('test', 'pages/test');
