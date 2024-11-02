CREATE DATABASE StageDB;
GO

USE StageDB;

-- Bảng stg_counties trong StageDB
CREATE TABLE StageDB.dbo.Counties (
    county NVARCHAR(50),                          -- Tên quận (ví dụ: "Los Angeles")
    county_ascii NVARCHAR(50),                    -- Tên quận không dấu (ví dụ: "Los Angeles")
    county_full NVARCHAR(100),                    -- Tên đầy đủ của quận (ví dụ: "Los Angeles County")
    county_fips INT PRIMARY KEY,                  -- Mã định danh duy nhất của quận (FIPS code)
    state_id NVARCHAR(2),                         -- Mã viết tắt của bang (ví dụ: "CA" cho California)
    state_name NVARCHAR(50),                      -- Tên bang (ví dụ: "California")
    lat FLOAT,                                    -- Vĩ độ của quận
    lng FLOAT,                                    -- Kinh độ của quận
    population INT                                -- Dân số của quận
);

-- Bảng stg_aqi trong StageDB
CREATE TABLE StageDB.dbo.AQI_Measurements (
    state_name NVARCHAR(50),                      -- Tên bang nơi đo lường AQI (ví dụ: "California")
    county_name NVARCHAR(50),                     -- Tên quận nơi đo lường AQI (ví dụ: "Los Angeles")
    state_code INT,                               -- Mã định danh bang (ví dụ: 6 cho California)
    county_code INT,                              -- Mã quận nội bang (để thuận tiện tra cứu)
    date DATE,                                    -- Ngày đo lường AQI
    aqi INT,                                      -- Chỉ số AQI (Air Quality Index)
    category NVARCHAR(20),                        -- Loại chất lượng không khí (ví dụ: "Good", "Moderate", v.v.)
    defining_parameter NVARCHAR(20),              -- Thông số chính xác định AQI (ví dụ: "PM2.5", "Ozone")
    defining_site NVARCHAR(20),                   -- Tên trạm đo lường AQI
    num_sites_reporting INT,                      -- Số lượng trạm báo cáo dữ liệu
    created DATETIME DEFAULT GETDATE(),           -- Thời gian tạo bản ghi (mặc định là thời điểm hiện tại)
    last_updated DATETIME DEFAULT GETDATE()       -- Thời gian cập nhật bản ghi (mặc định là thời điểm hiện tại)
);
