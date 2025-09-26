CREATE VIEW Library.vw_BorrowedBooksByMember
AS
SELECT m.MemberId, m.FirstName, m.LastName, b.BookId, b.Title, br.BorrowDate, br.DueDate, br.ReturnDate, br.Penalty
FROM Library.Members m
JOIN Library.Borrowings br ON m.MemberId = br.MemberId
JOIN Library.Books b ON br.BookId = b.BookId;