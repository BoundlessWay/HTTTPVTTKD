-- Tạo cơ sở dữ liệu
CREATE DATABASE AirQualityData;
GO

-- Sử dụng cơ sở dữ liệu vừa tạo
USE AirQualityData;
GO

-- Bảng States
CREATE TABLE States (
	StateCode INT PRIMARY KEY,
    StateID VARCHAR(2) UNIQUE NOT NULL,
    StateName VARCHAR(50) NOT NULL,
	SourceID VARCHAR(20) NOT NULL,
	CreatedData	DATETIME NOT NULL,
	UpdatedData	DATETIME NOT NULL

);

-- Bảng Counties
CREATE TABLE Counties (
    CountyCode VARCHAR(2) PRIMARY KEY,
    CountyName VARCHAR(50) NOT NULL,
    CountyASCII VARCHAR(5) NOT NULL,
    CountyFull VARCHAR(60) NOT NULL,
    CountyFips INT NOT NULL,
	Latitude FLOAT NOT NULL,
    Longitude FLOAT NOT NULL,
	Populations INT NOT NULL,
    StateCode INT NOT NULL,
	SourceID VARCHAR(20) NOT NULL,
	CreatedData	DATETIME NOT NULL,
	UpdatedData	DATETIME NOT NULL
    FOREIGN KEY (StateCode) REFERENCES States(StateCode)
);

-- Bảng AQICategory
CREATE TABLE AQICategory (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(20) NOT NULL,
	SourceID VARCHAR(20) NOT NULL,
	CreatedData	DATETIME NOT NULL,
	UpdatedData	DATETIME NOT NULL
);


-- Bảng AirQuality
CREATE TABLE AirQuality (
    AQIID INT PRIMARY KEY IDENTITY(1,1),
    Dates DATE NOT NULL,
    AQI INT NOT NULL,
	DefiningParameter VARCHAR(10) NOT NULL,
    DefiningSite VARCHAR(20) NOT NULL,
    NumSitesReporting INT NOT NULL,
    CategoryID INT NOT NULL,
	CountyCode VARCHAR(2) NOT NULL,
	SourceID VARCHAR(20) NOT NULL,
	CreatedData	DATETIME NOT NULL,
	UpdatedData	DATETIME NOT NULL
    FOREIGN KEY (CountyCode) REFERENCES Counties(CountyCode),
    FOREIGN KEY (CategoryID) REFERENCES AQICategory(CategoryID)
);

