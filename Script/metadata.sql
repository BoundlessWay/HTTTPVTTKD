--Tạo metadata
CREATE DATABASE METADATA
GO
USE METADATA
GO

--Data structure metadata
CREATE TABLE ds_data_store (
	ds_key INT PRIMARY KEY,
	data_store_name VARCHAR(50),
	desciption NVARCHAR(1000),
	DBMS VARCHAR(50)
)
GO

CREATE TABLE ds_table_type (
	tb_type_key INT PRIMARY KEY,
	table_type VARCHAR(50),
	description NVARCHAR(1000)
)
GO

CREATE TABLE ds_table (
	tb_key INT PRIMARY KEY,
	tb_name VARCHAR(100),
	table_type INT,
	data_store INT,
	description NVARCHAR(1000),

	--Foreign key
	CONSTRAINT FK_table_datastore
	FOREIGN KEY (data_store)
	REFERENCES ds_data_store (ds_key),

	CONSTRAINT FK_table_tabletype 
	FOREIGN KEY (table_type)
	REFERENCES ds_table_type (tb_type_key)
)
GO

CREATE TABLE ds_column_type (
	column_type_key INT PRIMARY KEY,
	column_type_name VARCHAR(50),
	location VARCHAR(100),
	description NVARCHAR(1000),
)
GO

CREATE TABLE ds_column (
	column_key INT PRIMARY KEY,
	table_key INT,
	column_name VARCHAR(50),
	data_type VARCHAR(50),
	is_PK CHAR(5),
	is_FK CHAR(5),
	is_null CHAR(5),
	is_identity CHAR(5),

	CONSTRAINT FL_column_table
	FOREIGN KEY (table_key)
	REFERENCES ds_table (tb_key)
)


go
CREATE TABLE status (
    status_id INT PRIMARY KEY,
    status VARCHAR(50)
);

go
CREATE TABLE data_flow (
    flow_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(255),
    source VARCHAR(50),
    target VARCHAR(50),
    transformation VARCHAR(255),
    status_id INT,
    LSET DATETIME,
    CET DATETIME,
    FOREIGN KEY (status_id) REFERENCES status(status_id)
);



--Audit Metadata
--event_category
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[event_category](
	[id] [int] NOT NULL,
	[event_category] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--event_type
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_type](
	[id] [int] NOT NULL,
	[event_type] [nvarchar](100) NULL,	

PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



--ETL Structure Metadata
INSERT INTO ds_data_store (ds_key, data_store_name, desciption, DBMS) 
VALUES 
(1, 'Stage', ' Staging area', 'SQL Server 2022'),
(2, 'NDS', 'Normalized data store', 'SQL Server 2022'),
(3, 'DDS', 'Dimensional data store', 'SQL Server 2022'),
(4, 'Meta', 'Metadata database', 'SQL Server 2022')
GO


INSERT INTO ds_table_type (tb_type_key, table_type, description) 
VALUES 
(1, 'Dimension', 'Bảng chiều'),
(2, 'Fact', 'Bảng Fact: lưu trữ dữ liệu định lượng hoặc số liệu được sử dụng để phân tích AQI'),
(3, 'Stage', 'Bảng Stage: đóng vai trò là vùng lưu trữ tạm thời cho dữ liệu đang được xử lý trong ETL.'),
(4, 'Master', 'Bảng Master: đóng vai trò lưu trữ thông tin gốc, cố định hoặc tham chiếu, thường được sử dụng để chuẩn hóa và duy trì tính nhất quán trong toàn bộ hệ thống.')
GO


INSERT INTO ds_table (tb_key, tb_name, table_type, data_store, description) 
VALUES 
(1, 'StageDB.dbo.Counties', 3, 1, 'Stage counties: Lưu trữ thông tin hạt ở Stage'),
(2, 'StageDB.dbo.AQI_Measurements', 3, 1, 'Stage AQI: Lưu trữ các đo lường AQI ở Stage'),
(3, 'NDSDB.dbo.State', 4, 2, 'NDS State: lưu trữ thông tin bang ở NDS'),
(4, 'NDSDB.dbo.County', 4, 2, ' NDS County: Lưu trữ thông tin hạt ở NDS'),
(5, 'NDSDB.dbo.Category', 4, 2, 'NDS Category: Lưu trữ thông tin loại AQI ở NDS'),
(6, 'NDSDB.dbo.AQI_Measurement', 4, 2, 'NDS AQI: Lưu trữ thôngt tin đo lường AQI ở NDS'),
(7, 'Dim_State', 1, 3, 'DDS State: Lưu trữ thông tin bang ở DDS'),
(8, 'Dim_County', 1, 3, 'DDS County: Lưu trữ thông tin hạt ở DDS'),
(9, 'Dim_Date', 1, 3, 'DDS Date: Lưu trữ thông tin ngày tháng ở DDS'),
(10, 'Dim_Category', 1, 3, 'DDS Category: Lưu trữ thông tin loại AQI ở DDS'),
(11, 'Dim_DefiningParameter', 1, 3, 'DDS DefingParameter: Lưu trữ thông tin thông số ở DDS'),
(12, 'AQI_Fact', 2, 3, 'DDS Fact_AQI: lưu trữ thông tin về các đo lường AQI ở DDS')
GO

INSERT INTO ds_column_type (column_type_key, column_type_name, location, description) 
VALUES 
(1, 'Surrogate key', 'DDS dimension tables', 'A single not null column that uniquely identifies a row in a dimension table '),
(2, 'Natural key', 'DDS dimension tables', 'Uniquely identifies a dimension row in the source system'),
(3, 'Dimensional attribute ', 'DDS dimension tables', 'Describes a particular property of a dimension'),
(4, 'Measure', 'DDS fact tables', 'Columns in the fact table that contain business measurements or transaction values'),
(5, 'Fact key', 'DDS fact tables', 'A single not null column that uniquely identifies a row on a fact table');
GO

INSERT INTO ds_column (column_key, table_key, column_name, data_type, is_PK, is_FK, is_null, is_identity) 
VALUES 
(1, 1, 'county_fips', 'INT', 'YES', 'NO', 'YES', 'NO'),
(2, 1, 'county', 'VARCHAR(50)', 'NO', 'NO', 'YES', 'NO'),
(3, 1, 'county_asii', 'VARCHAR(5)', 'NO', 'NO', 'YES', 'NO'),
(4, 1, 'county_full', 'VARCHAR(100)', 'NO', 'NO', 'YES', 'NO'),
(5, 1, 'state_id', 'VARCHAR(5)', 'NO', 'NO', 'YES', 'NO'),
(6, 1, 'state_name', 'VARCHAR(50)', 'NO', 'NO', 'YES', 'NO'),
(7, 1, 'lat', 'FLOAT', 'NO', 'NO', 'YES', 'NO'),
(8, 1, 'lng', 'FLOAT', 'NO', 'NO', 'YES', 'NO'),
(9, 1, 'populations', 'INT', 'NO', 'NO', 'YES', 'NO'),
(10, 2, 'state_name', 'VARCHAR(50)', 'NO', 'NO', 'YES', 'NO'),
(11, 2, 'county_name', 'VARCHAR(50)', 'NO', 'NO', 'YES', 'NO'),
(12, 2, 'state_code', 'VARCHAR(50)', 'YES', 'NO', 'YES', 'NO'),
(13, 2, 'county_code', 'VARCHAR(50)', 'YES', 'NO', 'YES', 'NO'),
(14, 2, 'date', 'DATE', 'NO', 'NO', 'YES', 'NO'),
(15, 2, 'AQI', 'INT', 'NO', 'NO', 'YES', 'NO'),
(16, 2, 'category', 'VARCHAR(50)', 'NO', 'NO', 'YES', 'NO'),
(17, 2, 'defining_parameter', 'VARCHAR(50)', 'NO', 'NO', 'YES', 'NO'),
(18, 2, 'defining_site', 'VARCHAR(50)', 'NO', 'NO', 'YES', 'NO'),
(19, 2, 'num_sites_reporting', 'INT', 'NO', 'NO', 'YES', 'NO'),
(20, 2, 'created', 'DATETIME', 'YES', 'NO', 'YES', 'NO'),
(21, 2, 'last_updated', 'DATETIME', 'YES', 'NO', 'YES', 'NO'),
(22, 3, 'state_id', 'INT IDENTITY(1,1)', 'YES', 'NO', 'NO', 'YES'),
(23, 3, 'state_code', 'VARCHAR(2)', 'NO', 'NO', 'NO', 'NO'),
(24, 3, 'state_name', 'VARCHAR(255)', 'NO', 'NO', 'NO', 'NO'),
(25, 3, 'state_abbr', 'VARCHAR(2)', 'NO', 'NO', 'NO', 'NO'),
(26, 4, 'county_id', 'INT IDENTITY(1,1)', 'YES', 'NO', 'NO', 'YES'),
(27, 4, 'county_fips', 'VARCHAR(5)', 'NO', 'NO', 'NO', 'NO'),
(28, 4, 'county_name', 'VARCHAR(255)', 'NO', 'NO', 'NO', 'NO'),
(29, 4, 'county_ascii', 'VARCHAR(255)', 'NO', 'NO', 'NO', 'NO'),
(30, 4, 'county_full', 'VARCHAR(255)', 'NO', 'NO', 'NO', 'NO'),
(31, 4, 'county_code', 'VARCHAR(3)', 'NO', 'NO', 'NO', 'NO'),
(32, 4, 'lat',  'DECIMAL(9, 6)', 'NO', 'NO', 'NO', 'NO'),
(33, 4, 'lng',  'DECIMAL(9, 6)', 'NO', 'NO', 'NO', 'NO'),
(34, 4, 'population', 'INT', 'NO', 'NO', 'NO', 'NO'),
(35, 4, 'state_code', 'VARCHAR(2)', 'NO', 'YES', 'NO', 'NO'),
(36, 4, 'created_date', 'DATETIME DEFAULT GETDATE()', 'NO', 'NO', 'NO', 'NO'),
(37, 4, 'updated_date', 'DATETIME DEFAULT GETDATE()', 'NO', 'NO', 'NO', 'NO'),
(38, 5, 'measurement_id', 'VARCHAR(3)', 'YES', 'NO', 'NO', 'NO'),
(39, 5, 'county_code', 'DATE', 'NO', 'NO', 'NO', 'NO'),
(40, 5, 'date', 'INT', 'NO', 'NO', 'NO', 'NO'),
(41, 5, 'aqi', 'VARCHAR(255)', 'NO', 'NO', 'NO', 'NO'),
(42, 5, 'defining_parameter', 'VARCHAR(255)', 'NO', 'NO', 'NO', 'NO'),
(43, 5, 'defining_site', 'INT', 'NO', 'NO', 'NO', 'NO'),
(44, 5, 'num_sites_reporting', 'INT', 'NO', 'NO', 'NO', 'NO'),
(45, 5, 'category_id', 'VARCHAR(50)', 'NO', 'YES', 'NO', 'NO'),
(46, 5, 'county_fips', 'VARCHAR(5)', 'NO', 'YES', 'NO', 'NO'),
(47, 5, 'created_date', 'DATETIME DEFAULT GETDATE()', 'NO', 'NO', 'NO', 'NO'),
(48, 5, 'updated_date', 'DATETIME DEFAULT GETDATE()', 'NO', 'NO', 'NO', 'NO'),
(49, 6, 'category_id', 'INT IDENTITY(1,1)', 'YES', 'NO', 'NO', 'YES'),
(50, 6, 'catagory_name', 'VARCHAR(255)', 'NO', 'NO', 'NO', 'NO'),
(51, 6, 'lower_bound', 'INT', 'NO', 'NO', 'NO', 'NO'),
(52, 6, 'upper_bound', 'INT', 'NO', 'NO', 'NO', 'NO'),
(53, 6, 'aqi_color', 'VARCHAR(255)', 'NO', 'NO', 'NO', 'NO'),
(54, 6, 'description', 'VARCHAR(255)', 'NO', 'NO', 'NO', 'NO'),
(55, 7, 'state_id', 'INT', 'YES', 'NO', 'NO', 'NO'),
(56, 7, 'state_code', 'VARCHAR(2)', 'NO', 'NO', 'NO', 'NO'),
(57, 7, 'state_name', 'VARCHAR(255)', 'NO', 'NO', 'NO', 'NO'),
(58, 7, 'state_abbr', 'INT', 'NO', 'NO', 'NO', 'NO'),
(59, 8, 'county_id', 'INT', 'YES', 'NO', 'NO', 'YES'),
(60, 8, 'county_name', 'VARCHAR(255)', 'NO', 'NO', 'NO', 'NO'),
(61, 8, 'county_fips', 'VARCHAR(5)', 'NO', 'NO', 'NO', 'NO'),
(62, 8, 'state_id', 'INT', 'NO', 'YES', 'NO', 'NO'),
(63, 9, 'date_id', 'INT', 'YES', 'NO', 'NO', 'NO'),
(64, 9, 'date', 'DATE', 'NO', 'NO', 'NO', 'NO'),
(65, 9, 'quater', 'INT', 'NO', 'NO', 'YES', 'NO'),
(66, 9, 'month', 'INT', 'NO', 'NO', 'YES', 'NO'),
(67, 9, 'year', 'INT', 'NO', 'NO', 'YES', 'NO'),
(68, 9, 'day', 'INT', 'NO', 'NO', 'YES', 'NO'),
(69, 9, 'daylightsaving', 'BIT', 'NO', 'NO', 'NO', 'NO'),
(70, 10, 'parameter_id', 'INT IDENTITY(1,1)', 'YES', 'NO', 'NO', 'YES'),
(71, 10, 'parameter_name', 'VARCHAR(255)', 'NO', 'NO', 'YES', 'NO'),
(72, 11, 'category_id', 'INT', 'YES', 'NO', 'NO', 'NO'),
(73, 11, 'category_name', 'VARCHAR(255)', 'NO', 'NO', 'YES', 'NO'),
(74, 11, 'min_value', 'INT', 'NO', 'NO', 'YES', 'NO'),
(75, 11, 'max_value', 'INT', 'NO', 'NO', 'YES', 'NO'),
(76, 11, 'aqi_color', 'VARCHAR(255)', 'NO', 'NO', 'YES', 'NO'),
(77, 11, 'description', 'VARCHAR(255)', 'NO', 'NO', 'YES', 'NO'),
(78, 12, 'fact_id', 'INT IDENTITY(1,1)', 'YES', 'NO', 'NO', 'YES'),
(79, 12, 'county_id', 'INT', 'NO', 'YES', 'NO', 'NO'),
(80, 12, 'date_id', 'INT', 'NO', 'YES', 'NO', 'NO'),
(81, 12, 'category_id', 'INT', 'NO', 'YES', 'NO', 'NO'),
(82, 12, 'parameter_id', 'INT', 'NO', 'YES', 'NO', 'NO'),
(83, 12, 'mean_aqi', 'FLOAT', 'NO', 'NO', 'YES', 'NO'),
(84, 12, 'std_aqi', 'FLOAT', 'NO', 'NO', 'YES', 'NO'),
(85, 12, 'min_aqi', 'INT', 'NO', 'NO', 'YES', 'NO'),
(86, 12, 'max_aqi', 'INT', 'NO', 'NO', 'YES', 'NO'),
(87, 12, 'count_day', 'INT', 'NO', 'NO', 'YES', 'NO'),
(88, 12, 'sum_aqi', 'INT', 'NO', 'NO', 'YES', 'NO'),
(89, 12, 'sum_squares_aqi', 'FLOAT', 'NO', 'NO', 'YES', 'NO'),
(90, 12, 'count_aqi', 'INT', 'NO', 'NO', 'YES', 'NO');
GO


--ETL Process Metadata
INSERT INTO status (status_id, status) VALUES
(0, 'Unknown'),
(1, 'Success'),
(2, 'Failed'),
(3, 'In progress');
GO


--Event category
INSERT INTO event_category (id, event_category)
VALUES
    (1, 'Stage ETL'),
    (2, 'NDS ETL'),
    (3, 'DDS ETL');


--event type
INSERT INTO event_type (id, event_type)
VALUES
    (1, 'Load Source County'),
    (2, 'Load Source AQI_Measurements'),
    (3, 'Load Stage County'),
    (4, 'Load Stage AQI_Measurements'),
    (5, 'Load NDS State'),
	(6, 'Load NDS Counties'),
	(7, 'Load NDS Category'),
    (8, 'Load NDS AQI_Measurements'),
	(9, 'Load DDS State'),
    (10, 'Load DDS Dim County'),
    (11, 'Load DDS Dim Category'),
    (12, 'Load DDS Fact AQI_Measurements'),
	(13, 'Load DDS Dim Date'),
    (14, 'Load DDS Dim DefiningParameter'),
    (15, 'Load DDS Dim State');






