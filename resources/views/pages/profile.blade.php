@extends('layouts.app')

@section('title', 'LCQ')

@section('content')

<div class="container">
    <legend class="text-light" style="padding: 10px; border-bottom: solid 0.2em #a22c29; margin-top: 1em;">
        <img style="padding-right: 20px;" src="icon/profile.png">&nbsp;
        <b class="text-light">{{ Auth::user()->username }}</b>'s' profile
    </legend>
    <div class="bs-docs-section">
        <div class="row">
            <div class="col-lg-4" style="padding-top: 23px;">
                <div class="bs-ccomponent">
                    <img src="{{ Auth::user()->picture }}" style="width: 100%; height: 200px; object-fit: cover; border: solid 0.2em #a22c29;" class="border border-primary">
                    <div id="myTabContent" class="tab-content">
                        <div class="tab-pane fade active show" id="about">
                            <div style="padding: 20px; padding-top: 10px; border: solid 0.2em #a22c29;" class="text-light border border-primary">
                                <fieldset>
                                    <div class="form-group">
                                        <label class="col-form-label" for="inputDefault">
                                            <b>Email address</b>
                                        </label>
                                        <p><a href=".">{{ Auth::user()->email }}</a></p>
                                    </div>
                                    <div class="form-group">
                                        <b>Description</b>
                                        <p>{{ Auth::user()->description }}</p>
                                    </div>
                                    <a class="button" href="{{Auth::user()->username}}/edit">Edit Profile</a>
                                    <a class="button" href="">Moderator</a>
                                    <a class="button"  href="">Admin</a>
                                </fieldset>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4" style="padding-top: 23px;">
                <div class="bs-ccomponent">
                    <div class="list-group">
                        <a href="#" class="list-group-item list-group-item-action flex-column align-items-start active" style="border-color: #A22C29; background-color: #A22C29;">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Favorite Films</h5>
                                <small><br></small>
                            </div>
                            <p class="mb-1"></p>
                        </a>
                        <div class="form-group text-light" style="border: solid 0.2em #a22c29;">
                            <p style="font-size: 23px;">List of favourite user films</p>
                        </div>
                        <a href="#" class="list-group-item list-group-item-action flex-column align-items-start active" style="border-color: #A22C29; background-color: #A22C29;">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Favorite Series</h5>
                                <small><br></small>
                            </div>
                            <p class="mb-1"></p>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action flex-column align-items-start active" style="border-color: #A22C29; background-color: #A22C29;">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Favorite Animations</h5>
                                <small><br></small>
                            </div>
                            <p class="mb-1"></p>
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-4" style="border-color: #A22C29; padding-top: 23px;">
                <div class="bs-ccomponent">
                    <div class="list-group">
                        <a href="#" class="list-group-item list-group-item-action flex-column align-items-start active" style="border-color: #A22C29; background-color: #A22C29;">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Title of question</h5>
                                <small>1 day ago</small>
                            </div>
                            <p class="mb-1">Your question has been answered.</p>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action flex-column align-items-start">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Question you follow</h5>
                                <small class="text-muted">2 days ago</small>
                            </div>
                            <p class="mb-1">This question has X new answers.</p>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action flex-column align-items-start">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Answer you follow</h5>
                                <small class="text-muted">3 days ago</small>
                            </div>
                            <p class="mb-1">This answer has X new comments.</p>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection()