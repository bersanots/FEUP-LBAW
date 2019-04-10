CREATE INDEX usernames ON users USING hash (username);

CREATE INDEX user_notification ON notified USING hash (user_id);

CREATE INDEX user_message ON message_target USING hash (user_id);

CREATE INDEX user_followed_question ON follow USING hash (user_id);

CREATE INDEX question_date ON question USING btree (creation_date);

CREATE INDEX notification_date ON notification USING btree (date);

CREATE INDEX message_date ON message USING btree (date);

CREATE INDEX search ON question USING GIST (to_tsvector('english', title || ' '));