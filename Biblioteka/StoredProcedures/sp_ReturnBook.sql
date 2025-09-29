CREATE PROCEDURE Library.sp_ReturnBook
    @BorrowingId        INT,
    @ReturnDate         DATETIME2 = NULL,
    @PolicyId           INT = 1,
    @Penalty            DECIMAL(10,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Définir la date de retour par défaut
    IF @ReturnDate IS NULL
        SET @ReturnDate = SYSUTCDATETIME();

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Récupérer les informations de l'emprunt
        DECLARE @bookId             INT, 
                @dueDate            DATETIME2, 
                @existingReturnDate DATETIME2;
        
        SELECT 
            @bookId = BookId, 
            @dueDate = DueDate, 
            @existingReturnDate = ReturnDate 
        FROM Library.Borrowings 
        WHERE BorrowingId = @BorrowingId;

        -- Vérifier que l'emprunt existe
        IF @bookId IS NULL
        BEGIN
            THROW 51010, 'Emprunt introuvable.', 1;
        END

        -- Vérifier que le livre n'a pas déjà été retourné
        IF @existingReturnDate IS NOT NULL
        BEGIN
            THROW 51011, 'Ce livre a déjà été retourné.', 1;
        END

        -- Calculer la pénalité via fonction
        SET @Penalty = Library.fn_CalculatePenalty(@dueDate, @ReturnDate, @PolicyId);

        -- Mettre à jour l'emprunt
        UPDATE Library.Borrowings
        SET ReturnDate = @ReturnDate, 
            Penalty = @Penalty
        WHERE BorrowingId = @BorrowingId;

        -- Insérer l'enregistrement de retour
        INSERT INTO Library.Returns (BorrowingId, ReturnedAt, Penalty)
        VALUES (@BorrowingId, @ReturnDate, @Penalty);

        -- Incrémenter les copies disponibles
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