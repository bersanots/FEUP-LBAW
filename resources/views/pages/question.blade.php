@extends('layouts.app')

@section('title', $question->name)

@section('content')
  @include('partials.question', ['question' => $question])
@endsection
