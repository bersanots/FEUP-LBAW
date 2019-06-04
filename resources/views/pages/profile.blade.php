@extends('layouts.app')

@section('title', 'LCQ')

@section('content')

<div class="container">
    <legend class="text-light" style="padding: 10px; border-bottom: solid 0.2em #a22c29; margin-top: 1em;">
        <img style="padding-right: 20px;" src="icon/profile.png">&nbsp;
        <b class="text-light">{{ $user->username }}</b>'s profile
    </legend>
    <div class="bs-docs-section">
        <div class="row">
            <div class="col-lg-4" style="padding-top: 23px;">
                <div class="bs-ccomponent">
                    <img src="{{ $user->picture }}" style="width: 100%; height: 200px; object-fit: cover; border: solid 0.2em #a22c29;" class="border border-primary">
                    <div id="myTabContent" class="tab-content">
                        <div class="tab-pane fade active show" id="about">
                            <div style="padding: 20px; padding-top: 10px; border: solid 0.2em #a22c29;" class="text-light border border-primary">
                                <fieldset>
                                    <div class="form-group">
                                        <label class="col-form-label" for="inputDefault">
                                            <b>Email address</b>
                                        </label>
                                        <p>{{ $user->email }}</p>
                                    </div>
                                    <div class="form-group">
                                        <b>Description</b>
                                        <p>{{ $user->description }}</p>
                                    </div>
                                    @if(Auth::user()->user_id == $user->user_id)
                                    <a class="button" href="{{Auth::user()->username}}/edit">Edit Profile</a>
                                    <a class="button" href="">Moderator</a>
                                    <a class="button" href="">Admin</a>
                                    @endif
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
            @if(Auth::user()->user_id == $user->user_id)
            <div class="col-lg-4" style="border-color: #A22C29; padding-top: 23px;">
                <div class="bs-ccomponent">
                    <div class="list-group">
                        @foreach ($user->notifications($user->user_id) as $notification)
                            @if($notification->type == 'New message')
                                @if($notification->has_seen == false)
                                    <a href="#" class="list-group-item list-group-item-action flex-column align-items-start active" style="border-color: #A22C29; background-color: #A22C29;">
                                @else
                                    <a href="#" class="list-group-item list-group-item-action flex-column align-items-start">
                                @endif
                                    <div class="d-flex w-100 justify-content-between">
                                        <h5 class="mb-1">New message from {{ $notification->author }}</h5>
                            @elseif($notification->type == 'New answer')
                                @if($notification->has_seen == false)
                                    <a href="../questions/{{ $user->notification_resource($notification->notification_id)[0]->object_id }}" class="list-group-item list-group-item-action flex-column align-items-start active" style="border-color: #A22C29; background-color: #A22C29;">
                                @else
                                    <a href="../questions/{{ $user->notification_resource($notification->notification_id)[0]->object_id }}" class="list-group-item list-group-item-action flex-column align-items-start">
                                @endif
                                    <div class="d-flex w-100 justify-content-between">
                                        <h5 class="mb-1">Your question has been answered by {{ $notification->author }}</h5>
                            @elseif($notification->type == 'New comment on question')
                                @if($notification->has_seen == false)
                                    <a href="../questions/{{ $user->notification_resource($notification->notification_id)[0]->object_id }}" class="list-group-item list-group-item-action flex-column align-items-start active" style="border-color: #A22C29; background-color: #A22C29;">
                                @else
                                    <a href="../questions/{{ $user->notification_resource($notification->notification_id)[0]->object_id }}" class="list-group-item list-group-item-action flex-column align-items-start">
                                @endif
                                    <div class="d-flex w-100 justify-content-between">
                                        <h5 class="mb-1">Your question has been commented by {{ $notification->author }}</h5>
                            @else
                                @if($notification->has_seen == false)
                                    <a href="../questions/{{ $user->notification_resource($notification->notification_id)[0]->object_id }}" class="list-group-item list-group-item-action flex-column align-items-start active" style="border-color: #A22C29; background-color: #A22C29;">
                                @else
                                    <a href="../questions/{{ $user->notification_resource($notification->notification_id)[0]->object_id }}" class="list-group-item list-group-item-action flex-column align-items-start">
                                @endif
                                    <div class="d-flex w-100 justify-content-between">
                                        <h5 class="mb-1">Your answer has been commented by {{ $notification->author }}</h5>
                            @endif
                                    <small class="text-muted">{{ \Carbon\Carbon::parse($notification->date)->diffForHumans() }}</small>
                                </div>
                            </a>
                        @endforeach
                    </div>
                </div>
            </div>
            @endif
        </div>
    </div>
</div>

@endsection()