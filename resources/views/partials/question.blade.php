<article class="question" data-id="{{ $question->question_id }}">
<header>
  <h2><a href="/questions/{{ $question->question_id }}">{{ $question->title }}</a></h2>
  <h2>{{ $question->description }}</h2>
  <a href="#" class="delete">&#10761;</a>
</header>
<ul>
  @each('partials.answer', $question->answers()->orderBy('creation_date', 'ASC')->get(), 'answer')
</ul>
<form class="new_answer">
  <input type="text" name="description" placeholder="Description of the answer">
</form>
</article>
