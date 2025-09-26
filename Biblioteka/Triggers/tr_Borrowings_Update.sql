CREATE TRIGGER Library.tr_Borrowings_Update
ON Library.Borrowings
AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON;


-- Si ReturnDate est passé de NULL à not NULL -> incrémenter AvailableCopies
UPDATE b
SET AvailableCopies = AvailableCopies + cnt.Num
FROM Library.Books b
JOIN (
SELECT i.BookId, COUNT(*) AS Num
FROM inserted i
JOIN deleted d ON i.BorrowingId = d.BorrowingId
WHERE d.ReturnDate IS NULL AND i.ReturnDate IS NOT NULL
GROUP BY i.BookId
) cnt ON b.BookId = cnt.BookId;
END;