CREATE FUNCTION Library.fn_CalculatePenalty
(
    @DueDate        DATETIME2,
    @ReturnDate     DATETIME2,
    @PolicyId       INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    -- D�claration des variables
    DECLARE @daysLate       INT = 0;
    DECLARE @penalty        DECIMAL(10,2) = 0;
    DECLARE @amountPerDay   DECIMAL(10,2) = 0;
    DECLARE @graceDays      INT = 0;

    -- D�finir la date de retour par d�faut si NULL
    IF @ReturnDate IS NULL
        SET @ReturnDate = SYSUTCDATETIME();

    -- R�cup�rer les param�tres de la politique de p�nalit�
    SELECT 
        @amountPerDay = AmountPerDay, 
        @graceDays = GraceDays
    FROM Library.PenaltyPolicies 
    WHERE PolicyId = @PolicyId;

    -- Valeurs par d�faut si la politique n'existe pas
    IF @amountPerDay IS NULL
        SET @amountPerDay = 0;
    
    IF @graceDays IS NULL
        SET @graceDays = 0;

    -- Calculer le nombre de jours de retard (apr�s la p�riode de gr�ce)
    SET @daysLate = DATEDIFF(day, @DueDate, @ReturnDate) - @graceDays;
    
    IF @daysLate < 0 
        SET @daysLate = 0;

    -- Calculer la p�nalit�
    SET @penalty = CAST(@daysLate AS DECIMAL(10,2)) * @amountPerDay;

    RETURN @penalty;
END;