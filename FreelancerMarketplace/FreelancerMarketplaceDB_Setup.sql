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
