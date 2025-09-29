CREATE TRIGGER Library.tr_Borrowings_Insert
ON Library.Borrowings
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Décrémenter AvailableCopies pour chaque nouveau livre emprunté
    UPDATE b
    SET AvailableCopies = AvailableCopies - cnt.Num
    FROM Library.Books b
        JOIN (
            SELECT 
                i.BookId, 
                COUNT(*) AS Num
            FROM inserted i
            GROUP BY i.BookId
        ) cnt ON b.BookId = cnt.BookId
    WHERE b.AvailableCopies >= cnt.Num;

    -- Vérifier qu'il n'y a pas d'emprunt avec AvailableCopies négatif
    IF EXISTS (
        SELECT 1 
        FROM Library.Books b
            JOIN inserted i ON b.BookId = i.BookId
        WHERE b.AvailableCopies < 0
    )
    BEGIN
        RAISERROR('Impossible d''emprunter : nombre de copies disponibles insuffisant.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;