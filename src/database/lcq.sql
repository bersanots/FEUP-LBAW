DROP TYPE IF EXISTS media_type;
DROP TYPE IF EXISTS medals;

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
DROP TABLE IF EXISTS notified CASCADE;
DROP TABLE IF EXISTS notif_new_msg CASCADE;
DROP TABLE IF EXISTS notif_new_ans CASCADE;
DROP TABLE IF EXISTS notif_comment_ans CASCADE;
DROP TABLE IF EXISTS notif_comment_q CASCADE;
DROP TABLE IF EXISTS media CASCADE;
DROP TABLE IF EXISTS favourite CASCADE;

CREATE TYPE media_type AS ENUM
(
    'film',
    'series',
    'animation'
);

CREATE TYPE medals AS ENUM
(
    'BestAnswers',
    'TopAnswerer',
    'QuickAnswerer',
    'QuestionMaster',
    'RegularQuestioner'
);

CREATE TABLE users
(
    userId SERIAL PRIMARY KEY,
    username VARCHAR NOT NULL CONSTRAINT user_username_uk UNIQUE,
    email TEXT NOT NULL CONSTRAINT user_email_uk UNIQUE,
    password VARCHAR NOT NULL,
    picture PATH NOT NULL,
    description TEXT,
    joinedDate DATE DEFAULT now(),
    isDeleted BOOLEAN DEFAULT false
);

CREATE TABLE moderator
(
    moderatorId INTEGER NOT NULL REFERENCES users
);

CREATE TABLE administrator
(
    administratorId INTEGER PRIMARY KEY NOT NULL REFERENCES users
);

CREATE TABLE ban
(
    banId SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    date DATE DEFAULT now(),
    adminId INTEGER NOT NULL REFERENCES administrator,
    userId INTEGER NOT NULL REFERENCES users
);

CREATE TABLE report
(
    reportId SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    date DATE DEFAULT now(),
    author INTEGER NOT NULL REFERENCES users,
    target INTEGER NOT NULL REFERENCES users
);


CREATE TABLE question
(
    questionId SERIAL PRIMARY KEY,
    title TEXT NOT NULL CONSTRAINT question_title_uk UNIQUE,
    description TEXT NOT NULL,
    creationDate DATETIME DEFAULT now(),
    score INT DEFAULT 0,
    category TYPE media_type NOT NULL,
    author INTEGER NOT NULL REFERENCES User,
    best INTEGER NOT NULL REFERENCES answer
);

    CREATE TABLE answer
    (
        questionId SERIAL PRIMARY KEY,
        description TEXT NOT NULL,
        creationDate DATETIME DEFAULT now(),
        score INT DEFAULT 0,
        questionId INTEGER NOT NULL REFERENCES question,
        author INTEGER NOT NULL REFERENCES users
    );

    CREATE TABLE comment_question
    (
        cqId SERIAL PRIMARY KEY,
        description TEXT NOT NULL,
        creationDate DATETIME DEFAULT now(),
        questionId INTEGER NOT NULL REFERENCES question,
        author INTEGER NOT NULL REFERENCES users
    );

    CREATE TABLE comment_answer
    (
        caId SERIAL PRIMARY KEY,
        description TEXT NOT NULL,
        creationDate DATETIME DEFAULT now(),
        answerId INTEGER NOT NULL REFERENCES answer,
        author INTEGER NOT NULL REFERENCES users
    );

    CREATE TABLE vote_q
    (
        userId Integer NOT NULL REFERENCES users,
        questionId Integer NOT NULL REFERENCES question,
        value INTEGER NOT NULL CONSTRAINT value_ck CHECK ((value = 1 ) OR (value = -1)),
        date DATETIME DEFAULT now(),
        PRIMARY KEY (userId, questionId)
    );

    CREATE TABLE vote_a
    (
        userId Integer NOT NULL REFERENCES users,
        answerId Integer NOT NULL REFERENCES answer,
        value INTEGER NOT NULL CONSTRAINT value_ck CHECK ((value = 1 ) OR (value = -1)),
        date DATETIME DEFAULT now(),
        PRIMARY KEY (userId, answerId)
    );

    CREATE TABLE follow
    (
        userId Integer NOT NULL REFERENCES users,
        questionId Integer NOT NULL REFERENCES question,
        PRIMARY KEY (userId, questionId)
    );

    CREATE TABLE tag
    (
        tagId SERIAL PRIMARY KEY,
        name TEXT NOT NULL CONSTRAINT tag_name_uk UNIQUE,
    );

    CREATE TABLE tag_question
    (
        tagId Integer NOT NULL REFERENCES Tag,
        questionId Integer NOT NULL REFERENCES question,
        PRIMARY KEY (tagID, questionId)
    );

    CREATE TABLE medal
    (
        medalId SERIAL PRIMARY KEY,
        description TEXT NOT NULL CONSTRAINT medal_description_uk UNIQUE,
        name TYPE medals NOT NULL CONSTRAINT medals_type_uk UNIQUE
);

        CREATE TABLE achievement
        (
            userId Integer NOT NULL REFERENCES users,
            medalId Integer NOT NULL REFERENCES Medal,
            date DATE DEFAULT now(),
            PRIMARY KEY (userID, medalId)
        );

        CREATE TABLE message
        (
            messageId SERIAL PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            date DATE DEFAULT now(),
            author INTEGER NOT NULL REFERENCES users
        );

        CREATE TABLE message_target
        (
            userId INTEGER NOT NULL REFERENCES users,
            messageId INTEGER NOT NULL REFERENCES Message,
            PRIMARY KEY (userId, messageId)
        );

        CREATE TABLE notified
        (
            userId INTEGER NOT NULL REFERENCES users,
            notificationId INTEGER NOT NULL REFERENCES Notification,
            hasSeen boolean DEFAULT false,
            PRIMARY KEY (userId, notificationId)
        );

        CREATE TABLE notif_new_msg
        (
            nnmId SERIAL PRIMARY KEY,
            date DATE DEFAULT now(),
            messageId INTEGER NOT NULL REFERENCES Message,
        );

        CREATE TABLE notif_new_ans
        (
            nnaId SERIAL PRIMARY KEY,
            date DATE DEFAULT now(),
            answerId INTEGER NOT NULL REFERENCES answer,
        );

        CREATE TABLE notif_comment_ans
        (
            ncaId SERIAL PRIMARY KEY,
            date DATE DEFAULT now(),
            commentanswerId INTEGER NOT NULL REFERENCES CommentAnswer,
        );

        CREATE TABLE notif_comment_q
        (
            ncqId SERIAL PRIMARY KEY,
            date DATE DEFAULT now(),
            commentquestionId INTEGER NOT NULL REFERENCES CommentQuestion,
        );

        CREATE TABLE media
        (
            mediaId SERIAL PRIMARY KEY,
            title TEXT NOT NULL CONSTRAINT media_title_uk UNIQUE,
            release DATE NOT NULL,
            category TYPE media_type NOT NULL,
            picture PATH
);

            CREATE TABLE favourite
            (
                userId Integer NOT NULL REFERENCES users,
                mediaId Integer NOT NULL REFERENCES Media,
                PRIMARY KEY (userId, mediaId)
            );
