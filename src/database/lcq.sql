CREATE TYPE media AS ENUM
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

CREATE TABLE Users
(
    userId SERIAL PRIMARY KEY,
    username VARCHAR NOT NULL CONSTRAINT user_username_uk UNIQUE,
    email TEXT NOT NULL CONSTRAINT user_email_uk UNIQUE,
    password VARCHAR NOT NULL,
    picture PATH NOT NULL,
    description TEXT,
    joinedDate DATE DEFAULT today(),
    isDeleted BOOLEAN DEFAULT false,
);

CREATE TABLE Question
(
    questionId SERIAL PRIMARY KEY,
    title TEXT NOT NULL CONSTRAINT question_title_uk UNIQUE,
    description TEXT NOT NULL,
    creationDate DATETIME DEFAULT now(),
    score INT DEFAULT 0,
    category TYPE
    media NOT NULL,
    author INTEGER NOT NULL REFERENCES User,
    best INTEGER NOT NULL REFERENCES Answer
);

    CREATE TABLE Answer
    (
        questionId SERIAL PRIMARY KEY,
        description TEXT NOT NULL,
        creationDate DATETIME DEFAULT now(),
        score INT DEFAULT 0,
        questionId INTEGER NOT NULL REFERENCES Question,
        author INTEGER NOT NULL REFERENCES Users
    );

    CREATE TABLE CommentQuestion
    (
        cqId SERIAL PRIMARY KEY,
        description TEXT NOT NULL,
        creationDate DATETIME DEFAULT now(),
        questionId INTEGER NOT NULL REFERENCES Question,
        author INTEGER NOT NULL REFERENCES Users
    );

    CREATE TABLE CommentAnswer
    (
        caId SERIAL PRIMARY KEY,
        description TEXT NOT NULL,
        creationDate DATETIME DEFAULT now(),
        answerId INTEGER NOT NULL REFERENCES Answer,
        author INTEGER NOT NULL REFERENCES Users
    );

    CREATE TABLE VoteQ
    (
        userId Integer NOT NULL REFERENCES Users,
        questionId Integer NOT NULL REFERENCES Question,
        value INTEGER NOT NULL CONSTRAINT value_ck CHECK ((value = 1 ) OR (value = -1)),
        date DATETIME DEFAULT now(),
        PRIMARY KEY (userId, questionId)
    );

    CREATE TABLE VoteA
    (
        userId Integer NOT NULL REFERENCES Users,
        answerId Integer NOT NULL REFERENCES Answer,
        value INTEGER NOT NULL CONSTRAINT value_ck CHECK ((value = 1 ) OR (value = -1)),
        date DATETIME DEFAULT now(),
        PRIMARY KEY (userId, answerId)
    );

    CREATE TABLE Follow
    (
        userId Integer NOT NULL REFERENCES Users,
        questionId Integer NOT NULL REFERENCES Question,
        PRIMARY KEY (userId, questionId)
    );

    CREATE TABLE Favourite
    (
        userId Integer NOT NULL REFERENCES Users,
        mediaId Integer NOT NULL REFERENCES Media,
        PRIMARY KEY (userId, mediaId)
    );

    CREATE TABLE Tag
    (
        tagId SERIAL PRIMARY KEY,
        name TEXT NOT NULL CONSTRAINT tag_name_uk UNIQUE,
    );

    CREATE TABLE TagQuestion
    (
        tagId Integer NOT NULL REFERENCES Tag,
        questionId Integer NOT NULL REFERENCES Question,
        PRIMARY KEY (tagID, questionId)
    );

    CREATE TABLE Medal
    (
        medalId SERIAL PRIMARY KEY,
        description TEXT NOT NULL CONSTRAINT medal_description_uk UNIQUE,
        type TYPE
        medals NOT NULL CONSTRAINT medals_type_uk UNIQUE
);

        CREATE TABLE Achievement
        (
            userId Integer NOT NULL REFERENCES Users,
            medalId Integer NOT NULL REFERENCES Medal,
            date DATE DEFAULT today(),
            PRIMARY KEY (userID, medalId)
        );

        CREATE TABLE Moderator
        (
            moderatorId INTEGER NOT NULL REFERENCES Users
        );

        CREATE TABLE Administrator
        (
            administratorId INTEGER NOT NULL REFERENCES Users
        );

        CREATE TABLE Ban
        (
            banId SERIAL PRIMARY KEY,
            description TEXT NOT NULL,
            date DATE DEFAULT today(),
            adminId INTEGER NOT NULL REFERENCES Administrator,
            userId INTEGER NOT NULL REFERENCES Users
        );

        CREATE TABLE Report
        (
            reportId SERIAL PRIMARY KEY,
            description TEXT NOT NULL,
            date DATE DEFAULT today(),
            author INTEGER NOT NULL REFERENCES Users,
            target INTEGER NOT NULL REFERENCES Users
        );

        CREATE TABLE Message
        (
            messageId SERIAL PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            date DATE DEFAULT now(),
            author INTEGER NOT NULL REFERENCES Users
        );

        CREATE TABLE MessageTarget
        (
            userId INTEGER NOT NULL REFERENCES Users,
            messageId INTEGER NOT NULL REFERENCES Message,
            PRIMARY KEY (userId, messageId)
        );

        CREATE TABLE Notified
        (
            userId INTEGER NOT NULL REFERENCES Users,
            notificationId INTEGER NOT NULL REFERENCES Notification,
            hasSeen boolean DEFAULT false,
            PRIMARY KEY (userId, notificationId)
        );

        CREATE TABLE NotifNewMsg
        (
            nnmId SERIAL PRIMARY KEY,
            date DATE DEFAULT now(),
            messageId INTEGER NOT NULL REFERENCES Message,
        );

        CREATE TABLE NotifNewAAns
        (
            nnaId SERIAL PRIMARY KEY,
            date DATE DEFAULT now(),
            answerId INTEGER NOT NULL REFERENCES Answer,
        );

        CREATE TABLE NotifCommentAns
        (
            ncaId SERIAL PRIMARY KEY,
            date DATE DEFAULT now(),
            commentanswerId INTEGER NOT NULL REFERENCES CommentAnswer,
        );

        CREATE TABLE NotifCommentQ
        (
            ncqId SERIAL PRIMARY KEY,
            date DATE DEFAULT now(),
            commentquestionId INTEGER NOT NULL REFERENCES CommentQuestion,
        );

        CREATE TABLE Media
        (
            mediaId SERIAL PRIMARY KEY,
            title TEXT NOT NULL CONSTRAINT media_title_uk UNIQUE,
            release DATE NOT NULL,
            type TYPE media NOT NULL,
            picture PATH
);