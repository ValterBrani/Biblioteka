CREATE FUNCTION Library.fn_CalculatePenalty
(
@DueDate DATETIME2,
@ReturnDate DATETIME2,
@PolicyId INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
DECLARE @daysLate INT = 0;
DECLARE @penalty DECIMAL(10,2) = 0;
DECLARE @amountPerDay DECIMAL(10,2) = 0;
DECLARE @graceDays INT = 0;


IF @ReturnDate IS NULL
SET @ReturnDate = SYSUTCDATETIME();


SELECT @amountPerDay = AmountPerDay, @graceDays = GraceDays
FROM Library.PenaltyPolicies WHERE PolicyId = @PolicyId;


IF @amountPerDay IS NULL
SET @amountPerDay = 0;
IF @graceDays IS NULL
SET @graceDays = 0;


SET @daysLate = DATEDIFF(day, @DueDate, @ReturnDate) - @graceDays;
IF @daysLate < 0 SET @daysLate = 0;


SET @penalty = CAST(@daysLate AS DECIMAL(10,2)) * @amountPerDay;


RETURN @penalty;
END;