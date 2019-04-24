@extends('layouts.app')

@section('content')
<form method="POST" action="{{ route('register') }}">
  {{ csrf_field() }}

  <div id="auth" class="container">
    <div id="register-card" class="container">
      <legend id="auth-legend">Register</legend>
      <div id="login-side" class="auth-side">
        <img id="register-img" src="img/cinema1.jpg">
      </div>
      <div id="register-form" class="auth-form">
        <form>
          <fieldset>
            <label for="name">Username</label>
            <input id="name" type="text" name="name" value="{{ old('name') }}" required autofocus>
            @if ($errors->has('name'))
            <span class="error">
              {{ $errors->first('name') }}
            </span>
            @endif

            <label for="email">E-Mail Address</label>
            <input id="email" type="email" name="email" value="{{ old('email') }}" required>
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
          </fieldset>
          <button type="submit">Next</button>
          <a id="alt-auth" class="button" href="{{ route('login') }}">Login</a>
        </form>
      </div>
    </div>
  </div>
  </div>
</form>
@endsection