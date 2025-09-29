CREATE TABLE Library.PenaltyPolicies (
    PolicyId        INT IDENTITY(1,1) PRIMARY KEY,
    Name            NVARCHAR(200) NOT NULL,
    AmountPerDay    DECIMAL(10,2) NOT NULL 
                        CONSTRAINT CHK_PenaltyPolicies_Pos 
                        CHECK (AmountPerDay >= 0),
    GraceDays       INT NOT NULL DEFAULT(0) 
                        CONSTRAINT CHK_PenaltyPolicies_Grace 
                        CHECK(GraceDays >= 0)
);