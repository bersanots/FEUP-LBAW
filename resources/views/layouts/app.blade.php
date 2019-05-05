<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- CSRF Token -->
  <meta name="csrf-token" content="{{ csrf_token() }}">

  <title>{{ config('app.name', 'Laravel') }}</title>

  <!-- Styles -->
  <link href="{{ asset('css/milligram.min.css') }}" rel="stylesheet">
  <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
  <link href="{{ asset('css/app.css') }}" rel="stylesheet">
  <script type="text/javascript">
    // Fix for Firefox autofocus CSS bug
    // See: http://stackoverflow.com/questions/18943276/html-5-autofocus-messes-up-css-loading/18945951#18945951
  </script>
  <script type="text/javascript" src={{ asset('js/app.js') }} defer>
  </script>
</head>

<body>
  <main>
    <header>
      <nav id="header-bar" class="navbar navbar-expand-lg navbar-dark">
        <a class="navbar-brand" href="{{ url('/') }}">LCQ</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarColor01" aria-controls="navbarColor01" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarColor01">
          <button id="filterBy" type="button" class="btn btn-default dropdown-toggle text-dark" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="margin-left: 100px; color: #ffffff;">
            <span id="search_concept">Filter by</span>
            <span class="caret"></span>
          </button>
          <input id="search-input" class="form-control mr-sm-3 " type="text" placeholder="Search" style="width: 448px;">
          <button id="search-button" class="btn my-2 my-sm-0 text-light" type="submit" style="margin-left: -15px; background: #000000;">Search</button>
        </div>
        @if (Auth::check())
        <?php echo '<a href="users/' . Auth::user()->username . '">{{ ' . Auth::user()->username . ' }}</a>' ?>
        <a id="logout-header" class="button" href="{{ url('/logout') }}"> Logout </a>
        @else
        <a id="register-header" class="button" href="{{ url('/register') }}"> Register </a>
        <a id="login-header" class="button" href="{{ url('/login') }}"> Login </a>
        @endif
      </nav>
    </header>
    <section id="content">
      @yield('content')
    </section>
  </main>
  <footer id="footer">
    <div class="col-lg-12" style="border-top-color: #A22C29; border-top-style: solid; border-top-width: 0.1em; margin-top: 1em;">
      <table class="list-unstyled" cellpadding="7">
        <tr>
          <td class="float-lg-right">
            <a href="#top" class="font-weight-bold text-light">Back to top</a>
          </td>
          <td>
            <a href="{{ url('faq') }}" class="font-weight-bold text-light">FAQ</a>
          </td>
          <td>
            <a href="{{ url('about') }}" class="font-weight-bold text-light">About</a>
          </td>
          <td>
            <a href="{{ url('#') }}" class="font-weight-bold text-light">Contact</a>
          </td>
        </tr>
      </table>
    </div>
  </footer>
</body>

</html>