CREATE DATABASE DDSDB;
GO
USE DDSDB;
GO


CREATE TABLE Dim_State (
    state_id INT PRIMARY KEY,
	state_code VARCHAR(2) NOT NULL UNIQUE,
    state_name VARCHAR(255) NOT NULL,
	state_abbr VARCHAR(2) NOT NULL                            
);


CREATE TABLE Dim_County (
    county_id INT PRIMARY KEY,
    county_name VARCHAR(255) NOT NULL,
    county_fips VARCHAR(5) NOT NULL UNIQUE,
    state_id INT NOT NULL,
    FOREIGN KEY (state_id) REFERENCES Dim_State(state_id)
);


CREATE TABLE Dim_Date (
	date_id INT PRIMARY KEY,
    date DATE NOT NULL,
    quarter INT NULL,
    month INT NULL,
    year INT NULL,
	day INT NULL,
    daylightsaving BIT NOT NULL -- 0 for False, 1 for True
);


CREATE TABLE Dim_Category (
    category_id INT PRIMARY KEY,  
    category_name VARCHAR(255),         
    min_value INT,                   
    max_value INT,  
	aqi_color VARCHAR(255),
    description varchar(255)                         
);

CREATE TABLE Dim_DefiningParameter (
    parameter_id INT IDENTITY(1,1) PRIMARY KEY,
    parameter_name VARCHAR(255)
);

CREATE TABLE AQI_Fact (
    fact_id INT IDENTITY(1,1) PRIMARY KEY,
    county_id INT NOT NULL,
    date_id INT NOT NULL,
    category_id INT NOT NULL,
    parameter_id INT NOT NULL,
    mean_aqi FLOAT NOT NULL,
    std_aqi FLOAT NOT NULL,
    min_aqi INT NOT NULL,
    max_aqi INT NOT NULL,
    count_day INT NOT NULL,
	sum_aqi INT NOT NULL,         
    sum_squares_aqi FLOAT NOT NULL,
	count_aqi INT NOT NULL, 
    FOREIGN KEY (county_id) REFERENCES Dim_County(county_id),
    FOREIGN KEY (date_id) REFERENCES Dim_Date(date_id),
    FOREIGN KEY (category_id) REFERENCES Dim_Category(category_id),
    FOREIGN KEY (parameter_id) REFERENCES Dim_DefiningParameter(parameter_id)
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
*/