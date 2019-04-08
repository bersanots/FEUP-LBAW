CREATE INDEX usernames ON 'users' USING hash (username);
CREATE INDEX question_date ON 'question' USING btree (creation_date);
CREATE INDEX search ON 'question' USING GIST (search);