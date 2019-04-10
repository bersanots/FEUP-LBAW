-------------------
--    UPDATES    --
-------------------

-- Update user information
UPDATE users
  SET description = $description, picture = $picture
  WHERE user_id = $user_id;

-- Update user password
UPDATE users
  SET password = $password
  WHERE user_id = $user_id;

-- Update question
UPDATE question
  SET title = $title, description = $description
  WHERE question_id = $question_id;

-- Update answer
UPDATE answer
  SET description = $description
  WHERE answer_id = $answer_id;

-- Update comment in question
UPDATE comment_question
  SET description = $description
  WHERE cq_id = $cq_id;

-- Update comment in answer
UPDATE comment_answer
  SET description = $description
  WHERE ca_id = $ca_id;


-------------------
--    INSERTS    --
-------------------

-- New user registered
INSERT INTO users (username,email,password)
    VALUES ($username,$email,$password);

-- Create new question
INSERT INTO question (title,description,category,author)
    VALUES ($title,$description,$category,$author);

-- Create new answer
INSERT INTO answer (description,question_id,author)
    VALUES ($description,$question_id,$author);

-- Create new comment in question
INSERT INTO comment_question (description,question_id,author)
    VALUES ($description,$question_id,$author);

-- Create new comment in answer
INSERT INTO comment_question (description,question_id,author)
    VALUES ($description,$question_id,$author);

-- Create new vote in question
INSERT INTO vote_q (user_id,question_id,value)
    VALUES ($user_id,$question_id,$value);

-- Create new vote in answer
INSERT INTO vote_a (user_id,answer_id,value)
    VALUES ($user_id,$answer_id,$value);

-- Create new follow in question
INSERT INTO follow (user_id,question_id)
    VALUES ($user_id,$question_id);

-- Create new report
INSERT INTO report (description,author,target)
    VALUES ($description,$author,$target);

-- Create new message
INSERT INTO message (title,content,author)
    VALUES ($title,$content,$author);

INSERT INTO message_target (user_id,message_id)
    VALUES ($user_id,$message_id);


-------------------
--    DELETES    --
-------------------

-- Delete a question
DELETE FROM question 
  WHERE question_id = $question_id; 

-- Delete an answer
DELETE FROM answer 
  WHERE answer_id = $answer_id;

-- Delete a vote in a question
DELETE FROM vote_q 
  WHERE question_id = $question_id;

-- Delete a vote in an answer
DELETE FROM vote_a 
  WHERE answer_id = $answer_id;

