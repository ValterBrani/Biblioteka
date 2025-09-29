-- Index pour améliorer les recherches par titre de livre
CREATE INDEX IX_Books_Title 
ON Library.Books(Title);
GO

-- Index pour améliorer les recherches par genre
CREATE INDEX IX_Books_Genre 
ON Library.Books(Genre);
GO

-- Index composé pour améliorer les recherches par nom de membre
CREATE INDEX IX_Members_Name 
ON Library.Members(LastName, FirstName);
GO

-- Index pour améliorer les jointures et recherches par membre dans les emprunts
CREATE INDEX IX_Borrowings_MemberId 
ON Library.Borrowings(MemberId);
GO

-- Index pour améliorer les jointures et recherches par livre dans les emprunts
CREATE INDEX IX_Borrowings_BookId 
ON Library.Borrowings(BookId);
GO

-- Index pour améliorer les recherches de livres en retard
CREATE INDEX IX_Borrowings_DueDate_ReturnDate 
ON Library.Borrowings(DueDate, ReturnDate) 
WHERE ReturnDate IS NULL;
GO

-- Index pour améliorer les recherches de retours avec pénalités
CREATE INDEX IX_Returns_Penalty 
ON Library.Returns(Penalty) 
WHERE Penalty > 0;
GO