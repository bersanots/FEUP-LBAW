@extends('layouts.app')

@section('title', $question->title)

@section('description', $question->description)

@section('content')
  @include('partials.question', ['question' => $question])
@endsection
