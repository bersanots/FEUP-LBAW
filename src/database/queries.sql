-- User's profile
SELECT username, email, picture, description, joined_date
  FROM users
  WHERE users.user_id = $user_id;

-- User's favourite media
SELECT title, category, media.picture
  FROM users, favourite, media
  WHERE users.user_id = favourite.user_id AND media.media_id = favourite.media_id AND users.user_id = $user_id;

SELECT title, ts_rank_cd(textsearch, query) AS rank
  FROM media, to_tsquery('Wind') AS query, to_tsvector(title || ' ') AS textsearch
  WHERE query @@ textsearch ORDER BY rank DESC;

-- Search with filter
SELECT title, creation_date, score, author, ts_rank_cd(textsearch, query) AS rank
  FROM question, to_tsquery($search) AS query, to_tsvector(title || ' ') AS textsearch
  WHERE query @@ textsearch ORDER BY rank DESC;

-- Question's page
SELECT title, description, creation_date, score, author, best
  FROM question
  WHERE question.question_id = $

