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

