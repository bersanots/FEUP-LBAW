@extends('layouts.app')

@section('title', 'Questions')

@section('content')

<section id="questions">
  <div id="questions-list" class="container">
    <div class="bs-docs-section">
      <div class="container ">
        <div class="question_content">
          <div class="question">
            <h2>
              Can't find the answer you're looking for?&nbsp; &nbsp;
              <a class="button" href="{{ url()->current()}}/ask">Ask a Question</a>
            </h2>
          </div>
          <div class="question-body">
          </div>
        </div>
      </div>
      <div class="container">
        <div class="question_content">
          <div class="question-body">
          </div>
        </div>
      </div>
      @each('partials.previewQuestion', $questions, 'question')
    </div>
  </div>
</section>

@endsection
