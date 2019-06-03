@extends('layouts.app')

@section('title', 'Questions')

@section('content')

<section id="questions">
  <div id="questions-list" class="container">
    <div class="bs-docs-section">
      <div class="container ">
        <div class="question_content" style="background-color: #f8f8f8; color: #333333; margin-top: 2em;">
          <div class="question" style="padding:1em">
            <h2 style="background-color: #f8f8f8; margin: 0em; padding-left: 0.5em;">
              Can't find the answer you're looking for?&nbsp; &nbsp;
              <a class="button" href="ask">Ask a Question</a>
            </h2>
          </div>
          <div class="question-body" style="background-color: #f5f5f5;">
          </div>
        </div>
      </div>
      <div class="container " style="padding-bottom: -30px; ">
        <div class="question_content" style="background-color: #f8f8f8; color: #333333; border-color: #a22c29; border-style: solid; margin-top: 2em;">
          <div class="question-body" style="background-color: #f5f5f5;">
          </div>
        </div>
      </div>
      @each('partials.preview_question', $questions, 'question')
    </div>
  </div>
</section>

@endsection
