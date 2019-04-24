<li class="answer" data-id="{{$answer->id}}">
  <label>
    <input type="checkbox" {{ $answer->done?'checked':''}}>
    <span>{{ $answer->description }}</span>
    <a href="#" class="delete">&#10761;</a>
  </label>
</li>
