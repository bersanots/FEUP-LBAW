<div class="accepted_answer text-dark" data-id="{{$answer->answer_id}}" >
  <div class="answer_info">
    <div class="answer_user">
      by
      <a href="/users/{{ $answer->user->username }}" class="comment-user">{{ $answer->user->username }}</a>
      <span class="answer_date">{{ \Carbon\Carbon::parse($answer->creation_date)->diffForHumans() }}</span>
    </div>
    <div id="{{$answer->answer_id}}" class="answer_score">
      <button class="answerUp upvote" type="button" onClick="voteAnswer(<?= $answer->answer_id ?>, 1)"><i class="fas fa-arrow-up"></i></button>
      <span class="answer-score">{{ $answer->score }}</span>
      <button class="answerDown downvote" type="button" onClick="voteAnswer(<?= $answer->answer_id ?>, -1)"><i class="fas fa-arrow-down"></i></button>
    </div>
  </div>
  <div class="answer_body">
    <p> {{ $answer->description }} </p>
  </div>
  @if($answer->question()->get()[0]->best != $answer->answer_id)
  <form action="{{ route('deleteAnswer', ['answer_id' => $answer->answer_id])}}" method="POST">
    {{csrf_field()}}
    {{method_field('DELETE')}}
    <button type="submit" class="btn btn-primary">Delete</button>
  </form>
  @endif
  <div class="comments">
    @each('partials.commentAnswer', $answer->comments()->orderBy('creation_date', 'ASC')->get(), 'comment_a')
    <div>
      <form action="{{ route('createCommentAnswer', ['answer_id' => $answer->answer_id])}}" method="POST">
        <input class="form-control mr-sm-3 " type="text" placeholder="Comment">
        <button type="submit" class="btn btn-primary">Send</button>
      </form>
    </div>
  </div>
</div>