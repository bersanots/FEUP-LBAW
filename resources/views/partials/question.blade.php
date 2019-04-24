<article class="question" data-id="{{ $question->id }}">
<header>
  <h2><a href="/questions/{{ $question->id }}">{{ $question->title }}</a></h2>
  <a href="#" class="delete">&#10761;</a>
</header>
<ul>
  @each('partials.answer', $question->answers()->orderBy('id')->get(), 'answer')
</ul>
<form class="new_answer">
  <input type="text" name="description" placeholder="Description of the answer">
</form>
</article>
