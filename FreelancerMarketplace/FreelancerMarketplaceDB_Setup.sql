-- ============================================================
-- Freelancer Marketplace for Students
-- Database Setup Script — v2 (with Password column)
-- Run this script in SQL Server Management Studio (SSMS)
-- ============================================================

-- Step 1: Create the database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'FreelancerMarketplaceDB')
BEGIN
    CREATE DATABASE FreelancerMarketplaceDB;
END
GO

-- Step 2: Use the database
USE FreelancerMarketplaceDB;
GO

-- Step 3: Create Registration_tbl
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Registration_tbl')
BEGIN
    CREATE TABLE Registration_tbl (
        Id          INT PRIMARY KEY IDENTITY(1,1),
        Name        NVARCHAR(100),
        Gender      NVARCHAR(10),
        Email       NVARCHAR(100),
        City        NVARCHAR(50),
        Address     NVARCHAR(250),
        Mobile      NVARCHAR(15),
        Role        NVARCHAR(20),
        Password    NVARCHAR(100),
        Image       NVARCHAR(250),
        CreatedDate DATETIME DEFAULT GETDATE()
    );
    PRINT 'Registration_tbl created successfully.';
END
ELSE
BEGIN
    -- Add Password column if it doesn't exist (for existing databases)
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Registration_tbl') AND name = 'Password')
    BEGIN
        ALTER TABLE Registration_tbl ADD Password NVARCHAR(100);
        PRINT 'Password column added to Registration_tbl.';
    END
    -- Add CreatedDate column if it doesn't exist (for existing databases)
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Registration_tbl') AND name = 'CreatedDate')
    BEGIN
        ALTER TABLE Registration_tbl ADD CreatedDate DATETIME DEFAULT GETDATE();
        PRINT 'CreatedDate column added to Registration_tbl.';
    END
    PRINT 'Registration_tbl already exists — updated.';
END
GO

-- Step 4: No default admin row needed (admin is hard-coded in Login.aspx.cs)
PRINT 'Database setup complete!';
GO

-- Step 5: Student Panel Support Tables

-- Categories table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Categories_tbl')
BEGIN
    CREATE TABLE Categories_tbl (
        CategoryId   INT PRIMARY KEY IDENTITY(1,1),
        CategoryName NVARCHAR(100) NOT NULL,
        Status       NVARCHAR(20) DEFAULT 'Active'
    );
    PRINT 'Categories_tbl created successfully.';
END
GO

-- Projects table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Projects_tbl')
BEGIN
    CREATE TABLE Projects_tbl (
        ProjectId   INT PRIMARY KEY IDENTITY(1,1),
        ClientId    INT,
        ClientEmail NVARCHAR(100),
        Title       NVARCHAR(200) NOT NULL,
        Category    NVARCHAR(100),
        Budget      DECIMAL(18,2),
        Description NVARCHAR(MAX),
        Status      NVARCHAR(50) DEFAULT 'Open',
        CreatedDate DATETIME DEFAULT GETDATE()
    );
    PRINT 'Projects_tbl created successfully.';
END
GO

-- Applications table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Applications_tbl')
BEGIN
    CREATE TABLE Applications_tbl (
        AppId        INT PRIMARY KEY IDENTITY(1,1),
        ProjectId    INT NOT NULL,
        StudentEmail NVARCHAR(100) NOT NULL,
        Proposal     NVARCHAR(MAX),
        BidAmount    DECIMAL(18,2),
        DeliveryDays INT,
        Status       NVARCHAR(50) DEFAULT 'Pending',
        AppliedDate  DATETIME DEFAULT GETDATE()
    );
    PRINT 'Applications_tbl created successfully.';
END
GO

-- Bids table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Bids_tbl')
BEGIN
    CREATE TABLE Bids_tbl (
        BidId        INT PRIMARY KEY IDENTITY(1,1),
        ProjectId    INT NOT NULL,
        StudentId    INT,
        StudentEmail NVARCHAR(100),
        BidAmount    DECIMAL(18,2),
        Proposal     NVARCHAR(MAX),
        Status       NVARCHAR(50) DEFAULT 'Pending',
        BidDate      DATETIME DEFAULT GETDATE()
    );
    PRINT 'Bids_tbl created successfully.';
END
GO

-- Activity Logs table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ActivityLogs_tbl')
BEGIN
    CREATE TABLE ActivityLogs_tbl (
        LogId        INT PRIMARY KEY IDENTITY(1,1),
        UserId       INT,
        Activity     NVARCHAR(500),
        ActivityDate DATETIME DEFAULT GETDATE()
    );
    PRINT 'ActivityLogs_tbl created successfully.';
END
GO

-- Notifications table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Notifications_tbl')
BEGIN
    CREATE TABLE Notifications_tbl (
        NotificationId INT PRIMARY KEY IDENTITY(1,1),
        UserId         INT,
        UserEmail      NVARCHAR(100),
        Message        NVARCHAR(500),
        IsRead         BIT DEFAULT 0,
        CreatedDate    DATETIME DEFAULT GETDATE()
    );
    PRINT 'Notifications_tbl created successfully.';
END
GO
