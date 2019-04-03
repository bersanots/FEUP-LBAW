DROP TYPE IF EXISTS media_types CASCADE;
DROP TYPE IF EXISTS medal_types CASCADE;

DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS moderator CASCADE;
DROP TABLE IF EXISTS administrator CASCADE;
DROP TABLE IF EXISTS ban CASCADE;
DROP TABLE IF EXISTS report CASCADE;
DROP TABLE IF EXISTS question CASCADE;
DROP TABLE IF EXISTS answer CASCADE;
DROP TABLE IF EXISTS comment_question CASCADE;
DROP TABLE IF EXISTS comment_answer CASCADE;
DROP TABLE IF EXISTS vote_q CASCADE;
DROP TABLE IF EXISTS vote_a CASCADE;
DROP TABLE IF EXISTS follow CASCADE;
DROP TABLE IF EXISTS tag CASCADE;
DROP TABLE IF EXISTS tag_question CASCADE;
DROP TABLE IF EXISTS medal CASCADE;
DROP TABLE IF EXISTS achievement CASCADE;
DROP TABLE IF EXISTS message CASCADE;
DROP TABLE IF EXISTS message_target CASCADE;
DROP TABLE IF EXISTS notification CASCADE;
DROP TABLE IF EXISTS notified CASCADE;
DROP TABLE IF EXISTS notif_new_msg CASCADE;
DROP TABLE IF EXISTS notif_new_ans CASCADE;
DROP TABLE IF EXISTS notif_comment_ans CASCADE;
DROP TABLE IF EXISTS notif_comment_q CASCADE;
DROP TABLE IF EXISTS media CASCADE;
DROP TABLE IF EXISTS favourite CASCADE;

CREATE TYPE media_types AS ENUM(
    'film',
    'series',
    'animation'
);

CREATE TYPE medal_types AS ENUM(
    'best_answers',
    'top_answerer',
    'quick_answerer',
    'question_master',
    'regular_questioner'
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    picture PATH,
    description TEXT,
    joined_date DATE DEFAULT now(), 
    is_deleted BOOLEAN DEFAULT false
);

CREATE TABLE moderator (
    moderator_id INTEGER NOT NULL REFERENCES users(user_id),
    PRIMARY KEY (moderator_id)
);

CREATE TABLE administrator (
    administrator_id INTEGER NOT NULL REFERENCES users(user_id),
    PRIMARY KEY (administrator_id)
);

CREATE TABLE ban (
    ban_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL, 
    date DATE DEFAULT now(),
    admin_id INTEGER NOT NULL REFERENCES administrator(administrator_id),
    user_id INTEGER NOT NULL REFERENCES users(user_id)
);

CREATE TABLE report (
    report_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL, 
    date DATE DEFAULT now(),
    author INTEGER NOT NULL REFERENCES users(user_id),
    target INTEGER NOT NULL REFERENCES users(user_id)
);

CREATE TABLE question (
    question_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    creation_date DATE DEFAULT now(), 
    score INTEGER DEFAULT 0,
    category media_types NOT NULL,
    author INTEGER NOT NULL REFERENCES users(user_id)
);

CREATE TABLE answer (
    answer_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    creation_date DATE DEFAULT now(),
    score INTEGER DEFAULT 0,
    question_id INTEGER NOT NULL REFERENCES question(question_id),
    author INTEGER NOT NULL REFERENCES users(user_id)
);

ALTER TABLE question ADD COLUMN best INTEGER REFERENCES answer(answer_id);

CREATE TABLE comment_question (
    cq_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    creation_date DATE DEFAULT now(),
    question_id INTEGER NOT NULL REFERENCES question(question_id),
    author INTEGER NOT NULL REFERENCES users(user_id)
);

CREATE TABLE comment_answer (
    ca_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    creation_date DATE DEFAULT now(),
    answer_id INTEGER NOT NULL REFERENCES answer(answer_id), 
    author INTEGER NOT NULL REFERENCES users(user_id)
);

CREATE TABLE vote_q (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    question_id INTEGER NOT NULL REFERENCES question(question_id),
    value INTEGER NOT NULL CONSTRAINT value_ck CHECK ((value = 1 ) OR (value = -1)),
    date DATE DEFAULT now(),
    PRIMARY KEY (user_id, question_id)
);

CREATE TABLE vote_a (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    answer_id INTEGER NOT NULL REFERENCES answer(answer_id),
    value INTEGER NOT NULL CONSTRAINT value_ck CHECK ((value = 1 ) OR (value = -1)),
    date DATE DEFAULT now(),
    PRIMARY KEY (user_id, answer_id)
);

CREATE TABLE follow (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    question_id INTEGER NOT NULL REFERENCES question(question_id),
    PRIMARY KEY (user_id, question_id)
);

CREATE TABLE tag (
    tag_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE tag_question (
    tag_id INTEGER NOT NULL REFERENCES tag(tag_id),
    question_id INTEGER NOT NULL REFERENCES question(question_id),
    PRIMARY KEY (tag_id, question_id)
);

CREATE TABLE medal ( 
    medal_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL UNIQUE,
    name medal_types NOT NULL UNIQUE
);

CREATE TABLE achievement (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    medal_id INTEGER NOT NULL REFERENCES medal(medal_id),
    date DATE DEFAULT now(),
    PRIMARY KEY (user_id, medal_id)
);

CREATE TABLE message ( 
    message_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    date DATE DEFAULT now(),
    author INTEGER NOT NULL REFERENCES users(user_id)
);

CREATE TABLE message_target (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    message_id INTEGER NOT NULL REFERENCES message(message_id),
    PRIMARY KEY (user_id, message_id)
);

CREATE TABLE notification (
    notification_id SERIAL PRIMARY KEY,
    date DATE DEFAULT now()
);

CREATE TABLE notified (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    notification_id INTEGER NOT NULL REFERENCES notification(notification_id),
    has_seen BOOLEAN DEFAULT false,
    PRIMARY KEY (user_id, notification_id)
);

CREATE TABLE notif_new_msg (
    nnm_id INTEGER NOT NULL REFERENCES notification(notification_id),
    date DATE DEFAULT now(),
    message_id INTEGER NOT NULL REFERENCES message(message_id),
    PRIMARY KEY (nnm_id)
);

CREATE TABLE notif_new_ans (
    nna_id INTEGER NOT NULL REFERENCES notification(notification_id),
    date DATE DEFAULT now(),
    answer_id INTEGER NOT NULL REFERENCES answer(answer_id),
    PRIMARY KEY (nna_id)
);

CREATE TABLE notif_comment_ans (
    nca_id INTEGER NOT NULL REFERENCES notification(notification_id),
    date DATE DEFAULT now(),
    comment_answer_id INTEGER NOT NULL REFERENCES comment_answer(ca_id),
    PRIMARY KEY (nca_id)
);

CREATE TABLE notif_comment_q (
    ncq_id INTEGER NOT NULL REFERENCES notification(notification_id),
    date DATE DEFAULT now(),
    comment_question_id INTEGER NOT NULL REFERENCES comment_question(cq_id),
    PRIMARY KEY (ncq_id)
);

CREATE TABLE media (
    media_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL UNIQUE,
    category media_types NOT NULL,
    release DATE NOT NULL,
    picture PATH
);

CREATE TABLE favourite (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    media_id INTEGER NOT NULL REFERENCES media(media_id),
    PRIMARY KEY (user_id, media_id)
);

