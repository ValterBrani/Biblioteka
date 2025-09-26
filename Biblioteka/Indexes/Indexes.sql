CREATE INDEX IX_Books_Title ON Library.Books(Title);
GO
CREATE INDEX IX_Books_Genre ON Library.Books(Genre);
GO
CREATE INDEX IX_Members_Name ON Library.Members(LastName, FirstName);
GO
CREATE INDEX IX_Borrowings_MemberId ON Library.Borrowings(MemberId);
GO
CREATE INDEX IX_Borrowings_BookId ON Library.Borrowings(BookId);
GO