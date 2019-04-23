@extends('layouts.app')

@section('content')
<form method="POST" action="{{ route('login') }}">
    {{ csrf_field() }}

    <div id="login-card" class="container">
        <legend style="padding: 10px; text-align: center; font-weight: bold; font-variant: normal;" id="auth-legend">Login</legend>
        <div id="login-side" class="container">
            <img id="login-img" src="img/camera.jpg">
        </div>
        <form id="login-form" class="auth-form">
            <label for="email">E-mail</label>
            <input id="email" type="email" name="email" value="{{ old('email') }}" required autofocus>
            @if ($errors->has('email'))
            <span class="error">
                {{ $errors->first('email') }}
            </span>
            @endif

            <label for="password">Password</label>
            <input id="password" type="password" name="password" required>
            @if ($errors->has('password'))
            <span class="error">
                {{ $errors->first('password') }}
            </span>
            @endif
            <button type="submit">
                Login
            </button>
            <a class="button button-outline" href="{{ route('register') }}">Register</a>
        </form>


    </div>
</form>
@endsection