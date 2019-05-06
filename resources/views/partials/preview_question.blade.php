<div id="bkgnd" class="question container ">
    <div class="question_content" style="color: #333333; border-color: #a22c29; border-style: solid; margin-top: 2em;">
        <div class="question" style="padding:1em; background-color: #f8f8f8;">
            <h2 style="background-color: none; border-bottom-style: solid; border-bottom-color: #a22c29; margin: 0em; padding-left: 0.5em;">
                <a href="/questions/{{ $question->question_id }}">{{ $question->title }}</a>
                <i class="fas fa-star" style="font-size:1.5em; color:black"></i>
                <div class="question_info" style="padding: 1em; font-size: 0.75em; width: 100%; display: grid; grid-template-column: auto auto auto auto; columns: 3; margin: 0em 0em 1em 0em;">
                    <div class="question_user" style="font-style: italic; text-align: left; grid-area: auto / 1 / auto / 1;">
                        by
                        <a href="/users/{{ $question->user->username }}" class="comment-user">{{ $question->user->username }}</a>
                        <span class="question_date">{{ $question->creation_date }}</span>
                    </div>
                    <div class="question_score" style="font-size: 1.5em; grid-column: 3; text-align: right;">
                        <i class="fas fa-arrow-up" style="color:#a22c29"></i>
                        <span class="score">{{ $question->score }}</span>
                        <i class="fas fa-arrow-down"></i>
                    </div>
                </div>
        </div>
    </div>
</div>