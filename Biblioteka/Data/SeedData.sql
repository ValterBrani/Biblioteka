-- Ins�rer quelques auteurs
INSERT INTO Library.Authors (FirstName, LastName, BirthDate)
VALUES 
('George', 'Orwell', '1903-06-25'),
('J.K.', 'Rowling', '1965-07-31'),
('Victor', 'Hugo', '1802-02-26');
GO

-- Ins�rer quelques livres
INSERT INTO Library.Books (Title, ISBN, PublishedYear, TotalCopies, AvailableCopies)
VALUES 
('1984', '9780451524935', 1949, 5, 5),
('Harry Potter and the Philosopher''s Stone', '9780747532699', 1997, 10, 10),
('Les Mis�rables', '9782070409182', 1862, 3, 3);
GO

-- Associer livres ? auteurs
INSERT INTO Library.BookAuthors (BookId, AuthorId)
SELECT b.BookId, a.AuthorId
FROM Library.Books b
JOIN Library.Authors a ON 
   (b.Title = '1984' AND a.LastName = 'Orwell')
   OR (b.Title LIKE 'Harry Potter%' AND a.LastName = 'Rowling')
   OR (b.Title = 'Les Mis�rables' AND a.LastName = 'Hugo');
GO

-- Ins�rer quelques membres
INSERT INTO Library.Members (FirstName, LastName, Email, JoinDate)
VALUES
('Alice', 'Martin', 'alice.martin@example.com', GETUTCDATE()),
('Bob', 'Dupont', 'bob.dupont@example.com', GETUTCDATE());
GO

-- Ins�rer une politique de p�nalit�
INSERT INTO Library.PenaltyPolicies (Name, PenaltyPerDay)
VALUES ('Standard Policy', 0.50);
GO
