import pyodbc
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
import matplotlib.pyplot as plt

# Kết nối đến cơ sở dữ liệu SQL Server (DDS)
conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};'
                      'SERVER=DESKTOP-81O7H9J;'
                      'DATABASE=DDSDB;'
                      'Trusted_Connection=yes')

# Truy vấn dữ liệu từ các bảng trong DDS (2021 - 2023)
query = """
    SELECT 
        c.county_name, 
        s.state_name,
        cat.category_name, 
        depa.parameter_name, 
        aqi.aqi,  
        d.date
    FROM AQI_Fact aqi
    JOIN Dim_County c ON aqi.county_id = c.county_id
    JOIN Dim_State s ON c.state_id = s.state_id
    JOIN Dim_Date d ON aqi.date_id = d.date_id
    JOIN Dim_Category cat ON aqi.category_id = cat.category_id
    JOIN Dim_DefiningParameter depa on depa.parameter_id = aqi.parameter_id
"""
data = pd.read_sql(query, conn)
conn.close()

# Hiển thị số dòng dữ liệu
print(f"Loaded {len(data)} rows of data.")

# Tiền xử lý dữ liệu
data['date'] = pd.to_datetime(data['date'])
data = pd.get_dummies(data, columns=['category_name', 'parameter_name'])

# Tạo đặc trưng và mục tiêu
X = data.drop(columns=['aqi', 'county_name', 'state_name', 'date'])
y = data['aqi']

# Chia dữ liệu thành bộ huấn luyện và kiểm tra
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Xây dựng mô hình Random Forest Regressor
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Đánh giá mô hình
y_pred = model.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
print(f"Mean Squared Error: {mse}")

# Dự báo cho tháng 1 năm 2024
future_dates = pd.date_range(start='2024-01-01', end='2024-01-31')

# Tạo khung dữ liệu dự báo với thông tin cơ bản
future_data = pd.DataFrame({
    'date': future_dates,
    'county_name': [data['county_name'].unique()[0]] * len(future_dates),  # Ví dụ cho một quận
    'state_name': [data['state_name'].unique()[0]] * len(future_dates),   # Ví dụ cho một bang
})

# Thêm các cột dummy và đảm bảo chúng khớp với các đặc trưng trong X
future_data_encoded = pd.get_dummies(future_data, columns=['county_name', 'state_name'])
future_data_encoded = future_data_encoded.reindex(columns=X.columns, fill_value=0)

# Dự đoán AQI
future_data['predicted_aqi'] = model.predict(future_data_encoded)

# Lưu kết quả dự báo ra file CSV
future_data[['date', 'county_name', 'state_name', 'predicted_aqi']].to_csv('AQI_Predictions_Jan2024.csv', index=False)

print("Predictions have been saved to 'AQI_Predictions_Jan2024.csv'.")
