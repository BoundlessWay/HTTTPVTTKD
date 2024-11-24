CREATE DATABASE DDSDB;
GO
USE DDSDB;
GO

CREATE TABLE Dim_State (
    StateKey INT IDENTITY(1,1) PRIMARY KEY,
    StateName VARCHAR(50) NOT NULL,
    StateCode VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Dim_County (
    CountyKey INT IDENTITY(1,1) PRIMARY KEY,
    CountyName VARCHAR(50) NOT NULL,
    CountyFIPS VARCHAR(50) NOT NULL UNIQUE,
    StateKey INT NOT NULL,
    FOREIGN KEY (StateKey) REFERENCES Dim_State(StateKey)
);

CREATE TABLE Dim_Date (
    DateKey CHAR(8) PRIMARY KEY,
    Date DATE NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Day INT NOT NULL
);

CREATE TABLE Fact_AQI (
    FactID INT IDENTITY(1,1) PRIMARY KEY,
    StateKey INT NOT NULL,
    CountyKey INT NOT NULL,
    DateKey CHAR(8) NOT NULL,
    Quarter INT NOT NULL,
    AQI_Value FLOAT NOT NULL,
    AQI_Category VARCHAR(50),
    Is_VeryUnhealthy BIT NOT NULL,
    Days_Count INT NOT NULL,
    Mean_AQI FLOAT NOT NULL,
    StdDev_AQI FLOAT NOT NULL,
    FOREIGN KEY (StateKey) REFERENCES Dim_State(StateKey),
    FOREIGN KEY (CountyKey) REFERENCES Dim_County(CountyKey),
    FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey)
);

/*INSERT INTO Dim_State (StateName, StateCode)
SELECT DISTINCT state_name, state_code
FROM NDSDB.dbo.States;

INSERT INTO Dim_County (CountyName, CountyFIPS, StateKey)
SELECT DISTINCT c.county_name, c.county_fips, s.StateKey
FROM NDSDB.dbo.Counties c
JOIN Dim_State s ON c.state_code = s.StateCode;

INSERT INTO Dim_Date (DateKey, Date, Year, Quarter, Month, Day)
SELECT DISTINCT 
    FORMAT(date, 'yyyyMMdd') AS DateKey,
    date AS Date,
    YEAR(date) AS Year,
    DATEPART(QUARTER, date) AS Quarter,
    MONTH(date) AS Month,
    DAY(date) AS Day
FROM NDSDB.dbo.AQI_Measurements;

INSERT INTO Fact_AQI (StateKey, CountyKey, DateKey, Quarter, AQI_Value, AQI_Category, Is_VeryUnhealthy, Days_Count, Mean_AQI, StdDev_AQI)
SELECT
    c.CountyKey,
    FORMAT(a.date, 'yyyyMMdd') AS DateKey,
    DATEPART(QUARTER, a.date) AS Quarter,
    a.aqi AS AQI_Value,
    cat.category_name AS AQI_Category,
    CASE WHEN a.aqi >= 201 THEN 1 ELSE 0 END AS Is_VeryUnhealthy,
    COUNT(*) OVER (PARTITION BY s.StateKey, c.CountyKey, DATEPART(QUARTER, a.date)) AS Days_Count,
    AVG(a.aqi) OVER (PARTITION BY s.StateKey, c.CountyKey, DATEPART(QUARTER, a.date)) AS Mean_AQI,
    STDEV(a.aqi) OVER (PARTITION BY s.StateKey, c.CountyKey, DATEPART(QUARTER, a.date)) AS StdDev_AQI
FROM NDSDB.dbo.AQI_Measurements a
JOIN Dim_County c ON a.county_fips = c.CountyFIPS
JOIN Dim_Date d ON FORMAT(a.date, 'yyyyMMdd') = d.DateKey
JOIN NDSDB.dbo.Category cat ON a.category_id = cat.category_id;
*/