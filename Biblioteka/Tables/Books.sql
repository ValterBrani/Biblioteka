CREATE TABLE Library.Books (
    BookId              INT IDENTITY(1,1) PRIMARY KEY,
    ISBN                NVARCHAR(20) NOT NULL,
    Title               NVARCHAR(300) NOT NULL,
    AuthorId            INT NOT NULL,
    PublishedYear       INT NULL,
    TotalCopies         INT NOT NULL 
                            CONSTRAINT CHK_Books_TotalCopies_Positive 
                            CHECK (TotalCopies >= 0),
    AvailableCopies     INT NOT NULL 
                            CONSTRAINT CHK_Books_AvailableCopies_Range 
                            CHECK (AvailableCopies >= 0 AND AvailableCopies <= TotalCopies),
    Genre               NVARCHAR(100) NULL,
    
    CONSTRAINT UQ_Books_ISBN UNIQUE (ISBN),
    CONSTRAINT FK_Books_Author 
        FOREIGN KEY (AuthorId) REFERENCES Library.Authors(AuthorId)
);