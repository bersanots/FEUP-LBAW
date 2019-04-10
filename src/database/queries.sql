-- User's profile
SELECT username, email, picture, description, joined_date
  FROM users
  WHERE users.user_id = $user_id;

-- User's favourite media
SELECT title, category, media.picture
  FROM favourite, media
  WHERE $user_id = favourite.user_id AND media.media_id = favourite.media_id;

-- User's notifications
SELECT date, has_seen
  FROM notification, notified
  WHERE $user_id = notified.user_id AND notification.notification_id = notified.notification_id;

-- User's message inbox
SELECT title, content, date, author
  FROM message, message_target
  WHERE $user_id = user_id AND message.message_id = message_target.message_id;

-- User's medals
SELECT name, description, date
  FROM medal, achievement
  WHERE $user_id = user_id AND medal.medal_id = achievement.medal_id;

-- Search with filter
SELECT title, creation_date, score, username, ts_rank_cd(textsearch, query) AS rank
  FROM question, users, to_tsquery($search) AS query, to_tsvector('english', title || ' ') AS textsearch
  WHERE question.author = users.user_id AND query @@ textsearch ORDER BY rank DESC;

-- Questions list by category
SELECT title, score, username
  FROM question, users
  WHERE question.author = users.user_id AND category = $category;

-- User's followed questions
SELECT title, score, username
  FROM follow, question, users
  WHERE $user_id = follow.user_id AND question.question_id = follow.question_id AND question.author = users.user_id;

-- Question's page
SELECT title, question.description, creation_date, score, category, username, best
  FROM question, users
  WHERE question.author = users.user_id AND question_id = $question_id;

SELECT answer.description, creation_date, score, username
  FROM answer, users
  WHERE answer.author = users.user_id AND question_id = $question_id;

SELECT comment_question.description, creation_date, username
  FROM comment_question, users
  WHERE comment_question.author = users.user_id AND question_id = $question_id;

SELECT comment_answer.description, creation_date, username
  FROM comment_answer, users
  WHERE comment_answer.author = users.user_id AND answer_id = $answer_id;
