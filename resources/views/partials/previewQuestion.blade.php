<div id="bkgnd" class="question container ">
    <div class="question_content" style="color: #333333; border-color: #a22c29; border-style: solid; margin-top: 2em;">
        <div class="question" style="padding:1em; background-color: #f8f8f8;">
            <h2 style="background-color: none; border-bottom-style: solid; border-bottom-color: #a22c29; margin: 0em; padding-left: 0.5em;">
                <a href="/questions/{{ $question->question_id }}">{{ $question->title }}</a>
                <div class="question_info" style="padding: 1em; font-size: 0.75em; width: 100%; display: grid; grid-template-column: auto auto auto auto; columns: 3; margin: 0em 0em 1em 0em;">
                    <div class="question_user" style="font-style: italic; text-align: left; grid-area: auto / 1 / auto / 1;">
                        by
                        @if (isset($question->user))
                            <a href="/users/{{ $question->user->username }}" class="comment-user">{{ $question->user->username }}</a>
                        @else
                            <a href="/users/{{ $question->question_author }}" class="comment-user">{{ $question->question_author }}</a>
                        @endif
                        <span class="question_date">{{ \Carbon\Carbon::parse($question->creation_date)->diffForHumans() }}</span>
                    </div>
                    <div class="question_score" style="grid-column: 2; text-align: right;">
                        <span class="preview-score">{{ $question->score }}</span>
                    </div>
                </div>
        </div>
    </div>
</div>