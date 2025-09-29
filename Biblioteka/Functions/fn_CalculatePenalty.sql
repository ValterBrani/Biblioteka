CREATE FUNCTION Library.fn_CalculatePenalty
(
    @DueDate        DATETIME2,
    @ReturnDate     DATETIME2,
    @PolicyId       INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    -- Déclaration des variables
    DECLARE @daysLate       INT = 0;
    DECLARE @penalty        DECIMAL(10,2) = 0;
    DECLARE @amountPerDay   DECIMAL(10,2) = 0;
    DECLARE @graceDays      INT = 0;

    -- Définir la date de retour par défaut si NULL
    IF @ReturnDate IS NULL
        SET @ReturnDate = SYSUTCDATETIME();

    -- Récupérer les paramètres de la politique de pénalité
    SELECT 
        @amountPerDay = AmountPerDay, 
        @graceDays = GraceDays
    FROM Library.PenaltyPolicies 
    WHERE PolicyId = @PolicyId;

    -- Valeurs par défaut si la politique n'existe pas
    IF @amountPerDay IS NULL
        SET @amountPerDay = 0;
    
    IF @graceDays IS NULL
        SET @graceDays = 0;

    -- Calculer le nombre de jours de retard (après la période de grâce)
    SET @daysLate = DATEDIFF(day, @DueDate, @ReturnDate) - @graceDays;
    
    IF @daysLate < 0 
        SET @daysLate = 0;

    -- Calculer la pénalité
    SET @penalty = CAST(@daysLate AS DECIMAL(10,2)) * @amountPerDay;

    RETURN @penalty;
END;