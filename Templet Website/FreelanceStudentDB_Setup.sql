-- ============================================================
-- FreelanceStudentDB - Database Setup Script
-- Run this in SQL Server Management Studio (SSMS) or
-- Visual Studio > Tools > Connect to Database
-- ============================================================

-- Create and use the database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'FreelanceStudentDB')
    CREATE DATABASE FreelanceStudentDB;
GO

USE FreelanceStudentDB;
GO

-- ============================================================
-- Table: Users
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
CREATE TABLE Users (
    UserID       INT IDENTITY(1,1) PRIMARY KEY,
    FullName     NVARCHAR(100)  NOT NULL,
    Username     NVARCHAR(50)   NOT NULL UNIQUE,
    Email        NVARCHAR(150)  NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255)  NOT NULL,
    UserType     NVARCHAR(20)   NOT NULL CHECK (UserType IN ('Student', 'Client', 'Admin')),
    CreatedAt    DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- Table: Projects
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Projects')
CREATE TABLE Projects (
    ProjectID    INT IDENTITY(1,1) PRIMARY KEY,
    ClientID     INT            NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    Title        NVARCHAR(200)  NOT NULL,
    Description  NVARCHAR(MAX),
    Category     NVARCHAR(100),
    Budget       DECIMAL(10,2),
    Deadline     DATE,
    Status       NVARCHAR(20)   NOT NULL DEFAULT 'Open' CHECK (Status IN ('Open', 'In Progress', 'Completed', 'Cancelled')),
    CreatedAt    DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- Table: Applications
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Applications')
CREATE TABLE Applications (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID     INT            NOT NULL FOREIGN KEY REFERENCES Projects(ProjectID),
    StudentID     INT            NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    CoverLetter   NVARCHAR(MAX),
    Status        NVARCHAR(20)   NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Accepted', 'Rejected')),
    AppliedAt     DATETIME       NOT NULL DEFAULT GETDATE(),
    UNIQUE (ProjectID, StudentID)   -- One application per student per project
);
GO

-- ============================================================
-- Table: Portfolio
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Portfolio')
CREATE TABLE Portfolio (
    PortfolioID  INT IDENTITY(1,1) PRIMARY KEY,
    StudentID    INT            NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    Title        NVARCHAR(200)  NOT NULL,
    Description  NVARCHAR(MAX),
    FileUrl      NVARCHAR(500),
    UploadedAt   DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- Seed Data: Default Admin Account
-- Username: admin   Password: admin123
-- CHANGE THE PASSWORD AFTER FIRST LOGIN!
-- ============================================================
IF NOT EXISTS (SELECT * FROM Users WHERE Username = 'admin')
    INSERT INTO Users (FullName, Username, Email, PasswordHash, UserType)
    VALUES ('System Admin', 'admin', 'admin@freelancehub.com', 'admin123', 'Admin');
GO

PRINT 'Database setup complete! Default admin: username=admin, password=admin123';
GO
