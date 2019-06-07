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
DROP FUNCTION IF EXISTS auto_report() CASCADE;
DROP FUNCTION IF EXISTS same_report() CASCADE;
DROP FUNCTION IF EXISTS update_question_score() CASCADE;
DROP FUNCTION IF EXISTS update_answer_score() CASCADE;
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
DROP TRIGGER IF EXISTS auto_report ON report;
DROP TRIGGER IF EXISTS same_report ON report;
DROP TRIGGER IF EXISTS update_question_score ON vote_q;
DROP TRIGGER IF EXISTS update_answer_score ON vote_a;
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
    joined_date TIMESTAMP DEFAULT now(), 
    is_deleted BOOLEAN DEFAULT false,
    remember_token TEXT DEFAULT false
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
    start_date TIMESTAMP DEFAULT now(),
    end_date TIMESTAMP,
    admin_id INTEGER NOT NULL REFERENCES administrator(administrator_id),
    user_id INTEGER NOT NULL UNIQUE REFERENCES users(user_id)
);

CREATE TABLE report (
    report_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL, 
    date TIMESTAMP DEFAULT now(),
    resolved BOOLEAN DEFAULT false,
    author INTEGER NOT NULL REFERENCES users(user_id),
    target INTEGER NOT NULL REFERENCES users(user_id)
);

CREATE TABLE question (
    question_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    creation_date TIMESTAMP DEFAULT now(), 
    score INTEGER DEFAULT 0,
    category media_types NOT NULL,
    author INTEGER NOT NULL REFERENCES users(user_id)
);

CREATE TABLE answer (
    answer_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    creation_date TIMESTAMP DEFAULT now(),
    score INTEGER DEFAULT 0,
    question_id INTEGER NOT NULL REFERENCES question(question_id),
    author INTEGER NOT NULL REFERENCES users(user_id)
);

ALTER TABLE question ADD COLUMN best INTEGER REFERENCES answer(answer_id);

CREATE TABLE comment_question (
    cq_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    creation_date TIMESTAMP DEFAULT now(),
    question_id INTEGER NOT NULL REFERENCES question(question_id),
    author INTEGER NOT NULL REFERENCES users(user_id)
);

CREATE TABLE comment_answer (
    ca_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    creation_date TIMESTAMP DEFAULT now(),
    answer_id INTEGER NOT NULL REFERENCES answer(answer_id), 
    author INTEGER NOT NULL REFERENCES users(user_id)
);

CREATE TABLE vote_q (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    question_id INTEGER NOT NULL REFERENCES question(question_id),
    value INTEGER NOT NULL CONSTRAINT value_ck CHECK ((value = 1 ) OR (value = -1)),
    date TIMESTAMP DEFAULT now(),
    PRIMARY KEY (user_id, question_id)
);

CREATE TABLE vote_a (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    answer_id INTEGER NOT NULL REFERENCES answer(answer_id),
    value INTEGER NOT NULL CONSTRAINT value_ck CHECK ((value = 1 ) OR (value = -1)),
    date TIMESTAMP DEFAULT now(),
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
    date TIMESTAMP DEFAULT now(),
    PRIMARY KEY (user_id, medal_id)
);

CREATE TABLE message ( 
    message_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    date TIMESTAMP DEFAULT now(),
    author INTEGER NOT NULL REFERENCES users(user_id)
);

CREATE TABLE message_target (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    message_id INTEGER NOT NULL REFERENCES message(message_id),
    PRIMARY KEY (user_id, message_id)
);

CREATE TABLE notification (
    notification_id SERIAL PRIMARY KEY,
    date TIMESTAMP DEFAULT now()
);

CREATE TABLE notified (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    notification_id INTEGER NOT NULL REFERENCES notification(notification_id),
    has_seen BOOLEAN DEFAULT false,
    PRIMARY KEY (user_id, notification_id)
);

CREATE TABLE notif_new_msg (
    nnm_id INTEGER NOT NULL REFERENCES notification(notification_id),
    date TIMESTAMP DEFAULT now(),
    message_id INTEGER NOT NULL REFERENCES message(message_id),
    PRIMARY KEY (nnm_id)
);

CREATE TABLE notif_new_ans (
    nna_id INTEGER NOT NULL REFERENCES notification(notification_id),
    date TIMESTAMP DEFAULT now(),
    answer_id INTEGER NOT NULL REFERENCES answer(answer_id),
    PRIMARY KEY (nna_id)
);

CREATE TABLE notif_comment_ans (
    nca_id INTEGER NOT NULL REFERENCES notification(notification_id),
    date TIMESTAMP DEFAULT now(),
    comment_answer_id INTEGER NOT NULL REFERENCES comment_answer(ca_id),
    PRIMARY KEY (nca_id)
);

CREATE TABLE notif_comment_q (
    ncq_id INTEGER NOT NULL REFERENCES notification(notification_id),
    date TIMESTAMP DEFAULT now(),
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

CREATE INDEX search_question ON question USING GIST (setweight(to_tsvector('english', title || ' ' || description), 'A'));

CREATE INDEX search_answer ON answer USING GIST (setweight(to_tsvector('english', description), 'B'));


CLUSTER question USING question_date;

CLUSTER notification USING notification_date;

CLUSTER message USING message_date;


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


CREATE FUNCTION update_question_score() RETURNS TRIGGER AS
$BODY$
DECLARE
  total INTEGER;
  q_id INTEGER;
BEGIN
  IF TG_OP = 'DELETE' THEN
        q_id = OLD.question_id;     --Delete operation
    ELSE
        q_id = NEW.question_id;     --Insert operation
    END IF;
    SELECT SUM (value) INTO total
        FROM vote_q
        WHERE question_id = q_id;
    IF total IS NULL THEN
        UPDATE question
        SET score = 0
        WHERE question_id = q_id;
    ELSE
        UPDATE answer
        SET score = total
        WHERE question_id = q_id;
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER update_question_score
    AFTER INSERT OR DELETE OR UPDATE ON vote_q
    FOR EACH ROW
    EXECUTE PROCEDURE update_question_score();


CREATE FUNCTION update_answer_score() RETURNS TRIGGER AS
$BODY$
DECLARE
  total INTEGER;
  a_id INTEGER;
BEGIN
  IF TG_OP = 'DELETE' THEN
        a_id = OLD.answer_id;     --Delete operation
    ELSE
        a_id = NEW.answer_id;     --Insert operation
    END IF;
    SELECT SUM (value) INTO total
        FROM vote_a
        WHERE answer_id = a_id;
    IF total IS NULL THEN
        UPDATE answer
        SET score = 0
        WHERE answer_id = a_id;
    ELSE
        UPDATE answer
        SET score = total
        WHERE answer_id = a_id;
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER update_answer_score
    AFTER INSERT OR DELETE OR UPDATE ON vote_a
    FOR EACH ROW
    EXECUTE PROCEDURE update_answer_score();


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
DECLARE
  q_id INTEGER;
BEGIN
    IF (NEW.best IS DISTINCT FROM OLD.best) THEN
        SELECT question_id INTO q_id FROM answer WHERE answer_id = NEW.best;
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
DECLARE
  notif_id INTEGER;
  author_id INTEGER;
BEGIN
    INSERT INTO notification DEFAULT VALUES RETURNING notification_id INTO notif_id;
    IF EXISTS (SELECT * FROM notif_comment_q WHERE notif_id = ncq_id UNION
                SELECT * FROM notif_comment_ans WHERE notif_id = nca_id UNION
                SELECT * FROM notif_new_msg WHERE notif_id = nnm_id) THEN
        RAISE EXCEPTION 'This notification id is already on use on another kind of notification';
    END IF;
    INSERT INTO notif_new_ans(nna_id,answer_id)
        VALUES (notif_id, NEW.answer_id);
    SELECT question.author INTO author_id FROM question, answer
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
DECLARE
  notif_id INTEGER;
  author_id INTEGER;
BEGIN
    INSERT INTO notification DEFAULT VALUES RETURNING notification_id INTO notif_id;
    IF EXISTS (SELECT * FROM notif_new_ans WHERE notif_id = nna_id UNION
                SELECT * FROM notif_comment_ans WHERE notif_id = nca_id UNION
                SELECT * FROM notif_new_msg WHERE notif_id = nnm_id) THEN
        RAISE EXCEPTION 'This notification id is already on use on another kind of notification';
    END IF;
    INSERT INTO notif_comment_q(ncq_id,comment_question_id)
        VALUES (notif_id, NEW.cq_id);
    SELECT question.author INTO author_id FROM question, comment_question
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
DECLARE
  notif_id INTEGER;
  author_id INTEGER;
BEGIN
    INSERT INTO notification DEFAULT VALUES RETURNING notification_id INTO notif_id;
    IF EXISTS (SELECT * FROM notif_new_ans WHERE notif_id = nna_id UNION
                SELECT * FROM notif_comment_q WHERE notif_id = ncq_id UNION
                SELECT * FROM notif_new_msg WHERE notif_id = nnm_id) THEN
        RAISE EXCEPTION 'This notification id is already on use on another kind of notification';
    END IF;
    INSERT INTO notif_comment_ans(nca_id,comment_answer_id)
        VALUES (notif_id, NEW.ca_id);
    SELECT answer.author INTO author_id FROM answer, comment_answer
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
DECLARE
  notif_id INTEGER;
BEGIN
    SELECT nnm_id INTO notif_id FROM notif_new_msg WHERE NEW.message_id = message_id;
    IF notif_id IS NULL THEN
        INSERT INTO notification DEFAULT VALUES RETURNING notification_id INTO notif_id;
        IF EXISTS (SELECT * FROM notif_new_ans WHERE notif_id = nna_id UNION
                SELECT * FROM notif_comment_q WHERE notif_id = ncq_id UNION
                SELECT * FROM notif_comment_ans WHERE notif_id = nca_id) THEN
            RAISE EXCEPTION 'This notification id is already on use on another kind of notification';
        END IF;
        INSERT INTO notif_new_msg(nnm_id,message_id)
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

-----------------------------------------
-- Populate the database
-----------------------------------------

-- users
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Maggy','quis.pede@gmail.com','SUF90BEM6SM','pictures/QKE39KVM1LY.jpg','Love means never having to say you are sorry.','2018-08-08 07:27:21','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Logan','justo@hotmail.com','QYX88TWK8MK','pictures/BLC65XKX3XG.jpg','They may take our lives, but they will never take our freedom!','2018-10-21 23:40:35','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Stacey','et.netus.et@yahoo.com','YSC05CYD7FK','pictures/WLU69XRP9FA.jpg','They call me Mister Tibbs!','2019-04-02 01:08:37','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Damon','nunc.sed.orci@amazon.com','AZS78CJW9EV','pictures/TQR34RUC6UJ.jpg','When you realize you want to spend the rest of your life with somebody, you want the rest of your life to start as soon as possible.','2018-04-22 03:05:52','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Gil','phasellus.fermentum.convallis@gmail.com','EOR38FPN7TO','pictures/PCJ06CGN1UZ.jpg','If you let my daughter go now, that will be the end of it. I will not look for you, I will not pursue you. But if you do not, I will look for you, I will find you, and I will kill you.,','2018-05-11 06:45:50','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Kadeem','semper.erat.in@hotmail.com','OUZ97CSU6YD','pictures/BNQ96REF1KJ.jpg','You complete me.','2018-08-28 00:15:52','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Justina','elit@yahoo.com','RMS24NDH8CU','pictures/UCN19GGZ0LN.png','My name is Maximus Decimus Meridius, commander of the Armies of the North, General of the Felix Legions and loyal servant to the true emperor, Marcus Aurelius. Father to a murdered son, husband to a murdered wife. And I will have my vengeance, in this life or the next.','2018-12-10 21:58:42','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Akeem','magna@amazon.com','SQA08UWO4OB','pictures/FCL13ZMV7IM.jpg','I drink your milkshake!','2019-01-29 16:53:50','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Sybill','suscipit@gmail.com','YHA24URB5RY','pictures/EHC09KUZ8BS.png','Get your stinking paws off me, you damned dirty ape!','2018-11-21 17:47:21','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Ivy','auctor@gmail.com','TKP71LUK3NO','pictures/LAM50CFN5EF.jpg','You make me want to be a better man.','2018-06-07 23:27:47','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Ronan','lobortis.augue.scelerisque@hotmail.com','WIT17MHW3XX','pictures/LAM50CFN5EF.jpg','Bond. James Bond.','2018-08-02 18:49:07','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Alana','fermentum.vel.mauris@yahoo.com','RDW60FUH3WK','pictures/EHC09KUZ8BS.png','Chewie, we are home.','2018-10-21 23:31:27','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Marshall','nulla.ante.iaculis@amazon.com','JEJ95OYP5UO','pictures/LLV96WOR3EV.png','Forget it, Jake. It is Chinatown.','2019-02-21 19:28:54','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Cherokee','et.ultrices.posuere@yahoo.com','NRZ57EJQ7HW','pictures/TQR34RUC6UJ.jpg','It was Beauty killed the Beast.','2018-04-20 23:21:17','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Mechelle','ut@gmail.com','ATT68HSP7SH','pictures/PCJ06CGN1UZ.jpg','Why so serious?','2018-05-26 10:30:52','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Hadassah','tellus.faucibus.leo@gmail.com','UIA27LHE7VF','pictures/PCJ06CGN1UZ.jpg','I am just one stomach flu away from my goal weight.','2018-09-29 21:36:18','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Josiah','est.mollis@amazon.com','AXN63OCS7TN','pictures/PCJ06CGN1UZ.jpg','I am your father.','2018-10-29 00:52:30','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Vera','arcu.et.pede@yahoo.com','LZD23BGL6EM','pictures/PCJ06CGN1UZ.jpg','They call it a Royale with cheese.','2019-01-12 01:27:19','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Charles','nam@amazon.com','DPG31RKQ6FN','pictures/BLC65XKX3XG.jpg','Magic Mirror on the wall, who is the fairest one of all?','2018-06-29 17:03:49','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Thomas','erat@gmail.com','UHF78UBY0VS','pictures/BLC65XKX3XG.jpg','Just when I thought I was out, they pull me back in.','2019-02-27 11:33:35','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Aurora','commodo.ipsum.suspendisse@hotmail.com','IGL76BEO8YF','pictures/BLC65XKX3XG.jpg','I will be back.','2019-02-19 17:30:39','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Arthur','elit.etiam.laoreet@amazon.com','RLG65MBF0CD','pictures/BLC65XKX3XG.jpg','The first rule of Fight Club is: You do not talk about Fight Club.','2019-01-01 01:30:47','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Myles','lobortis.ultrices@yahoo.com','YEK87SYV8ET','pictures/UCN19GGZ0LN.png','Wax on, wax off.','2018-11-20 23:08:33','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Wang','aliquam.vulputate@hotmail.com','LLI12AOR8EV','pictures/UCN19GGZ0LN.png','Gentlemen, you cannot fight in here! This is the war room!','2018-08-28 18:48:54','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Dylan','lorem.semper@gmail.com','EOT13ZHI8MT','pictures/UCN19GGZ0LN.png','I do not want to survive. I want to live.','2019-03-22 03:15:39','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Lilah','aliquet.sem@hotmail.com','ZHZ60UDP4BE','pictures/UCN19GGZ0LN.png','You are gonna need a bigger boat.','2018-04-20 00:52:24','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Sonya','velit.quisque.varius@amazon.com','SAA23RGU6EV','pictures/UCN19GGZ0LN.png','May the Force be with you.','2018-12-26 07:11:38','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Valentine','lacus.quisque@yahoo.com','LSL26JJO7SS','pictures/UCN19GGZ0LN.png','Toto, I have a feeling we are not in Kansas anymore.','2019-02-01 16:20:17','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('Charity','nec@hotmail.com','VCY24NJT4WY','pictures/UCN19GGZ0LN.png','I am going to make him an offer he cannot refuse.','2019-03-06 12:57:55','false');
INSERT INTO users (username,email,password,picture,description,joined_date,is_deleted) VALUES ('user','user@name.com','$2y$10$/6re1d8fAxQIF0m5iz4VAefMtaK3L04pJZsK5RkDyOG9gQSkOb4Oy','pictures/LLV96WOR3EV.png','You talkin to me?','2018-05-14 17:15:11','false');

--media
INSERT INTO media (title, category, release, picture) VALUES ('Gone With the Wind','film','1943-09-20 00:00:00','pictures/gone_with_the_wind.png');
INSERT INTO media (title, category, release, picture) VALUES ('Casablanca','film','1945-05-17 00:00:00','pictures/casablanca.png');
INSERT INTO media (title, category, release, picture) VALUES ('Jaws','film','1977-03-25 00:00:00','pictures/jaws.png');
INSERT INTO media (title, category, release, picture) VALUES ('Star Wars: A New Hope','film','1977-12-06 00:00:00','pictures/new_hope.png');
INSERT INTO media (title, category, release, picture) VALUES ('12 Years a Slave','film','2014-01-02 00:00:00','pictures/12_years_a_slave.png');
INSERT INTO media (title, category, release, picture) VALUES ('The Office','series','2005-03-24 00:00:00','pictures/the_office.png');
INSERT INTO media (title, category, release, picture) VALUES ('Friends','series','1994-09-22 00:00:00','pictures/friends.png');
INSERT INTO media (title, category, release, picture) VALUES ('Seinfeld','series','1989-07-05 00:00:00','pictures/seinfeld.png');
INSERT INTO media (title, category, release, picture) VALUES ('Avatar: The Last Airbender','animation','2005-02-21 00:00:00','pictures/avatar_the_last_airbender.png');
INSERT INTO media (title, category, release, picture) VALUES ('The Simpsons','animation','1989-12-17 00:00:00','pictures/the_simpsons.png');


--favourite
INSERT INTO favourite (user_id, media_id) VALUES (1,1);
INSERT INTO favourite (user_id, media_id) VALUES (1,2);
INSERT INTO favourite (user_id, media_id) VALUES (1,4);
INSERT INTO favourite (user_id, media_id) VALUES (3,7);
INSERT INTO favourite (user_id, media_id) VALUES (3,8);
INSERT INTO favourite (user_id, media_id) VALUES (6,9);
INSERT INTO favourite (user_id, media_id) VALUES (10,1);
INSERT INTO favourite (user_id, media_id) VALUES (10,2);
INSERT INTO favourite (user_id, media_id) VALUES (10,5);
INSERT INTO favourite (user_id, media_id) VALUES (10,6);
INSERT INTO favourite (user_id, media_id) VALUES (10,7);
INSERT INTO favourite (user_id, media_id) VALUES (10,10);
INSERT INTO favourite (user_id, media_id) VALUES (14,6);
INSERT INTO favourite (user_id, media_id) VALUES (14,7);
INSERT INTO favourite (user_id, media_id) VALUES (15,3);
INSERT INTO favourite (user_id, media_id) VALUES (15,4);
INSERT INTO favourite (user_id, media_id) VALUES (15,5);
INSERT INTO favourite (user_id, media_id) VALUES (15,7);
INSERT INTO favourite (user_id, media_id) VALUES (20,1);
INSERT INTO favourite (user_id, media_id) VALUES (22,1);
INSERT INTO favourite (user_id, media_id) VALUES (22,10);
INSERT INTO favourite (user_id, media_id) VALUES (24,2);
INSERT INTO favourite (user_id, media_id) VALUES (24,4);
INSERT INTO favourite (user_id, media_id) VALUES (24,6);
INSERT INTO favourite (user_id, media_id) VALUES (26,7);
INSERT INTO favourite (user_id, media_id) VALUES (26,8);
INSERT INTO favourite (user_id, media_id) VALUES (26,10);
INSERT INTO favourite (user_id, media_id) VALUES (28,3);
INSERT INTO favourite (user_id, media_id) VALUES (28,5);
INSERT INTO favourite (user_id, media_id) VALUES (28,10);


-- questions & answers & comments
INSERT INTO question (title, description, creation_date, score, category, author) VALUES ('Was a deal made with Warner Bros so that Peter Porker can do the things he does?', 'In the movie Spider-Man: Into the Spider-Verse there is this spider-man character called Peter Porker, who is an alternate funny cartoon version of Spider-Man. He does things and says things closely to what the Looney Tunes cartoon character Porky Pig does and says.
Was a deal made with Warner Bros so that Peter Porker can do the things he does? If so, what kind of deal?', '2019-01-01 01:30:47', 130, 'animation', 24);
INSERT INTO question (title, description, creation_date, score, category, author) VALUES ('Is Shazam''s look, Billy Batson''s future look?', 'I know this
is a very late kind of question but I am curious to know that why Shazam had to be an adult-like character in looks(face + body). Is Shazam''s look, Billy Batson''s future look? I mean would Billy grow up to become a person who looks like(now) Shazam?', '2019-04-05 01:30:47', 450, 'film', 13);
INSERT INTO question (title, description, creation_date, score, category, author) VALUES ('What is the current canonical age of Sansa, Bran and Arya Stark?', 'As we know, the ages of the characters on Game of Thrones can be very different from both the corresponding age in the books and the present age of the actors portraying them. Moreover, we don''t really know exactly how much time has passed since the events of season 1. (This question shows that the speculated time is one year per season, but that''s not definitive.)
Now, ignoring Jon Snow''s parentage for the moment, there are three trueborn Stark children currently in Winterfell: Sansa, Arya and Bran. My question is, what is their current age according to the show''s canon as per the latest episode (S07E07).
(An approximation or an educated guess will do if the explicit age is not known. I remember Sansa telling Tyrion her age back when she was at King''s Landing, but I don''t remember the episode.) It would also be interesting to know how old Robb Stark was when he was declared King in the North.', '2019-04-05 01:30:47', 10, 'series', 5);

INSERT INTO answer (description, creation_date, score, question_id, author) VALUES ('But this is a visual trademark which means you can not replicate that sentence in that font on wearable merchandise.', '2019-05-04 08:30:00', 30, 1, 28);
INSERT INTO answer (description, creation_date, score, question_id, author) VALUES ('Shazam is a adult muscular man because of the magical powers he have, mostly from Herculese and Appolo
(from the powers he inherit when becoming Shazam), AFAIK we don''t know how Billy will looks like when he grown up, nor probably we''ll see it in DCEU', '2019-01-01 08:30:00', 5, 2, 30);
INSERT INTO answer (description, creation_date, score, question_id, author) VALUES ('Sansa was 14 when she was married to Tyrion. I think her age gets brought up a couple of times during the back half of season 3.', '2019-04-05 09:30:00', 5, 3, 3);
INSERT INTO answer (description, creation_date, score, question_id, author) VALUES ('Copyright issues are a thing', '2019-05-04 08:30:00', 30, 1, 28);

UPDATE question SET best = 1 WHERE question_id = 1;
UPDATE question SET best = 2 WHERE question_id = 2;
UPDATE question SET best = 3 WHERE question_id = 3;

INSERT INTO comment_question (description, creation_date, question_id, author) VALUES ('I wish i knew too', '2019-04-05 01:37:33', 3, 17);
INSERT INTO comment_question (description, creation_date, question_id, author) VALUES ('Why care about Sansa''s age?', '2019-04-05 03:37:33', 3, 8);

INSERT INTO comment_answer (description, creation_date, answer_id, author) VALUES ('Very Greek mythologie based', '2019-01-01 10:07:01', 2, 19);
INSERT INTO comment_answer (description, creation_date, answer_id, author) VALUES ('I agree', '2019-05-04 08:55:47', 1, 4);


--votes
INSERT INTO vote_q(user_id, question_id, value, date) VALUES (30, 1, 1, '2019-01-01 01:30:47');
INSERT INTO vote_q(user_id, question_id, value, date) VALUES (5, 1, 1, '2019-01-01 01:30:47');
INSERT INTO vote_q(user_id, question_id, value, date) VALUES (10, 1, 1, '2019-01-01 01:30:47');
INSERT INTO vote_q(user_id, question_id, value, date) VALUES (13, 1, -1, '2019-01-01 01:30:47');
INSERT INTO vote_q(user_id, question_id, value, date) VALUES (22, 1, 1, '2019-01-01 01:30:47');

INSERT INTO vote_q(user_id, question_id, value, date) VALUES (10, 2, 1, '2019-04-05 01:31:47');
INSERT INTO vote_q(user_id, question_id, value, date) VALUES (26, 2, 1, '2019-04-05 01:31:47');
INSERT INTO vote_q(user_id, question_id, value, date) VALUES (3, 2, -1, '2019-04-05 01:31:47');

INSERT INTO vote_q(user_id, question_id, value, date) VALUES (16, 3, 1, '2019-04-05 01:30:47');

INSERT INTO vote_a(user_id, answer_id, value, date) VALUES (23, 1, 1, '2019-05-04 08:33:00');


--follow question
INSERT INTO follow(user_id, question_id) VALUES (2, 3);
INSERT INTO follow(user_id, question_id) VALUES (16, 3);
INSERT INTO follow(user_id, question_id) VALUES (26, 3);
INSERT INTO follow(user_id, question_id) VALUES (27, 3);
INSERT INTO follow(user_id, question_id) VALUES (8, 3);
INSERT INTO follow(user_id, question_id) VALUES (30, 3);

INSERT INTO follow(user_id, question_id) VALUES (9, 2);
INSERT INTO follow(user_id, question_id) VALUES (23, 2);
INSERT INTO follow(user_id, question_id) VALUES (1, 2);
INSERT INTO follow(user_id, question_id) VALUES (24, 2);
INSERT INTO follow(user_id, question_id) VALUES (12, 2);

INSERT INTO follow(user_id, question_id) VALUES (7, 1);
INSERT INTO follow(user_id, question_id) VALUES (10, 1);
INSERT INTO follow(user_id, question_id) VALUES (15, 1);
INSERT INTO follow(user_id, question_id) VALUES (19, 1);
INSERT INTO follow(user_id, question_id) VALUES (3, 1);
INSERT INTO follow(user_id, question_id) VALUES (27, 1);


--tags
INSERT INTO tag(name) VALUES ('GoT');
INSERT INTO tag(name) VALUES ('Spider_man');
INSERT INTO tag(name) VALUES ('Shazam');
INSERT INTO tag(name) VALUES ('Drama');
INSERT INTO tag(name) VALUES ('Comedy');
INSERT INTO tag(name) VALUES ('Adventure');
INSERT INTO tag(name) VALUES ('DC');

INSERT INTO tag_question(tag_id, question_id) VALUES (1, 3);
INSERT INTO tag_question(tag_id, question_id) VALUES (4, 3);
INSERT INTO tag_question(tag_id, question_id) VALUES (2, 1);
INSERT INTO tag_question(tag_id, question_id) VALUES (3, 2);
INSERT INTO tag_question(tag_id, question_id) VALUES (7, 2);
INSERT INTO tag_question(tag_id, question_id) VALUES (5, 2);


--reports
INSERT INTO report(description, date, resolved, author, target) VALUES ('user is spamming questions', '2019-04-05 01:31:47', false, 1, 30);
INSERT INTO report(description, date, resolved, author, target) VALUES ('posting mature content', '2019-04-05 01:31:47', false, 15, 8);
INSERT INTO report(description, date, resolved, author, target) VALUES ('wrong use of tags', '2019-04-05 01:31:47', false, 17, 22);
INSERT INTO report(description, date, resolved, author, target) VALUES ('spoilers in title of question', '2019-04-05 01:31:47', false, 25, 7);
INSERT INTO report(description, date, resolved, author, target) VALUES ('spoiler', '2019-04-05 01:31:47', false,  29, 11);

--messages
INSERT INTO message(title, content, date, author) VALUES ('Welcome to LCQ!', 'Hi buddy, I just saw that you registered and couldn''t believe it!
Hope you enjoy this website, it''s very neat! Any questions you have don''t hesitate and send me a message! See you around.', '2019-04-05 01:31:47', 1);
INSERT INTO message(title, content, date, author) VALUES ('Was not expecting this', 'Thanks so much for the welcoming message, wasn''t expecting this at all!
I''ll try to find my way around the website, otherwise I''ll hit you up for sure!', '2019-04-05 02:41:47', 10);
INSERT INTO message(title, content, date, author) VALUES ('Avengers Fans Meeting', 'Good afternoon, I''m sending this email to remind you all that the VII Annual Avengers Fans Meeting will take place next Saturday, around 4pm.
As agreed, we should all wear cosplay so that we embody the true spirit of Avengers. Best regards.', '2019-04-15 18:11:47', 5);

INSERT INTO message_target(user_id, message_id) VALUES (10,1);
INSERT INTO message_target(user_id, message_id) VALUES (1,2);
INSERT INTO message_target(user_id, message_id) VALUES (5,3);
INSERT INTO message_target(user_id, message_id) VALUES (7,3);
INSERT INTO message_target(user_id, message_id) VALUES (9,3);
INSERT INTO message_target(user_id, message_id) VALUES (13,3);
INSERT INTO message_target(user_id, message_id) VALUES (17,3);
INSERT INTO message_target(user_id, message_id) VALUES (22,3);
INSERT INTO message_target(user_id, message_id) VALUES (27,3);

-----------------------------------------
-- end
-----------------------------------------