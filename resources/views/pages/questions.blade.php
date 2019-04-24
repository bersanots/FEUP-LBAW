@extends('layouts.app')

@section('title', 'Questions')

@section('content')

<section id="questions">
  @each('partials.question', $questions, 'question')
  <article class="question">
    <form class="new_question">
      <input type="text" name="title" placeholder="Title of the question">
    </form>
  </article>
</section>

@endsection
