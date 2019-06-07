@extends('layouts.app')

@section('title', 'LCQ')

@section('content')

<div style="width: 100%;" class="bg-dark text-light">
    <br>
    <div class="container">
        <legend>
            <i class="fas fa-ban" style="font-size: 25px; color: #A22C29;"></i>
            <span class="text-light">
                Manage Users </span>
        </legend>
        <div class="bs-docs-section">
            <div class="row">
                <div class=" col-lg-11">
                    <div class="col-lg-12">
                        <input class="form-control" type="text" placeholder="Search">
                        <button class="search-btn" type="submit">Search</button>
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Reported User</th>
                                <th>Reported For</th>
                                <th>Reported By</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @php
                                $i = 1;
                            @endphp
                            @foreach ($reports as $report)
                            <tr>
                                <th scope="row">{{$i}}</th>
                                <td>{{$report->target()->first()->username}}</td>
                                <td>{{$report->description}}</td>
                                <td>{{$report->author()->first()->username}}</td>
                                <td>
                                    <button type="button" class="btn btn-light" style="margin-top: 0.5em;">Ban</button>
                                    <button type="button" class="close" aria-label="Close"></button>
                                </td>
                            </tr>
                            @php
                                $i++;
                            @endphp
                            @endforeach
                        </tbody>
                    </table>
                </div>
                
                <div class="btn-toolbar" role="toolbar" aria-label="Toolbar with button groups">
                    <div class="btn-group1" role="group" aria-label="First group">
                        <button type="button" class="btn btn-secondary">&lt&lt</button>
                        <button type="button" class="btn btn-secondary">1</button>
                        <button type="button" class="btn btn-secondary">2</button>
                        <button type="button" class="btn btn-secondary">3</button>
                        <button type="button" class="btn btn-secondary">&gt&gt</button>
                    </div>
                    <div class="btn-group2" role="group" aria-label="Second group">
                    </div>
                </div>
            </div>
            <br>
            <br>
            <legend>
                <i class="fas fa-ban" style="font-size: 25px; color: #A22C29;"></i>
                <span style="margin-left: .5rem;" class="text-light">
                    Manage Moderators </span>
            </legend>
            <div class="col-lg-11">
                <div class="col-lg-12">
                    <div class="bs-ccomponent">
                        <input class="form-control" type="text" placeholder="Search">
                        <button class="search-btn" type="submit">Search</button>
                    </div>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Username</th>
                            <th>Moderator since</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th scope="row">1</th>
                            <td>HappyMonkey</td>
                            <td>21-05-2017</td>
                            <td>
                                <a href="#"><i class="far fa-times-circle"
                                        style="font-size: 25px; color: #A22C29;"></i></a>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">2</th>
                            <td>RandomMod</td>
                            <td>13-01-2016</td>
                            <td>
                                <a href="#"><i class="far fa-times-circle"
                                        style="font-size: 25px; color: #A22C29;"></i></a>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">3</th>
                            <td>NotARealHero</td>
                            <td>07-12-2018</td>
                            <td>
                                <a href="#"><i class="far fa-times-circle"
                                        style="font-size: 25px; color: #A22C29;"></i></a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-toolbar" role="toolbar" aria-label="Toolbar with button groups">
                <div class="btn-group1" role="group" aria-label="First group">
                    <button type="button" class="btn btn-secondary">&lt&lt</button>
                    <button type="button" class="btn btn-secondary">1</button>
                    <button type="button" class="btn btn-secondary">2</button>
                    <button type="button" class="btn btn-secondary">&gt&gt</button>
                </div>
                <div class="btn-group2" role="group" aria-label="Second group">
                </div>
            </div>
        </div>
    </div>
</div>

@endsection()