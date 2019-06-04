<li class="comment" style="border-top-style: dashed; list-style-type: none; border-color: #a22c29;">
    <div class="comment-text" style="grid-column: 2;">
        <span class="comment-body">{{ $comment_q->description }}</span>
        -
        <a href="/users/{{ $comment_q->user->username }}" class="comment-user">{{ $comment_q->user->username }}</a>
        <span class="comment_date">{{ \Carbon\Carbon::parse($comment_q->creation_date)->diffForHumans() }}</span>
    </div>
</li>