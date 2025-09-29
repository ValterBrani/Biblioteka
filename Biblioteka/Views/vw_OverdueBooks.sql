CREATE VIEW Library.vw_OverdueBooks
AS
SELECT 
    br.BorrowingId,
    m.MemberId,
    m.FirstName,
    m.LastName,
    b.BookId,
    b.Title,
    br.DueDate,
    br.ReturnDate
FROM Library.Borrowings br
    JOIN Library.Members m ON br.MemberId = m.MemberId
    JOIN Library.Books b ON br.BookId = b.BookId
WHERE br.ReturnDate IS NULL 
    AND br.DueDate < SYSUTCDATETIME();