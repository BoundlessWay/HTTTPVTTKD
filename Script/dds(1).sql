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

CREATE TABLE Dim_Category (
    CategoryKey INT IDENTITY(1,1) PRIMARY KEY,  
    CategoryName VARCHAR(50) NOT NULL,         
    MinValue FLOAT NOT NULL,                   
    MaxValue FLOAT NOT NULL,                  
    Description TEXT                           
);

CREATE TABLE Fact_AQI (
    FactID INT IDENTITY(1,1) PRIMARY KEY,
    CountyKey INT NOT NULL,
    DateKey CHAR(8) NOT NULL,
    AQI_Value FLOAT NOT NULL,
    AQI_CategoryKey INT,
    Is_VeryUnhealthy BIT NOT NULL,
    Days_Count INT NOT NULL,
    Mean_AQI FLOAT NOT NULL,
    StdDev_AQI FLOAT NOT NULL,

    FOREIGN KEY (CountyKey) REFERENCES Dim_County(CountyKey),
    FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey),
    FOREIGN KEY (AQI_CategoryKey) REFERENCES Dim_Category(CategoryKey)
);

/*SELECT 
    S.StateName,
    D.Year,
    D.Quarter,
    AVG(F.AQI_Value) AS AvgAQI
FROM Fact_AQI F
JOIN Dim_County C ON F.CountyKey = C.CountyKey
JOIN Dim_State S ON C.StateKey = S.StateKey
JOIN Dim_Date D ON F.DateKey = D.DateKey
GROUP BY S.StateName, D.Year, D.Quarter;
*/

/*SELECT 
    C.CountyName,
    S.StateName,
    D.Year,
    SUM(F.Days_Count) AS TotalDays,
    AVG(F.Mean_AQI) AS AvgAQI
FROM Fact_AQI F
JOIN Dim_County C ON F.CountyKey = C.CountyKey
JOIN Dim_State S ON C.StateKey = S.StateKey
JOIN Dim_Date D ON F.DateKey = D.DateKey
GROUP BY C.CountyName, S.StateName, D.Year;
*/

