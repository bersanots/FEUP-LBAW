<div id="bkgnd" class="question container ">
    <div class="question_content">
        <div class="question">
            <h2>
                <a href="/questions/{{ $question->question_id }}">{{ $question->title }}</a>
                <div class="question_info">
                    <div class="question_user">
                        by
                        @if (isset($question->user))
                            <a href="/users/{{ $question->user->username }}" class="comment-user">{{ $question->user->username }}</a>
                        @else
                            <a href="/users/{{ $question->question_author }}" class="comment-user">{{ $question->question_author }}</a>
                        @endif
                        <span class="question_date">{{ \Carbon\Carbon::parse($question->creation_date)->diffForHumans() }}</span>
                    </div>
                    <div class="question_score">
                        <span class="preview-score">{{ $question->score }}</span>
                    </div>
                </div>
        </div>
    </div>
</div>