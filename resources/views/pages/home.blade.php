@extends('layouts.app')

@section('title', 'LCQ')

@section('content')
<div id="logo" class="img-container">
    <img src="img/LCQ.jpg" alt="Welcome to LCQ">
</div>
<div class="collapse navbar-collapse" id="navbarColor02">
</div>
<div class="container-homepage">
    <div class="bs-docs-section">
        <div class="row">
            <div class="col-lg-4">
                <div class="bs-ccomponent">
                    <div class="card mb-3 text-light bg-primary border-primary zoom">
                        <a href="questions/category/series">
                            <h3 class="card-header">Series</h3>
                            <img src="img/Series.jpeg" alt="Card image">
                        </a>
                        <ul class="list-group list-group-flush">
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="bs-ccomponent">
                    <div class="card mb-3 text-light bg-primary border-primary zoom">
                        <a href="questions/category/film">
                            <h3 class="card-header">Films</h3>
                            <img src="img/Films.jpeg" alt="Card image">
                        </a>
                        <ul class="list-group list-group-flush">
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="bs-ccomponent">
                    <div class="card mb-3 text-light bg-primary border-primary zoom">
                        <a href="questions/category/animation">
                            <h3 class="card-header">Animations</h3>
                            <img src="img/Animation.jpg" alt="Card image">
                            <ul class="list-group list-group-flush">
                            </ul>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer id="footer">
        <div class="row">
        </div>
    </footer>
</div>
@endsection