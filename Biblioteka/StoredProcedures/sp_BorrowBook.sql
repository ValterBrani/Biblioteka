CREATE PROCEDURE Library.sp_BorrowBook
    @MemberId INT,
    @BookId INT,
    @BorrowDate DATETIME2 = NULL,
    @DueDate DATETIME2,
    @BorrowingId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @BorrowDate IS NULL
        SET @BorrowDate = SYSUTCDATETIME();

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Vérifier membre actif
        IF NOT EXISTS (SELECT 1 FROM Library.Members WHERE MemberId = @MemberId AND IsActive = 1)
        BEGIN
            THROW 51000, 'Membre introuvable ou inactif.', 1;
        END

        -- Vérifier disponibilité
        DECLARE @available INT;
        SELECT @available = AvailableCopies FROM Library.Books WHERE BookId = @BookId;

        IF @available IS NULL
        BEGIN
            THROW 51001, 'Livre introuvable.', 1;
        END

        IF @available <= 0
        BEGIN
            THROW 51002, 'Aucune copie disponible pour ce livre.', 1;
        END

        -- Décrémenter disponible
        UPDATE Library.Books
        SET AvailableCopies = AvailableCopies - 1
        WHERE BookId = @BookId;

        -- Insérer emprunt
        INSERT INTO Library.Borrowings (MemberId, BookId, BorrowDate, DueDate)
        VALUES (@MemberId, @BookId, @BorrowDate, @DueDate);

        SET @BorrowingId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrNum INT = ERROR_NUMBER();
        RAISERROR('Erreur sp_BorrowBook: %s', 16, 1, @ErrMsg);
        RETURN;
    END CATCH
END;
