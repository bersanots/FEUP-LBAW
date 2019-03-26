CREATE TYPE media AS ENUM(
    'film',
    'series',
    'animation'
);

CREATE TYPE medals AS ENUM(
    'BestAnswers',
    'TopAnswerer',
    'QuickAnswerer',
    'QuestionMaster',
    'RegularQuestioner'
);

CREATE TABLE User (
    userId SERIAL PRIMARY KEY,
    username NOT NULL CONSTRAINT user_username_uk UNIQUE,
    email NOT NULL CONSTRAINT user_email_uk UNIQUE,
    password TEXT NOT NULL,
    picture PATH NOT NULL,
    description TEXT,
    joinedDate DEFAULT today(), 
    isDeleted BOOLEAN DEFAULT false,
);


CREATE TABLE Question (
    questionId SERIAL PRIMARY KEY,
    title NOT NULL CONSTRAINT question_title_uk UNIQUE,
    description TEXT NOT NULL,
    creationDate DEFAULT today(), /* TODO maybe change*/ 
    score DEFAULT 0,
    category NOT NULL,
    author INTEGER NOT NULL REFERENCES User
);

CREATE TABLE Answer (
    questionId SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    creationDate DEFAULT today(), /* TODO maybe change on all */ 
    score DEFAULT 0,
    possession INTEGER NOT NULL REFERENCES Question,
    author INTEGER NOT NULL REFERENCES User
);

CREATE TABLE CommentQuestion (
    cqId SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    creationDate DEFAULT today(),
    possession INTEGER NOT NULL REFERENCES Question, /* TODO maybe score comment*/
    author INTEGER NOT NULL REFERENCES User
);

CREATE TABLE CommentAnswer (
    caId SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    creationDate DEFAULT today(),
    possession INTEGER NOT NULL REFERENCES Answer, /* TODO maybe score comment*/
    author INTEGER NOT NULL REFERENCES User
);

CREATE TABLE VoteQ (
    userId Integer NOT NULL REFERENCES User,
    questionId Integer NOT NULL REFERENCES Question,
    value INTEGER NOT NULL CONSTRAINT value_ck CHECK ((value = 1 ) OR (value = -1)),
    date DEFAULT today(),
    PRIMARY KEY (userId, questionId)
);

CREATE TABLE VoteA (
    userId Integer NOT NULL REFERENCES User,
    answerId Integer NOT NULL REFERENCES Answer,
    value INTEGER NOT NULL CONSTRAINT value_ck CHECK ((value = 1 ) OR (value = -1)),
    date DEFAULT today(),
    PRIMARY KEY (userId, answerId)
);

CREATE TABLE follow (
    userId Integer NOT NULL REFERENCES User,
    questionId Integer NOT NULL REFERENCES Question,
    PRIMARY KEY (userId, questionId)
);

CREATE TABLE Media (
    mediaId SERIAL PRIMARY KEY,
    title TEXT NOT NULL CONSTRAINT media_title_uk UNIQUE,
    release DATE NOT NULL,
    type TYPE media NOT NULL,
    picture PATH
);

CREATE TABLE favourite (
    userId Integer NOT NULL REFERENCES User,
    mediaId Integer NOT NULL REFERENCES Media,
    PRIMARY KEY (userId, mediaId)
);

CREATE TABLE Tag (
    tagId SERIAL PRIMARY KEY,
    name TEXT NOT NULL CONSTRAINT tag_name_uk UNIQUE,
);

CREATE TABLE tagQuestion (
    tagId Integer NOT NULL REFERENCES Tag,
    questionId Integer NOT NULL REFERENCES Question,
    PRIMARY KEY (tagID, questionId)
);

CREATE TABLE Medal ( 
    medalId SERIAL PRIMARY KEY,
    description NOT NULL CONSTRAINT medal_description_uk UNIQUE,
    type TYPE medals NOT NULL CONSTRAINT medals_type_uk UNIQUE
);

CREATE TABLE medalUser (
    userId Integer NOT NULL REFERENCES User,
    medalId Integer NOT NULL REFERENCES Medal,
    PRIMARY KEY (userID, medalId)
);

CREATE TABLE moderator (
    moderatorId INTEGER NOT NULL REFERENCES User
);

CREATE TABLE Administrator (
    administratorId INTEGER NOT NULL REFERENCES User
);

CREATE TABLE Ban (
    banId SERIAL PRIIMARY KEY,
    description TEXT NOT NULL, 
    date DATE DEFAULT today(),
    adminId INTEGER NOT NULL REFERENCES Administrator,
    userId INTEGER NOT NULL REFERENCES User
);

CREATE TABLE Report (
    reportId SERIAL PRIIMARY KEY,
    description TEXT NOT NULL, 
    date DATE DEFAULT today(),
    author INTEGER NOT NULL REFERENCES User,
    target INTEGER NOT NULL REFERENCES User
);

CREATE TABLE Message ( 
    messageId SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    date DATE DEFAULT today(),
    author INTEGER NOT NULL REFERENCES User
);

CREATE TABLE target (
    userId INTEGER NOT NULL REFERENCES User,
    messageId INTEGER NOT NULL REFERENCES Message,
    PRIMARY KEY (userId, messageId)
);

CREATE TABLE Achievement (
    userId INTEGER NOT NULL REFERENCES User,
    medalId INTEGER NOT NULL REFERENCES Notification,
    date DATE DEFAULT today(),
    PRIMARY KEY (userId, medalId)
);

CREATE TABLE Notified (
    userId INTEGER NOT NULL REFERENCES User,
    notificationId INTEGER NOT NULL REFERENCES Notification,
    hasSeen boolean DEFAULT false,
    PRIMARY KEY (userId, notificationId)
);

CREATE TABLE NotifNewMsg (
    nnmId SERIAL PRIMARY KEY,
    date DATE DEFAULT today(),
    messageId INTEGER NOT NULL REFERENCES Message,
);

CREATE TABLE NotifNewAAns (
    nnaId SERIAL PRIMARY KEY,
    date DATE DEFAULT today(),
    answerId INTEGER NOT NULL REFERENCES Answer,
);

CREATE TABLE NotifCommentAns (
    ncaId SERIAL PRIMARY KEY,
    date DATE DEFAULT today(),
    commentanswerId INTEGER NOT NULL REFERENCES CommentAnswer,
);

CREATE TABLE NotifCommentQ (
    ncqId SERIAL PRIMARY KEY,
    date DATE DEFAULT today(),
    commentquestionId INTEGER NOT NULL REFERENCES CommentQuestion,
);