-- Make sure to rename this file as student_id_Lab3.sql (E.g.: 2024A7PS0001G_Lab3.sql, 2023B4A70800G_Lab3.sql)
-- Make sure the words in your query don't break into a new line.
-- Make sure your query ends with a semicolon.

CREATE TABLE Publishers(PublisherID INT PRIMARY KEY, Firstname VARCHAR(250) NOT NULL, Surname VARCHAR(250) NOT NULL, Country VARCHAR(250));

CREATE TABLE Books(BookID INT PRIMARY KEY, Title VARCHAR(250) NOT NULL, Price DECIMAL CHECK(Price IS NULL OR Price>0), PublisherID INT NOT NULL, FOREIGN KEY(PublisherID) REFERENCES Publishers(PublisherID) ON DELETE RESTRICT ON UPDATE CASCADE);

CREATE TABLE Authors(AuthorID INT PRIMARY KEY,AuthorName VARCHAR(250),MentorID INT,PublisherID INT UNIQUE,FOREIGN KEY(MentorID) REFERENCES Authors(AuthorID) ON DELETE SET NULL ON UPDATE CASCADE, FOREIGN KEY(PublisherID) REFERENCES Publishers(PublisherID) ON DELETE RESTRICT ON UPDATE CASCADE);

CREATE TABLE Email(AuthorID INT,Email VARCHAR(250) UNIQUE,PRIMARY KEY(AuthorID,Email),CONSTRAINT chk_email CHECK(Email LIKE "_%@_%._%" AND Email NOT LIKE "% %"),FOREIGN KEY(AuthorID) REFERENCES Authors(AuthorID) ON DELETE CASCADE ON UPDATE CASCADE);