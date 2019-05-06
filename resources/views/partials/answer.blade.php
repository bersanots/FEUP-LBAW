<div class="accepted_answer text-dark" data-id="{{$answer->answer_id}}" style="padding: 0.5em; border-left-color: #a22c29; border-left-style: solid; border-left-width: 0.3em; margin-top: 2em; background-color: #f8f8f8;">
  <div class="answer_info" style="padding: 1em; font-size: 1em; width: 100%; display: grid; grid-template-column: auto auto auto; columns: 2; margin: 0em 0em 1em 0em;">
    <div class="question_user" style="font-style: italic; text-align: left; grid-area: auto / 1 / auto / 1;">
      by
      <a href="/users/{{ $answer->user->username }}" class="comment-user">{{ $answer->user->username }}</a>
      <span class="question_date">{{ $answer->creation_date }}</span>
    </div>
    <div class="question_score" style="grid-column: 2; text-align: right;">
      <i class="fas fa-arrow-up"></i>
      <span class="score">{{ $answer->score }}</span>
      <i class="fas fa-arrow-down"></i>
    </div>
  </div>
  <div class="answer_body">
    <p style="padding-left: 1em;"> {{ $answer->description }} </p>
  </div>
</div>