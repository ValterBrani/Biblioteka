CREATE TABLE Library.BookAuthors (
BookId INT NOT NULL,
AuthorId INT NOT NULL,
Contribution NVARCHAR(200) NULL,
PRIMARY KEY (BookId, AuthorId),
CONSTRAINT FK_BookAuthors_Book FOREIGN KEY (BookId) REFERENCES Library.Books(BookId),
CONSTRAINT FK_BookAuthors_Author FOREIGN KEY (AuthorId) REFERENCES Library.Authors(AuthorId)
);