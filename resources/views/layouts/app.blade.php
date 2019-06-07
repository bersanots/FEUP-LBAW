<!DOCTYPE html>

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
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
  <link href="{{ asset('css/app.css') }}" rel="stylesheet">
  <script type="text/javascript">
    // Fix for Firefox autofocus CSS bug
    // See: http://stackoverflow.com/questions/18943276/html-5-autofocus-messes-up-css-loading/18945951#18945951
  </script>
  <script type="text/javascript" src="{{ asset('js/app.js') }}" defer></script>
</head>

<body>
  <main>
    <header>
      <nav id="header-bar" class="navbar navbar-expand-lg navbar-dark">
        <a class="navbar-brand" id="app-name" href="{{ url('/') }}">LCQ</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarColor01" aria-controls="navbarColor01" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="searchArea">
          <form action="{{route('search')}}" method="POST">
            {{csrf_field()}}
            <div class="dropdown">
              <button id="filterBy" type="button" class="btn btn-default dropdown-toggle text-dark" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="margin-left: 100px; color: #ffffff;">
                <span id="search_concept">Filter by</span>
                <span class="caret"></span>
              </button>
              <div class="dropdown-content">
                @php
                $dir = explode("/",\Request::url());
                $curr = end($dir);
                $before = prev($dir);
                @endphp
                @if ($curr != 'followed')
                @if ($curr != 'series' && $curr != 'film' && $curr != 'animation')
                <a href="/questions/category/all/followed">Followed</a>
                @else
                <a href="{{\Request::url()}}/followed">Followed</a>
                @endif
                @else
                @if ($before != 'series' && $before != 'film' && $before != 'animation')
                <a href="/questions/category/all">Followed</a>
                @else
                <a href=<?= substr(\Request::url(), 0, -9) ?>>Followed</a>
                @endif
                @endif
                <a href="#">Filter 2</a>
                <a href="#">Filter 3</a>
              </div>
            </div>
            <input id="search-input" class="form-control mr-sm-3 " type="text" name="text" placeholder="Search" style="width: 448px;">
            <button id="search-button" class="btn my-2 my-sm-0 text-light" type="submit" style="margin-left: -15px; background: #000000;"><i class="fa fa-search"></i></button>
          </form>
        </div>
        @if (Auth::check())
        <?php echo '<a id="username-header" href="/users/' . Auth::user()->username . '">' ?> {{ Auth::user()->username }}</a>
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
  <footer id="footer" style="align-content: center;">
    <div class="col-lg-12" style="border-top-color: #A22C29; border-top-style: solid; border-top-width: 0.1em; margin-top: 1em;">
      <a href="#top" class="font-weight-bold text-light">Back to top</a>
      <a href="{{ url('faq') }}" class="font-weight-bold text-light">FAQ</a>
      <a href="{{ url('about') }}" class="font-weight-bold text-light">About</a>
      <a href="{{ url('contact') }}" class="font-weight-bold text-light">Contact</a>
    </div>
  </footer>
</body>

</html>