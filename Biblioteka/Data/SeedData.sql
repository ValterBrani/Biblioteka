SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    /* ==========================
       Authors
       ========================== */
    IF NOT EXISTS (
        SELECT 1 
        FROM Library.Authors 
        WHERE FirstName = 'George' 
            AND LastName = 'Orwell' 
            AND BirthDate = '1903-06-25'
    )
        INSERT INTO Library.Authors (FirstName, LastName, BirthDate) 
        VALUES ('George', 'Orwell', '1903-06-25');

    IF NOT EXISTS (
        SELECT 1 
        FROM Library.Authors 
        WHERE FirstName = 'J.K.' 
            AND LastName = 'Rowling' 
            AND BirthDate = '1965-07-31'
    )
        INSERT INTO Library.Authors (FirstName, LastName, BirthDate) 
        VALUES ('J.K.', 'Rowling', '1965-07-31');

    IF NOT EXISTS (
        SELECT 1 
        FROM Library.Authors 
        WHERE FirstName = 'Victor' 
            AND LastName = 'Hugo' 
            AND BirthDate = '1802-02-26'
    )
        INSERT INTO Library.Authors (FirstName, LastName, BirthDate) 
        VALUES ('Victor', 'Hugo', '1802-02-26');

    /* ==========================
       Retrieve Author IDs
       ========================== */
    DECLARE @OrwellId   INT = (
        SELECT AuthorId 
        FROM Library.Authors 
        WHERE FirstName = 'George' 
            AND LastName = 'Orwell'
    );
    
    DECLARE @RowlingId  INT = (
        SELECT AuthorId 
        FROM Library.Authors 
        WHERE FirstName = 'J.K.' 
            AND LastName = 'Rowling'
    );
    
    DECLARE @HugoId     INT = (
        SELECT AuthorId 
        FROM Library.Authors 
        WHERE FirstName = 'Victor' 
            AND LastName = 'Hugo'
    );

    /* ==========================
       Books
       ========================== */
    IF NOT EXISTS (
        SELECT 1 
        FROM Library.Books 
        WHERE ISBN = '9780451524935'
    )
        INSERT INTO Library.Books (Title, ISBN, PublishedYear, TotalCopies, AvailableCopies, AuthorId)
        VALUES ('1984', '9780451524935', 1949, 5, 5, @OrwellId);

    IF NOT EXISTS (
        SELECT 1 
        FROM Library.Books 
        WHERE ISBN = '9780747532699'
    )
        INSERT INTO Library.Books (Title, ISBN, PublishedYear, TotalCopies, AvailableCopies, AuthorId)
        VALUES ('Harry Potter and the Philosopher''s Stone', '9780747532699', 1997, 10, 10, @RowlingId);

    IF NOT EXISTS (
        SELECT 1 
        FROM Library.Books 
        WHERE ISBN = '9782070409182'
    )
        INSERT INTO Library.Books (Title, ISBN, PublishedYear, TotalCopies, AvailableCopies, AuthorId)
        VALUES ('Les Misérables', '9782070409182', 1862, 3, 3, @HugoId);

    /* ==========================
       Members
       ========================== */
    IF NOT EXISTS (
        SELECT 1 
        FROM Library.Members 
        WHERE Email = 'alice.martin@example.com'
    )
        INSERT INTO Library.Members (FirstName, LastName, Email, JoinDate)
        VALUES ('Alice', 'Martin', 'alice.martin@example.com', GETUTCDATE());

    IF NOT EXISTS (
        SELECT 1 
        FROM Library.Members 
        WHERE Email = 'bob.dupont@example.com'
    )
        INSERT INTO Library.Members (FirstName, LastName, Email, JoinDate)
        VALUES ('Bob', 'Dupont', 'bob.dupont@example.com', GETUTCDATE());

    /* ==========================
       Penalty Policies
       ========================== */
    IF NOT EXISTS (
        SELECT 1 
        FROM Library.PenaltyPolicies 
        WHERE Name = 'Standard Policy'
    )
        INSERT INTO Library.PenaltyPolicies (Name, AmountPerDay)
        VALUES ('Standard Policy', 0.50);

    /* ==========================
       Book-Author links (Many-to-Many)
       ========================== */
    ;WITH A AS (
        SELECT AuthorId 
        FROM Library.Authors 
        WHERE FirstName = 'George' 
            AND LastName = 'Orwell'
    ),
    B AS (
        SELECT BookId 
        FROM Library.Books 
        WHERE ISBN = '9780451524935'
    )
    INSERT INTO Library.BookAuthors (BookId, AuthorId)
    SELECT b.BookId, a.AuthorId
    FROM B b 
        CROSS JOIN A a
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Library.BookAuthors ba 
        WHERE ba.BookId = b.BookId 
            AND ba.AuthorId = a.AuthorId
    );

    ;WITH A AS (
        SELECT AuthorId 
        FROM Library.Authors 
        WHERE FirstName = 'J.K.' 
            AND LastName = 'Rowling'
    ),
    B AS (
        SELECT BookId 
        FROM Library.Books 
        WHERE ISBN = '9780747532699'
    )
    INSERT INTO Library.BookAuthors (BookId, AuthorId)
    SELECT b.BookId, a.AuthorId
    FROM B b 
        CROSS JOIN A a
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Library.BookAuthors ba 
        WHERE ba.BookId = b.BookId 
            AND ba.AuthorId = a.AuthorId
    );

    ;WITH A AS (
        SELECT AuthorId 
        FROM Library.Authors 
        WHERE FirstName = 'Victor' 
            AND LastName = 'Hugo'
    ),
    B AS (
        SELECT BookId 
        FROM Library.Books 
        WHERE ISBN = '9782070409182'
    )
    INSERT INTO Library.BookAuthors (BookId, AuthorId)
    SELECT b.BookId, a.AuthorId
    FROM B b 
        CROSS JOIN A a
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Library.BookAuthors ba 
        WHERE ba.BookId = b.BookId 
            AND ba.AuthorId = a.AuthorId
    );

    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK;

    DECLARE @ErrMsg     NVARCHAR(4000) = ERROR_MESSAGE(),
            @ErrNum     INT = ERROR_NUMBER(),
            @ErrSev     INT = ERROR_SEVERITY(),
            @ErrState   INT = ERROR_STATE(),
            @ErrLine    INT = ERROR_LINE();

    RAISERROR('SeedData failure (%d) Line %d: %s', @ErrSev, @ErrState, @ErrNum, @ErrLine, @ErrMsg);
END CATCH;
GO
