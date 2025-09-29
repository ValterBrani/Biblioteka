CREATE VIEW Library.vw_ActivePenalties
AS
SELECT 
    r.ReturnId,
    m.MemberId,
    m.FirstName,
    m.LastName,
    b.Title,
    r.Penalty,
    r.ReturnedAt
FROM Library.Returns r
    JOIN Library.Borrowings br ON r.BorrowingId = br.BorrowingId
    JOIN Library.Members m ON br.MemberId = m.MemberId
    JOIN Library.Books b ON br.BookId = b.BookId
WHERE r.Penalty > 0;