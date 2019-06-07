@extends('layouts.app')

@section('title', 'LCQ')

@section('content')
<div id="logo" class="img-container" style="position: relative;">
    <img src="img/LCQ.jpg" alt="Welcome to LCQ" style="width: 100%; height: auto;">
</div>
<div class="collapse navbar-collapse" id="navbarColor02">
</div>
<div class="container" style="padding-top: 57px;">
    <div class="bs-docs-section">
        <div class="row">
            <div class="col-lg-4">
                <div class="bs-ccomponent">
                    <div class="card mb-3 text-light bg-primary border-primary zoom" style="transition: transform 500ms;">
                        <a href="questions/category/series">
                            <h3 class="card-header" style="background-color: #A22C29; color: white;">Series</h3>
                            <img style="width: 100%; height: 200px; object-fit: cover; border: solid #a22c29;" src="img/Series.jpeg" alt="Card image">
                        </a>
                        <ul class="list-group list-group-flush">
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="bs-ccomponent">
                    <div class="card mb-3 text-light bg-primary border-primary zoom" style="transition: transform 500ms;">
                        <a href="questions/category/film">
                            <h3 class="card-header" style="background-color: #A22C29; color: white;">Films</h3>
                            <img style="width: 100%; height: 200px; object-fit: cover; border: solid #a22c29;" src="img/Films.jpeg" alt="Card image">
                        </a>
                        <ul class="list-group list-group-flush">
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="bs-ccomponent">
                    <div class="card mb-3 text-light bg-primary border-primary zoom" style="transition: transform 500ms;">
                        <a href="questions/category/animation">
                            <h3 class="card-header" style="background-color: #A22C29; color: white;">Animations</h3>
                            <img style="width: 100%; height: 200px; object-fit: cover; border: solid #a22c29;" src="img/Animation.jpg" alt="Card image">
                            <ul class="list-group list-group-flush">
                            </ul>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer id="footer" style="margin: 5em 0;">
        <div class="row">
        </div>
    </footer>
</div>
@endsection