<li class="comment" style="border-top-style: dashed; list-style-type: none; border-color: #a22c29;">
    <div class="comment-text">
        <span class="comment-body">{{ $comment_a->description }}</span>
        -
        <a href="/users/{{ $comment_a->user->username }}" class="comment-user">{{ $comment_a->user->username }}</a>
        <span class="comment_date">{{ \Carbon\Carbon::parse($comment_a->creation_date)->diffForHumans() }}</span>
    </div>
</li>