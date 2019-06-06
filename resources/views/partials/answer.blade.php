<div class="accepted_answer text-dark" data-id="{{$answer->answer_id}}" style="padding: 0.5em; border-left-color: #a22c29; border-left-style: solid; border-left-width: 0.3em; margin-top: 2em; background-color: #f8f8f8;">
  <div class="answer_info" style="padding: 1em; font-size: 1em; width: 100%; display: grid; grid-template-column: auto auto auto; columns: 2; margin: 0em 0em 1em 0em;">
    <div class="answer_user" style="font-style: italic; text-align: left; grid-area: auto / 1 / auto / 1;">
      by
      <a href="/users/{{ $answer->user->username }}" class="comment-user">{{ $answer->user->username }}</a>
      <span class="answer_date">{{ \Carbon\Carbon::parse($answer->creation_date)->diffForHumans() }}</span>
    </div>
    <div id="{{$answer->answer_id}}" class="answer_score" style="grid-column: 2; text-align: right;">
      <button class="answerUp upvote" type="button" onClick="voteAnswer(<?= $answer->answer_id ?>, 1)"><i class="fas fa-arrow-up"></i></button>
      <span class="answer-score">{{ $answer->score }}</span>
      <button class="answerDown downvote" type="button" onClick="voteAnswer(<?= $answer->answer_id ?>, -1)"><i class="fas fa-arrow-down"></i></button>
    </div>
  </div>
  <div class="answer_body">
    <p style="padding-left: 1em;"> {{ $answer->description }} </p>
  </div>
  @if($answer->question()->get()[0]->best != $answer->answer_id)
  <form action="{{ route('deleteAnswer', ['answer_id' => $answer->answer_id])}}" method="POST">
    {{csrf_field()}}
    {{method_field('DELETE')}}
    <button type="submit" class="btn btn-primary">Delete</button>
  </form>
  @endif
  <div class="comments" style="text-indent: 18px;padding:0.3em">
    @each('partials.commentAnswer', $answer->comments()->orderBy('creation_date', 'ASC')->get(), 'comment_a')
    <div>
      <form action="{{ route('createCommentAnswer', ['answer_id' => $answer->answer_id])}}" method="POST">
        <input class="form-control mr-sm-3 " type="text" placeholder="Comment" style="margin-left: 1em; width:10em">
        <button type="submit" class="btn btn-primary">Send</button>
      </form>
    </div>
  </div>
</div>