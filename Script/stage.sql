﻿CREATE DATABASE StageDB;
GO

USE StageDB;

-- Bảng Counties
CREATE TABLE StageDB.dbo.Counties (
    county VARCHAR(255),                        -- Tên quận
    county_ascii VARCHAR(255),                  -- Tên quận không dấu
    county_full VARCHAR(255),                   -- Tên đầy đủ của quận
    county_fips VARCHAR(5) PRIMARY KEY,			-- Mã định danh duy nhất của quận (FIPS code)
    state_abbr VARCHAR(2),						-- Mã viết tắt của bang, độ dài cố định là 2 ký tự
    state_name VARCHAR(255),					-- Tên bang
    lat decimal(9, 6),                          -- Vĩ độ của quận
    lng decimal(9, 6),                          -- Kinh độ của quận
    population INT                              -- Dân số của quận
);


-- Bảng AQI_Measurements 
CREATE TABLE StageDB.dbo.AQI_Measurements (
    state_name VARCHAR(255),										-- Tên bang nơi đo lường AQI (ví dụ: "California")
    county_name VARCHAR(255),										-- Tên quận nơi đo lường AQI (ví dụ: "Los Angeles")
    state_code VARCHAR(2),											-- Mã định danh bang (ví dụ: 6 cho California)
    county_code VARCHAR(3),											-- Mã quận nội bang (để thuận tiện tra cứu)
    date DATE,														-- Ngày đo lường AQI
    aqi INT,														-- Chỉ số AQI (Air Quality Index)
    category VARCHAR(255),											-- Loại chất lượng không khí (ví dụ: "Good", "Moderate", v.v.)
    defining_parameter VARCHAR(255),								-- Thông số chính xác định AQI (ví dụ: "PM2.5", "Ozone")
    defining_site VARCHAR(255),										-- Tên trạm đo lường AQI
    num_sites_reporting INT,										-- Số lượng trạm báo cáo dữ liệu
    created DATETIME,												-- Thời gian tạo bản ghi (mặc định là thời điểm hiện tại)
    last_updated DATETIME,											-- Thời gian cập nhật bản ghi (mặc định là thời điểm hiện tại)
	PRIMARY KEY (state_code, county_code, created, last_updated)	-- Định nghĩa khóa chính
);
