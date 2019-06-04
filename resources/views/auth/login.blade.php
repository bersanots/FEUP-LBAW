@extends('layouts.app')

@section('content')
<form method="POST" action="{{ route('login') }}">
    {{ csrf_field() }}

    <div id="auth" class="container">
        <div id="login-card" class="container">
            <legend id="auth-legend">Login</legend>
            <div id="login-side" class="auth-side">
                <img id="img-login" src=" {{ asset('img/camera.jpg') }}">
            </div>
            <div id="login-form" class="auth-form">
                <form>
                    <fieldset>
                        <label for="email">E-mail</label>
                        <input id="email" type="email" name="email" value="{{ old('email') }}" required autofocus>
                        @if ($errors->has('email'))
                        <span class="error">
                            {{ $errors->first('email') }}
                        </span>
                        @endif

                        <label for="password">Password</label>
                        <input id="password" type="password" name="password" required>
                    </fieldset>
                    <button type="submit">Login</button>
                    <a id="alt-auth" class="button" href="{{ route('register') }}">Register</a>
                </form>
            </div>
        </div>
    </div>
</form>
@endsection