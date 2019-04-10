------------------
--     BANS     --
------------------

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



-------------------
--    REPORTS    --
-------------------

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



-------------------
--     VOTES     --
-------------------

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



------------------
--    FOLLOW    --
------------------

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



-------------------
--  BEST ANSWER  --
-------------------

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



-------------------
-- NOTIFICATIONS --
-------------------

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



--------------------
-- DELETE ACCOUNT --
--------------------

CREATE FUNCTION delete_account_information() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF (NEW.is_deleted = 'true' AND NOT EXISTS (SELECT * FROM ban WHERE NEW.user_id = user_id)) THEN
        UPDATE users
            SET username = to_char(OLD.user_id,'FM99999MI'),
                email = to_char(OLD.user_id,'FM99999MI"@lcq.com"'),
                password = to_char(OLD.user_id,'FM99999MI')
            WHERE user_id = $user_id;
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;
 
CREATE TRIGGER delete_account_information
    AFTER UPDATE ON users
    FOR EACH ROW
    EXECUTE PROCEDURE delete_account_information();