CREATE TABLE Library.Members (
    MemberId        INT IDENTITY(1,1) PRIMARY KEY,
    FirstName       NVARCHAR(100) NOT NULL,
    LastName        NVARCHAR(100) NOT NULL,
    Email           NVARCHAR(255) NULL,
    JoinDate        DATETIME NOT NULL DEFAULT GETUTCDATE(),
    Phone           NVARCHAR(50) NULL,
    MembershipDate  DATE NOT NULL DEFAULT (CONVERT(date, GETDATE())),
    IsActive        BIT NOT NULL DEFAULT(1),
    
    CONSTRAINT UQ_Members_Email UNIQUE (Email)
);
