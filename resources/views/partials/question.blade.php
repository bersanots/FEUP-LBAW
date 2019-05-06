<article class="question" data-id="{{ $question->question_id }}">
  <header>
    <h2><a href="/questions/{{ $question->question_id }}">{{ $question->title }}</a></h2>
    <h2>{{ $question->description }}</h2>
    <div class="question_info">
      <div class="question_user">
        by
        <a href="/users/{{ $question->author }}" class="comment-user">{{ $question->user->username }}</a>
        <span class="question_date">{{ $question->creation_date }}</span>
      </div>
      <div class="question_score">
        <i class="fas fa-arrow-up" style="color:#a22c29"></i>
        <span class="score">{{ $question->score }}</span>
        <i class="fas fa-arrow-down"></i>
      </div>
    </div>
  </header>
  <ul>
    @each('partials.answer', $question->answers()->orderBy('creation_date', 'ASC')->get(), 'answer')
  </ul>
  <form class="new_answer">
    <input type="text" name="description" placeholder="Description of the answer">
  </form>
</article>
