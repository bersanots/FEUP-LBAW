<?php

namespace App;

use Illuminate\Support\Facades\DB;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    use Notifiable;

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    protected $primaryKey = 'user_id';

    protected $table = 'users';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'username', 'email', 'password',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

    /**
     * The questions this user made.
     */
    public function questions()
    {
        return $this->hasMany('App\Question', 'author');
    }

    /**
     * The answers this user made.
     */
    public function answers()
    {
        return $this->hasMany('App\Answer', 'author');
    }

    /**
    * The favourite media of this user
    */
    public function favourite()
    {
        return $this->belongsToMany('App\Media', 'favourite', 'user_id', 'media_id');
    }

    /**
     * Show a list of all of the user's notifications.
     *
     * @return Response
     */
    public function notifications($user_id)
    {
        $notifications = DB::select("
        SELECT notifs.notification_id, type, date, has_seen, notifs.description, username AS author
        FROM
        ((SELECT notification.notification_id, 'New message' AS type, notification.date, message.title AS description, message.author AS author_id
        FROM notification
        JOIN notif_new_msg ON notif_new_msg.nnm_id = notification.notification_id
        JOIN message ON message.message_id = notif_new_msg.message_id)
        UNION
        (SELECT notification.notification_id, 'New answer' AS type, notification.date, answer.description, answer.author AS author_id
        FROM notification
        JOIN notif_new_ans ON notif_new_ans.nna_id = notification.notification_id
        JOIN answer ON answer.answer_id = notif_new_ans.answer_id)
        UNION
        (SELECT notification.notification_id, 'New comment on question' AS type, notification.date, comment_question.description, comment_question.author AS author_id
        FROM notification
        JOIN notified ON notification.notification_id = notified.notification_id  JOIN notif_comment_q ON notif_comment_q.ncq_id = notification.notification_id
        JOIN comment_question ON comment_question.cq_id = notif_comment_q.comment_question_id)
        UNION
        (SELECT notification.notification_id, 'New comment on answer' AS type, notification.date, comment_answer.description, comment_answer.author AS author_id
        FROM notification
        JOIN notif_comment_ans ON notif_comment_ans.nca_id = notification.notification_id
        JOIN comment_answer ON comment_answer.ca_id = notif_comment_ans.comment_answer_id)) AS notifs
        JOIN notified ON notifs.notification_id = notified.notification_id
        JOIN users ON notifs.author_id = users.user_id
        WHERE :user_id = notified.user_id
        ORDER BY date DESC;
        ", ['user_id' => $user_id]);

        return $notifications;
    }

    /**
     * Get the id of the resource that generated a user's notification.
     *
     * @return Response
     */
    public function notification_resource($notif_id)
    {
        $obj_id = DB::select("
        SELECT object_id
        FROM
        ((SELECT message_id AS object_id
        FROM notif_new_msg
        WHERE nnm_id = :notif_id)
        UNION
        (SELECT question_id AS object_id
        FROM answer
        WHERE answer_id = 
        (SELECT answer_id
        FROM notif_new_ans
        WHERE nna_id = :notif_id))
        UNION
        (SELECT question_id AS object_id
        FROM answer
        WHERE answer_id = 
        (SELECT answer_id
        FROM comment_answer
        WHERE ca_id = 
        (SELECT comment_answer_id
        FROM notif_comment_ans
        WHERE nca_id = :notif_id)))
        UNION
        (SELECT question_id AS object_id
        FROM comment_question
        WHERE cq_id = 
        (SELECT comment_question_id
        FROM notif_comment_q
        WHERE ncq_id = :notif_id))) AS tables;
        ", ['notif_id' => $notif_id]);

        return $obj_id;
    }
}
