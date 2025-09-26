CREATE TRIGGER Library.tr_Borrowings_Update
ON Library.Borrowings
AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON;


-- Si ReturnDate est pass� de NULL � not NULL -> incr�menter AvailableCopies
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