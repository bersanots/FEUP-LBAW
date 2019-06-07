@extends('layouts.app')

@section('title', 'Create Question')

@section('content')


<div class="container" style="padding-top: 10px;">
    <div style="padding: 20px; padding-top: 10px; background: #f8f8f8; border-style: solid; border-color: #A22C29; border-width: 0.3em;" class="border border-primary text-dark">
        <form action="{{ route('createQuestion')}}" method="POST">
            {{csrf_field()}}
            <h3> Create Question </h3>
            <input hidden type="text" value={{ Request::segment(3) }} name="category">
            <div class="form-group">
                <label class="col-form-label" for="inputDefault">Question title</label>
                <input type="text" class="form-control-file" id="descriptionInput" placeholder="Title" name="title" required autofocus>
            </div>
            <div class="form-group">
                <label class="col-form-label" for="inputDefault">Question description</label>
                <textarea class="form-control-file" placeholder="Description" name="description" required></textarea>
            </div>
            <div class="form-group">
                <label class="col-form-label" for="inputDefault">Search tags</label>
                <input type="text" class="form-control" placeholder="Tag" id="inputDefault2" maxlength="100">
            </div>
            <button type="submit" class="btn btn-primary">Send</button>
        </form>
    </div>
</div>
@endsection