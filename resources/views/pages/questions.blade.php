@extends('layouts.app')

@section('title', 'Questions')

@section('content')

<section id="questions">
  @each('partials.question', $questions, 'question')
  <article class="question">
    <form class="new_question">
      <input type="text" name="name" placeholder="new question">
    </form>
  </article>
</section>

@endsection
