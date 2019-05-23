@extends('layouts.app')

@section('title', 'LCQ')

@section('content')

<div class="container">
    <legend style="padding: 10px; margin-left: 0; border-bottom: solid 0.2em #a22c29;">
        <img src="icon/profile.png">
        <span style="margin-left: .5rem;" class="text-light">
            Editing <b>{{ $user->username }}</b>'s' Profile </span>
    </legend>
    <div class="bs-docs-section">
        <div class="row">
            <div class="col-lg-6" style="padding-top: 23px;">
                <div class="col-lg-12" style="padding-left: 0; padding-right:0;">
                    <div class="bs-ccomponent">
                        <div style="padding: 20px; padding-top: 10px; background-color: #f8f8f8; border: solid #a22c29;" class="border-primary border text-dark">
                            <form action="{{ route('editPersonal', ['user' => $user])}}" method="POST">
                                {{csrf_field()}}
                                {{method_field('PATCH')}}
                                <h3>Personal details</h3>
                                <div class="form-group">
                                    <label class="col-form-label" for="eventImg">
                                        <label class="col-form-label" for="inputDefault">Description</label>
                                    </label>
                                    <input type="text" class="form-control-file" id="descriptionInput" value="{{$user->description}}" name="description">
                                </div>
                                <div class="form-group">
                                    <label class="col-form-label" for="eventImg">
                                        <label class="col-form-label" for="inputDefault">Profile Image</label>
                                    </label>
                                    <input type="file" class="form-control-file" id="eventImg" aria-describedby="fileHelp" name="image">
                                </div>
                                <br>
                                <button type="submit" class="btn btn-primary">Save changes</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6" style="padding-top: 23px;">
                <div class="col-lg-12" style="padding-left: 0; padding-right:0;">
                    <div class="bs-ccomponent">
                        <div style="padding: 20px; padding-top: 10px; border: solid #a22c29; background-color: #f8f8f8;" class="border-primary border text-dark">
                          
                          
                        <form action="{{ route('editAccount', ['user' => $user])}}" method="POST">

                            {{csrf_field()}}
                            {{method_field('PATCH')}}
                            <h3>Account details</h3>
                                <div class="form-group">
                                    <label class="col-form-label" for="inputDefault">
                                        <label class="col-form-label" for="inputDefault">Email adress</label>
                                    </label>
                                    <input type="text" class="form-control-file" id="descriptionInput" name="email" required>
                                </div>
                                <div class="form-group">
                                    <label class="col-form-label" for="inputDefault">
                                        <label class="col-form-label" for="inputDefault">New Password</label>
                                    </label>
                                    <input type="password" class="form-control-file" id="descriptionInput" name="password">
                                </div>
                                <div class="form-group">
                                    <label class="col-form-label" for="inputDefault">
                                        <label class="col-form-label" for="inputDefault">Confirm Password</label>
                                    </label>
                                    <input type="password" class="form-control-file" id="descriptionInput" name="confirmPassword">
                                </div>

                                <button type="submit" class="btn btn-primary">Save changes</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection()