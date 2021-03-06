<div id="categories-list">
  <a class="question-categories" href="/questions/category/series"><img src="../img/retro-tv.png"></a>
  <a class="question-categories" href="/questions/category/film"> <img src="../img/film_roll.png"></a>
  <a class="question-categories" href="/questions/category/animation"><img src="../img/mickey.png"></a>
</div>

<article class="question" data-id="{{ $question->question_id }}">
  <div id="question-column" class="container">
    <div class="question_content" style="background-color: #f8f8f8; color: #333333; margin-top: 2em;">
      <div class="question" style="padding:1em">
        <h2 style="background-color: #f8f8f8; border-bottom-style: solid; border-bottom-color: #a22c29; margin: 0em; padding-left: 0.5em;">
          <a href="/questions/{{ $question->question_id }}">{{ $question->title }}</a>
          <p id="questionId" hidden>{{ $question->question_id }}</p>
        </h2>
        <div class="question_info" style="padding: 1em; font-size: 0.75em; width: 100%; display: grid; grid-template-column: auto auto auto; columns: 2; margin: 0em 0em 1em 0em;">
          <div class="question_user" style="font-style: italic; text-align: left; grid-area: auto / 1 / auto / 1;">
            by
            <a href="/users/{{ $question->user->username }}" class="comment-user">{{ $question->user->username }}</a>
            <span class="question_date">{{ \Carbon\Carbon::parse($question->creation_date)->diffForHumans() }}</span>
          </div>
          <div class="question_score" style="font-size: 1.5em; grid-column: 2; text-align: right;">
            <button id="questionFavBtn" class="question-favourite" type="button" onClick="favouriteQuestion(<?= $question->question_id ?>)"><i class="fas fa-star"></i></button>
            <button id="questionUpBtn" class="question-upvote" type="button" onClick="voteQuestion(<?= $question->question_id ?>, 1)"><i class="fas fa-arrow-up"></i></button>
            <span class="score" id="question-score">{{ $question->score }}</span>
            <p id="question-id-score" hidden>{{ $question->question_id }}</p>
            <button id="questionDownBtn" class="question-downvote" type="button" onClick="voteQuestion(<?= $question->question_id ?>, -1)"><i class="fas fa-arrow-down"></i></button>
          </div>
        </div>
      </div>
      <div class="question-body" style="background-color: #f5f5f5;">
        <p style="padding-left: 1em;">{{ $question->description }}</p>
      </div>
      <div class="comments" style="text-indent: 18px;padding:0.3em">
        {{-- @each('partials.commentQuestion', $question->comments()->orderBy('creation_date', 'ASC')->get(), 'comment_q')
        <div> --}}
        <form action="{{ route('createCommentQuestion', ['question_id' => $question->question_id])}}" method="POST">
          {{ csrf_field() }}
          <input class="form-control mr-sm-3 " type="text" placeholder="Comment" style="margin-left: 1em; width:10em">
          <button type="submit" class="btn btn-primary">Send</button>
        </form>
        {{-- </div> --}}

      </div>
    </div>
    <div class="answers">
      @each('partials.answer', $question->answers()->orderBy('creation_date', 'ASC')->get(), 'answer')
      <div class="new_answer text-dark" style="padding: 0.5em; border-left-style: solid; border-left-color: #a22c29; margin-top: 1em; background-color: #f8f8f8;">
        <form action="{{ route('createAnswer', ['question_id' => $question->question_id])}}" method="POST">
          <div class="answer_info">
            <div class="question_user" style="font-style: italic; text-align: left; grid-area: auto / 1 / auto / 1;">
              <h3> Write your own answer </h3>
            </div>
          </div>
          <div class="answer_body">
            <textarea class="answer-form" placeholder="Your answer..." id="inputDefault" maxlength="1023"></textarea>
          </div>
          <button type="submit" class="btn btn-primary">Send</button>
        </form>
      </div>
    </div>
  </div>
</article>