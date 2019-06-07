@extends('layouts.app')

@section('title', 'LCQ')

@section('content')

<div class="container">
    <div class="bs-docs-section">
        <div class="row">
            <div class="col-lg-2"></div>
            <div class="col-lg-8"">
                <div class="col-lg-12" >
                    <div class="bs-ccomponent">
                        <div class="border-primary border">
                            <legend class="text-dark">@ Contact us</legend>

                            <form action="{{ url('contact')}}" method="POST">
                                {{csrf_field()}}
                                <div class="form-group">
                                    <label for="inputEmail" class="text-dark font-weight-bold">E-mail address</label>
                                    <input type="email" class="form-control" placeholder="E-mail address" id="contactEmail" name="contactEmail">
                                </div>
                                <div class="form-group">
                                    <label for="exampleInputEmail1" class="text-dark font-weight-bold">Message</label>
                                    <textarea class="form-control" id="contactMessage" name="contactMessage" placeholder="Write your message here..."></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary">Submit</button>
                            </form>

                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-2"></div>
        </div>
    </div>
</div>
@endsection()