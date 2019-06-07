<article class="question" data-id="{{ $question->question_id }}">
  <div id="question-column" class="container">
    <div class="question_content">
      <div class="question">
        <h2>
          <a href="/questions/{{ $question->question_id }}">{{ $question->title }}</a>
          <p id="questionId" hidden>{{ $question->question_id }}</p>
        </h2>
        <div class="question_info" >
          <div class="question_user">
            by
            <a href="/users/{{ $question->user->username }}" class="comment-user">{{ $question->user->username }}</a>
            <span class="question_date">{{ \Carbon\Carbon::parse($question->creation_date)->diffForHumans() }}</span>
          </div>
          <div class="question_score">
            <button id="questionFavBtn" class="question-favourite" type="button" onClick="favouriteQuestion(<?= $question->question_id ?>)"><i class="fas fa-star"></i></button>
            <button id="questionUpBtn" class="question-upvote" type="button" onClick="voteQuestion(<?= $question->question_id ?>, 1)"><i class="fas fa-arrow-up"></i></button>
            <span class="score" id="question-score">{{ $question->score }}</span>
            <p id="question-id-score" hidden>{{ $question->question_id }}</p>
            <button id="questionDownBtn" class="question-downvote" type="button" onClick="voteQuestion(<?= $question->question_id ?>, -1)"><i class="fas fa-arrow-down"></i></button>
          </div>
        </div>
      </div>
      <div class="question-body">
        <p>{{ $question->description }}</p>
      </div>
      <div class="comments">
        {{-- @each('partials.commentQuestion', $question->comments()->orderBy('creation_date', 'ASC')->get(), 'comment_q')
        <div> --}}
        <form action="{{ route('createCommentQuestion', ['question_id' => $question->question_id])}}" method="POST">
          {{ csrf_field() }}
          <input class="form-control mr-sm-3 " type="text" placeholder="Comment">
          <button type="submit" class="btn btn-primary">Send</button>
        </form>
        {{-- </div> --}}

      </div>
    </div>
    <div class="answers">
      @each('partials.answer', $question->answers()->orderBy('creation_date', 'ASC')->get(), 'answer')
      <div class="new_answer text-dark">
        <form action="{{ route('createAnswer', ['question_id' => $question->question_id])}}" method="POST">
        {{ csrf_field() }}
          <div class="answer_info">
            <div class="answer_user" >
              <h3> Write your own answer </h3>
            </div>
          </div>
          <div class="answer_body">
            <textarea class="answer-form" placeholder="Your answer..." id="write_answer" name="body" maxlength="1023"></textarea>
          </div>
          <button type="submit" class="btn btn-primary">Send</button>
        </form>
      </div>
    </div>
  </div>
</article>