-----------------------------------------
-- Drop old schema
-----------------------------------------

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

DROP FUNCTION IF EXISTS new_administrator() CASCADE;
DROP FUNCTION IF EXISTS new_moderator() CASCADE;
DROP FUNCTION IF EXISTS auto_ban() CASCADE;
DROP FUNCTION IF EXISTS same_ban() CASCADE;
DROP FUNCTION IF EXISTS auto_report() CASCADE;
DROP FUNCTION IF EXISTS same_report() CASCADE;
DROP FUNCTION IF EXISTS add_question_vote() CASCADE;
DROP FUNCTION IF EXISTS add_answer_vote() CASCADE;
DROP FUNCTION IF EXISTS remove_question_vote() CASCADE;
DROP FUNCTION IF EXISTS remove_answer_vote() CASCADE;
DROP FUNCTION IF EXISTS follow_created_question() CASCADE;
DROP FUNCTION IF EXISTS best_answer_belongs_to_question() CASCADE;
DROP FUNCTION IF EXISTS notification_new_answer() CASCADE;
DROP FUNCTION IF EXISTS notification_new_comment_in_question() CASCADE;
DROP FUNCTION IF EXISTS notification_new_comment_in_answer() CASCADE;
DROP FUNCTION IF EXISTS notification_new_message() CASCADE;
DROP FUNCTION IF EXISTS delete_account_information() CASCADE;
 
DROP TRIGGER IF EXISTS new_administrator ON administrator;
DROP TRIGGER IF EXISTS new_moderator ON moderator;
DROP TRIGGER IF EXISTS auto_ban ON ban;
DROP TRIGGER IF EXISTS same_ban ON ban;
DROP TRIGGER IF EXISTS auto_report ON report;
DROP TRIGGER IF EXISTS same_report ON report;
DROP TRIGGER IF EXISTS add_question_vote ON vote_q;
DROP TRIGGER IF EXISTS add_answer_vote ON vote_a;
DROP TRIGGER IF EXISTS remove_question_vote ON vote_q;
DROP TRIGGER IF EXISTS remove_answer_vote ON vote_a;
DROP TRIGGER IF EXISTS follow_created_question ON question;
DROP TRIGGER IF EXISTS best_answer_belongs_to_question ON question;
DROP TRIGGER IF EXISTS notification_new_answer ON answer;
DROP TRIGGER IF EXISTS notification_new_comment_in_question ON comment_question;
DROP TRIGGER IF EXISTS notification_new_comment_in_answer ON comment_answer;
DROP TRIGGER IF EXISTS notification_new_message ON message_target;
DROP TRIGGER IF EXISTS delete_account_information ON users;


-----------------------------------------
-- Types
-----------------------------------------

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


-----------------------------------------
-- Tables
-----------------------------------------

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    picture TEXT,
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
    picture TEXT
);

CREATE TABLE favourite (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    media_id INTEGER NOT NULL REFERENCES media(media_id),
    PRIMARY KEY (user_id, media_id)
);


-----------------------------------------
-- INDEXES
-----------------------------------------

CREATE INDEX usernames ON users USING hash (username);

CREATE INDEX user_notification ON notified USING hash (user_id);

CREATE INDEX user_message ON message_target USING hash (user_id);

CREATE INDEX user_followed_question ON follow USING hash (user_id);

CREATE INDEX question_date ON question USING btree (creation_date);

CREATE INDEX notification_date ON notification USING btree (date);

CREATE INDEX message_date ON message USING btree (date);

CREATE INDEX search ON question USING GIST (to_tsvector('english', title || ' '));


-----------------------------------------
-- TRIGGERS and UDFs
-----------------------------------------

CREATE FUNCTION new_administrator() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (SELECT * FROM moderator WHERE NEW.admin_id = moderator_id) THEN
        RAISE EXCEPTION 'This user id is already attributed to a moderator';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER new_administrator
    BEFORE INSERT ON administrator
    FOR EACH ROW
    EXECUTE PROCEDURE new_administrator();


CREATE FUNCTION new_moderator() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (SELECT * FROM administrator WHERE NEW.moderator_id = admin_id) THEN
        RAISE EXCEPTION 'This user id is already attributed to an administrator';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER new_moderator
    BEFORE INSERT ON moderator
    FOR EACH ROW
    EXECUTE PROCEDURE new_moderator();


CREATE FUNCTION auto_ban() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF (NEW.admin_id = NEW.user_id) THEN
        RAISE EXCEPTION 'An administrator cannot ban itself';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER auto_ban
    BEFORE INSERT OR UPDATE ON ban
    FOR EACH ROW
    EXECUTE PROCEDURE auto_ban(); 


CREATE FUNCTION same_ban() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (SELECT * FROM ban WHERE NEW.user_id = user_id) THEN
        RAISE EXCEPTION 'This user has already been banned';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER same_ban
    BEFORE INSERT OR UPDATE ON ban
    FOR EACH ROW
    EXECUTE PROCEDURE same_ban();


CREATE FUNCTION auto_report() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF (NEW.author = NEW.target) THEN
        RAISE EXCEPTION 'An user cannot report itself';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER auto_report
    BEFORE INSERT OR UPDATE ON report
    FOR EACH ROW
    EXECUTE PROCEDURE auto_report(); 


CREATE FUNCTION same_report() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (SELECT * FROM report WHERE NEW.author = author AND NEW.target = target) THEN
        RAISE EXCEPTION 'The targeted user has already been reported by the same user';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER same_report
    BEFORE INSERT OR UPDATE ON report
    FOR EACH ROW
    EXECUTE PROCEDURE same_report();


CREATE FUNCTION add_question_vote() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE question
        SET score = score + NEW.value
        WHERE question_id = NEW.question_id;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER add_question_vote
    AFTER INSERT ON vote_q
    FOR EACH ROW
    EXECUTE PROCEDURE add_question_vote();


CREATE FUNCTION add_answer_vote() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE answer
        SET score = score + NEW.value
        WHERE answer_id = NEW.answer_id;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER add_answer_vote
    AFTER INSERT ON vote_a
    FOR EACH ROW
    EXECUTE PROCEDURE add_answer_vote();


CREATE FUNCTION remove_question_vote() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE question
        SET score = score - OLD.value
        WHERE question_id = NEW.question_id;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER remove_question_vote
    BEFORE DELETE ON vote_q
    FOR EACH ROW
    EXECUTE PROCEDURE remove_question_vote();


CREATE FUNCTION remove_answer_vote() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE answer
        SET score = score - OLD.value
        WHERE answer_id = NEW.answer_id;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER remove_answer_vote
    BEFORE DELETE ON vote_a
    FOR EACH ROW
    EXECUTE PROCEDURE remove_answer_vote();


CREATE FUNCTION follow_created_question() RETURNS TRIGGER AS
$BODY$
BEGIN
    INSERT INTO follow
        VALUES (NEW.author, NEW.question_id);
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER follow_created_question
    AFTER INSERT ON question
    FOR EACH ROW
    EXECUTE PROCEDURE follow_created_question();


CREATE FUNCTION best_answer_belongs_to_question() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF (NEW.best IS DISTINCT FROM OLD.best) THEN
        SELECT question_id AS q_id FROM answer WHERE answer_id = NEW.best;
        IF (q_id IS DISTINCT FROM NEW.question_id) THEN
            RAISE EXCEPTION 'The best answer must belong to the respective question';
        END IF;
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER best_answer_belongs_to_question
    BEFORE UPDATE ON question
    FOR EACH ROW
    EXECUTE PROCEDURE best_answer_belongs_to_question();


CREATE FUNCTION notification_new_answer() RETURNS TRIGGER AS
$BODY$
BEGIN
    INSERT INTO notification DEFAULT VALUES;
    SELECT notification_id AS notif_id FROM notification ORDER BY notification_id DESC LIMIT 1;
    IF EXISTS (SELECT * FROM notif_comment_q WHERE notif_id = ncq_id UNION
                SELECT * FROM notif_comment_ans WHERE notif_id = nca_id UNION
                SELECT * FROM notif_new_msg WHERE notif_id = nnm_id) THEN
        RAISE EXCEPTION 'This notification id is already on use on another kind of notification';
    END IF;
    INSERT INTO notif_new_ans
        VALUES (notif_id, NEW.answer_id);
    SELECT question.author AS author_id FROM question, answer
        WHERE question.question_id = answer.question_id AND NEW.answer_id = answer_id;
    INSERT INTO notified (user_id, notification_id)
        VALUES (author_id, notif_id);
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER notification_new_answer
    AFTER INSERT ON answer
    FOR EACH ROW
    EXECUTE PROCEDURE notification_new_answer();


CREATE FUNCTION notification_new_comment_in_question() RETURNS TRIGGER AS
$BODY$
BEGIN
    INSERT INTO notification DEFAULT VALUES;
    SELECT notification_id AS notif_id FROM notification ORDER BY notification_id DESC LIMIT 1;
    IF EXISTS (SELECT * FROM notif_new_ans WHERE notif_id = nna_id UNION
                SELECT * FROM notif_comment_ans WHERE notif_id = nca_id UNION
                SELECT * FROM notif_new_msg WHERE notif_id = nnm_id) THEN
        RAISE EXCEPTION 'This notification id is already on use on another kind of notification';
    END IF;
    INSERT INTO notif_comment_q
        VALUES (notif_id, NEW.cq_id);
    SELECT question.author AS author_id FROM question, comment_question
        WHERE question.question_id = comment_question.question_id AND NEW.cq_id = cq_id;
    INSERT INTO notified (user_id, notification_id)
        VALUES (author_id, notif_id);
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER notification_new_comment_in_question
    AFTER INSERT ON comment_question
    FOR EACH ROW
    EXECUTE PROCEDURE notification_new_comment_in_question();


CREATE FUNCTION notification_new_comment_in_answer() RETURNS TRIGGER AS
$BODY$
BEGIN
    INSERT INTO notification DEFAULT VALUES;
    SELECT notification_id AS notif_id FROM notification ORDER BY notification_id DESC LIMIT 1;
    IF EXISTS (SELECT * FROM notif_new_ans WHERE notif_id = nna_id UNION
                SELECT * FROM notif_comment_q WHERE notif_id = ncq_id UNION
                SELECT * FROM notif_new_msg WHERE notif_id = nnm_id) THEN
        RAISE EXCEPTION 'This notification id is already on use on another kind of notification';
    END IF;
    INSERT INTO notif_comment_ans
        VALUES (notif_id, NEW.ca_id);
    SELECT answer.author AS author_id FROM answer, comment_answer
        WHERE answer.answer_id = comment_answer.answer_id AND NEW.ca_id = ca_id;
    INSERT INTO notified (user_id, notification_id)
        VALUES (author_id, notif_id);
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER notification_new_comment_in_answer
    AFTER INSERT ON comment_answer
    FOR EACH ROW
    EXECUTE PROCEDURE notification_new_comment_in_answer();


CREATE FUNCTION notification_new_message() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF NOT EXISTS (SELECT nnm_id AS notif_id FROM notif_new_msg WHERE NEW.message_id = message_id) THEN
        INSERT INTO notification DEFAULT VALUES;
        SELECT notification_id AS notif_id FROM notification ORDER BY notification_id DESC LIMIT 1;
        IF EXISTS (SELECT * FROM notif_new_ans WHERE notif_id = nna_id UNION
                SELECT * FROM notif_comment_q WHERE notif_id = ncq_id UNION
                SELECT * FROM notif_comment_ans WHERE notif_id = nca_id) THEN
            RAISE EXCEPTION 'This notification id is already on use on another kind of notification';
        END IF;
        INSERT INTO notif_new_msg
            VALUES (notif_id, NEW.message_id);
    END IF;
    INSERT INTO notified (user_id, notification_id)
        VALUES (NEW.user_id, notif_id);
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER notification_new_message
    AFTER INSERT ON message_target
    FOR EACH ROW
    EXECUTE PROCEDURE notification_new_message();


CREATE FUNCTION delete_account_information() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF (NEW.is_deleted = 'true' AND NOT EXISTS (SELECT * FROM ban WHERE NEW.user_id = user_id)) THEN
        UPDATE users
            SET username = to_char(OLD.user_id,'FM99999MI'),
                email = to_char(OLD.user_id,'FM99999MI"@lcq.com"'),
                password = to_char(OLD.user_id,'FM99999MI'),
                picture = NULL,
                description = NULL
            WHERE user_id = NEW.user_id;
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER delete_account_information
    AFTER UPDATE ON users
    FOR EACH ROW
    EXECUTE PROCEDURE delete_account_information();

-----------------------------------------
-- end
-----------------------------------------