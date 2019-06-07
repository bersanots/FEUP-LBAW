@extends('layouts.app')

@section('title', 'LCQ')

@section('content')

<div style="width: 100%;" class="bg-dark text-light">
    <br>
    <div class="container">
        <legend style="color: #333; padding: 10px; border-bottom: solid 0.2em #a22c29;">
            <i class="fas fa-ban" style="font-size: 25px; color: #A22C29;"></i>
            <span style="margin-left: .5rem;" class="text-light">
                Manage Tags </span>
        </legend>
        <div class="bs-docs-section">
            <div class="row">
                <div style="margin: 2em 0em; width: 100%;">
                    <div class="col-lg-6" style="padding-top: 23px;">
                        <div class="col-lg-12" style="padding-left: 0; padding-right:0;">
                            <div class="bs-ccomponent">
                                <input class="form-control" type="text" placeholder="Search">
                                <button class="search-btn" type="submit">Search</button>
                            </div>
                        </div>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Name</th>
                                </tr>
                            </thead>
                            <tbody>
                                @php
                                    $i = 1;
                                @endphp
                                @foreach ($tags as $tag)
                                <tr>
                                    <th scope="row">{{$i}}</th>
                                    <td>{{$tag->name}}</td>
                                    <td>
                                        <button type="button" class="btn btn-light" style="margin-top: 0.5em;">Remove</button>
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
                        <div class="btn-group" role="group" aria-label="First group" style="margin-left:9em">
                            <button type="button" class="btn btn-secondary">&lt&lt</button>
                            <button type="button" class="btn btn-secondary">1</button>
                            <button type="button" class="btn btn-secondary">2</button>
                            <button type="button" class="btn btn-secondary">3</button>
                            <button type="button" class="btn btn-secondary">&gt&gt</button>
                        </div>
                        <div class="btn-group" role="group" aria-label="Second group" style="margin-left:18em">
                        </div>
                    </div>
                </div>
                <div style="width: 100%;">
                    <legend style="color: #333; padding: 10px; border-bottom: solid 0.2em #a22c29; width: 100%;">
                        <i class="fas fa-ban" style="font-size: 25px; color: #A22C29;"></i>
                        <span style="margin-left: .5rem;" class="text-light">
                            Add Tags </span>
                    </legend>
                    <div class="text-dark col-lg-11"
                        style="background-color: #f8f8f8; border-style: solid; border-color: #a22c29; border-width: 0.2em; margin-left: 1em; max-width: 275px;">
                        <div class="col-lg-12" style="padding-left: 0; padding-right:0;">
                            <input class="form-control" type="text" placeholder="Tag" style="max-width: 250px;">
                            <button class="search-btn" type="submit">Add
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection()