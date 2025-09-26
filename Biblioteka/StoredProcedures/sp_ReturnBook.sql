CREATE PROCEDURE Library.sp_ReturnBook
@BorrowingId INT,
@ReturnDate DATETIME2 = NULL,
@PolicyId INT = 1,
@Penalty DECIMAL(10,2) OUTPUT
AS
BEGIN
SET NOCOUNT ON;


IF @ReturnDate IS NULL
SET @ReturnDate = SYSUTCDATETIME();


BEGIN TRY
BEGIN TRANSACTION;


DECLARE @bookId INT, @dueDate DATETIME2, @existingReturnDate DATETIME2;
SELECT @bookId = BookId, @dueDate = DueDate, @existingReturnDate = ReturnDate FROM Library.Borrowings WHERE BorrowingId = @BorrowingId;


IF @bookId IS NULL
BEGIN
THROW 51010, 'Emprunt introuvable.', 1;
END


IF @existingReturnDate IS NOT NULL
BEGIN
THROW 51011, 'Ce livre a déjà été retourné.', 1;
END


-- Calculer pénalité via fonction
SET @Penalty = Library.fn_CalculatePenalty(@dueDate, @ReturnDate, @PolicyId);


-- Mettre à jour Borrowings
UPDATE Library.Borrowings
SET ReturnDate = @ReturnDate, Penalty = @Penalty
WHERE BorrowingId = @BorrowingId;


-- Insérer enregistrement de retour
INSERT INTO Library.Returns (BorrowingId, ReturnedAt, Penalty)
VALUES (@BorrowingId, @ReturnDate, @Penalty);


-- Incrémenter AvailableCopies
UPDATE Library.Books
SET AvailableCopies = AvailableCopies + 1
WHERE BookId = @bookId;


COMMIT TRANSACTION;
END TRY
BEGIN CATCH
IF XACT_STATE() <> 0
ROLLBACK TRANSACTION;
DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
RAISERROR('Erreur sp_ReturnBook: %s', 16, 1, @ErrMsg);
RETURN;
END CATCH
END;