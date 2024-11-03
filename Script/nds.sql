-- Tạo Database NDSDB
CREATE DATABASE NDSDB;
GO

-- Sử dụng Database NDSDB
USE NDSDB;
GO

-- Bảng States: Lưu trữ thông tin về các bang
CREATE TABLE NDSDB.dbo.States (
    state_id INT IDENTITY(1,1) PRIMARY KEY,					-- Khóa phụ tự tăng
    state_code VARCHAR(50) NOT NULL UNIQUE,					-- Mã định danh duy nhất của bang
    state_name VARCHAR(50) NOT NULL,						-- Tên bang
    state_abbreviation VARCHAR(50) NOT NULL					-- Tên viết tắt của bang
);
GO

-- Bảng Counties: Lưu trữ thông tin về các quận/huyện
CREATE TABLE NDSDB.dbo.Counties (
    county_id INT IDENTITY(1,1) PRIMARY KEY,							-- Khóa phụ tự tăng
    county_fips VARCHAR(50) UNIQUE NOT NULL,							-- Mã định danh duy nhất cho mỗi quận (FIPS)
    county_name VARCHAR(50),											-- Tên quận
    county_ascii VARCHAR(50),											-- Tên quận không dấu
    county_full VARCHAR(100),											-- Tên đầy đủ của quận
    state_code VARCHAR(50) NOT NULL,									-- Mã định danh bang, khóa ngoại tham chiếu đến States
    county_code VARCHAR(50) NOT NULL,                                   -- Mã quận nội bang
    lat FLOAT,															-- Vĩ độ của quận
    lng FLOAT,															-- Kinh độ của quận
    population INT,														-- Dân số của quận
    created_date DATETIME DEFAULT GETDATE(),							-- Ngày tạo bản ghi
    updated_date DATETIME DEFAULT GETDATE(),							-- Ngày cập nhật bản ghi
    FOREIGN KEY (state_code) REFERENCES NDSDB.dbo.States(state_code)	-- Ràng buộc khóa ngoại tới bảng States
);
GO

-- Bảng Category: Lưu trữ các loại chất lượng không khí (AQI Category)
CREATE TABLE NDSDB.dbo.Category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,      -- ID tự tăng cho mỗi loại chất lượng không khí
    category_name VARCHAR(50) NOT NULL,				-- Loại chất lượng không khí (VD: Good, Moderate, etc.)
    LowerBound INT NULL,                            -- Mức AQI tối thiểu cho loại chất lượng không khí
    UpperBound INT NULL,                            -- Mức AQI tối đa cho loại chất lượng không khí
    aqi_color VARCHAR(50) NULL,						-- Màu sắc AQI tương ứng (VD: Green, Yellow, etc.)
    description VARCHAR(255) NULL					-- Mô tả chất lượng không khí
);
GO


-- Bảng AQI_Measurements: Lưu trữ các đo lường chất lượng không khí (AQI)
CREATE TABLE NDSDB.dbo.AQI_Measurements (
    measurement_id INT IDENTITY(1,1) PRIMARY KEY,							-- ID tự tăng cho mỗi bản ghi AQI
    county_fips VARCHAR(50) NOT NULL,										-- Khóa ngoại tham chiếu tới bảng Counties qua county_fips
    county_code VARCHAR(50),										-- Mã quận nội bang (để thuận tiện tra cứu)
    date DATE,														-- Ngày đo AQI
    aqi INT,														-- Chỉ số AQI
    category_id INT NOT NULL,												-- Khóa ngoại tham chiếu tới bảng Category
    defining_parameter VARCHAR(50),											-- Thông số chính xác định AQI (VD: PM2.5, Ozone)
    defining_site VARCHAR(50),												-- Tên trạm đo
    num_sites_reporting INT,												-- Số lượng trạm báo cáo dữ liệu												-- ID nguồn gốc của dữ liệu
    created_date DATETIME DEFAULT GETDATE(),								-- Ngày tạo bản ghi
    updated_date DATETIME DEFAULT GETDATE(),								-- Ngày cập nhật bản ghi
    FOREIGN KEY (county_fips) REFERENCES NDSDB.dbo.Counties(county_fips),	-- Ràng buộc khóa ngoại tới bảng Counties
    FOREIGN KEY (category_id) REFERENCES NDSDB.dbo.Category(category_id)	-- Ràng buộc khóa ngoại tới bảng Category
);
GO


INSERT INTO NDSDB.dbo.Category (category_name, LowerBound, UpperBound, aqi_color, description)
VALUES
('Good', 0, 50, 'Green', 'Air quality is satisfactory, and air pollution poses little or no risk.'),
('Moderate', 51, 100, 'Yellow', 'Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution.'),
('Unhealthy for Sensitive Groups', 101, 150, 'Orange', 'Members of sensitive groups may experience health effects. The general public is less likely to be affected.'),
('Unhealthy', 151, 200, 'Red', 'Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects.'),
('Very Unhealthy', 201, 300, 'Purple', 'Health alert: The risk of health effects is increased for everyone.'),
('Hazardous', 301, NULL, 'Maroon', 'Health warning of emergency conditions: everyone is more likely to be affected.');

