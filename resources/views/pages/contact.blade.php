@extends('layouts.app')

@section('title', 'LCQ')

@section('content')

<div class="container">
    <div class="bs-docs-section">
        <div class="row">
            <div class="col-lg-2"></div>
            <div class="col-lg-8" style="padding-top: 23px;">
                <div class="col-lg-12" style="padding-left: 0; padding-right:0;">
                    <div class="bs-ccomponent">
                        <div style="background-color: #f8f8f8; padding: 20px; padding-top: 10px; border-color: #A22C29; border-style: solid; border-width: 0.2em;" class="border-primary border">
                            <legend style="padding: 10px; border-bottom-width: 0.2em; border-bottom-style: solid; border-color: #A22C29; text-align: center; font-weight: bold; font-variant: normal; margin: 0 auto; margin-top: 0.5em; width: 610px;" class="text-dark">@ Contact us</legend>

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