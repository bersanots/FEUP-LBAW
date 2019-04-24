@extends('layouts.app')

@section('title', $question->title)

@section('content')
  @include('partials.question', ['question' => $question])
@endsection
