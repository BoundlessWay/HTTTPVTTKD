-- Tạo Database NDSDB
CREATE DATABASE NDSDB;
GO

-- Sử dụng Database NDSDB
USE NDSDB;
GO

-- Bảng States: Lưu trữ thông tin về các bang
CREATE TABLE NDSDB.dbo.States (
    state_code INT PRIMARY KEY,                -- Mã định danh duy nhất của bang
    state_name NVARCHAR(50) NOT NULL,          -- Tên bang
    state_id CHAR(2) NOT NULL,                 -- Tên viết tắt của bang
    created_date DATETIME DEFAULT GETDATE(),   -- Ngày tạo bản ghi
    updated_date DATETIME DEFAULT GETDATE()    -- Ngày cập nhật bản ghi
);
GO

-- Bảng Counties: Lưu trữ thông tin về các quận/huyện
CREATE TABLE NDSDB.dbo.Counties (
    county_fips INT PRIMARY KEY,										-- Mã định danh duy nhất cho mỗi quận trên toàn quốc (FIPS)
    county NVARCHAR(50),												-- Tên quận
    county_ascii NVARCHAR(50),											-- Tên quận không dấu
    county_full NVARCHAR(100),											-- Tên đầy đủ của quận
    state_code INT NOT NULL,											-- Mã định danh bang, khóa ngoại tham chiếu đến States
    county_code INT,													-- Mã quận nội bang
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
    category_name NVARCHAR(20) NOT NULL,            -- Loại chất lượng không khí (VD: Good, Moderate, etc.)
    LowerBound INT NULL,                            -- Mức AQI tối thiểu cho loại chất lượng không khí
    UpperBound INT NULL,                            -- Mức AQI tối đa cho loại chất lượng không khí
    aqi_color NVARCHAR(15) NULL,                    -- Màu sắc AQI tương ứng (VD: Green, Yellow, etc.)
    description NVARCHAR(255) NULL                  -- Mô tả chất lượng không khí
);
GO


-- Bảng AQI_Measurements: Lưu trữ các đo lường chất lượng không khí (AQI)
CREATE TABLE NDSDB.dbo.AQI_Measurements (
    measurement_id INT IDENTITY(1,1) PRIMARY KEY,							-- ID tự tăng cho mỗi bản ghi AQI
    county_fips INT NOT NULL,												-- Khóa ngoại tham chiếu tới bảng Counties qua county_fips
    county_code INT,														-- Mã quận nội bang (để thuận tiện tra cứu)
    date DATE NOT NULL,														-- Ngày đo AQI
    aqi INT NOT NULL,														-- Chỉ số AQI
    category_id INT NOT NULL,												-- Khóa ngoại tham chiếu tới bảng Category
    defining_parameter NVARCHAR(20),										-- Thông số chính xác định AQI (VD: PM2.5, Ozone)
    defining_site NVARCHAR(20),												-- Tên trạm đo
    num_sites_reporting INT,												-- Số lượng trạm báo cáo dữ liệu
    source_id VARCHAR(50),													-- ID nguồn gốc của dữ liệu
    created_date DATETIME,													-- Ngày tạo bản ghi
    updated_date DATETIME,													-- Ngày cập nhật bản ghi
    FOREIGN KEY (county_fips) REFERENCES NDSDB.dbo.Counties(county_fips),	-- Ràng buộc khóa ngoại tới bảng Counties
    FOREIGN KEY (category_id) REFERENCES NDSDB.dbo.Category(category_id)	-- Ràng buộc khóa ngoại tới bảng Category
);
GO
