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

CREATE TABLE ds_table (
	tb_key INT PRIMARY KEY,
	tb_name VARCHAR(100),
	data_store INT,
	description NVARCHAR(1000),

	--Foreign key
	CONSTRAINT FK_table_datastore
	FOREIGN KEY (data_store)
	REFERENCES ds_data_store (ds_key),
)
GO

CREATE TABLE ds_column_type
(
	column_type_key INT PRIMARY KEY,
	column_type_name VARCHAR(50),
	location VARCHAR(100),
	description NVARCHAR(1000),
)
GO

CREATE TABLE ds_column 
(
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

--Metadata definition and mapping
CREATE TABLE data_definition
(
	table_key INT,
	column_key INT,
	column_type INT,
	description NVARCHAR(100),
	sample_value VARCHAR(100),
	PRIMARY KEY(table_key, column_key),

	CONSTRAINT FK_df_table
	FOREIGN KEY (table_key)
	REFERENCES ds_table (tb_key),

	CONSTRAINT FK_df_column
	FOREIGN KEY (column_key)
	REFERENCES ds_column (column_key),

	CONSTRAINT FK_df_column_type
	FOREIGN KEY (column_type)
	REFERENCES ds_column_type(column_type_key)
)

CREATE TABLE mapping (
	data_mapping_key INT PRIMARY KEY,
	column_key INT,
	source_column_key INT,
	create_timestamp DATE,
	update_timestamp DATE,

	CONSTRAINT FK_mapping_des_column
	FOREIGN KEY (column_key)
	REFERENCES  ds_column (column_key),

	CONSTRAINT FK_mapping_source_column
	FOREIGN KEY (source_column_key)
	REFERENCES ds_column (column_Key)
)
GO

--ETL Process Metadata
CREATE TABLE status (
    status_id INT PRIMARY KEY,
    status VARCHAR(50)
);

GO

CREATE TABLE data_flow (
    flow_id INT IDENTITY(1, 1) PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(255),
    status_id INT,
    LSET DATETIME,
    CET DATETIME,
    FOREIGN KEY (status_id) REFERENCES status(status_id)
);

--Audit Metadata
--event category
CREATE TABLE event_category
(
	id_category INT PRIMARY KEY,
	event_category VARCHAR(255) NULL
);
--event type
CREATE TABLE event_type
(
	id_type INT PRIMARY KEY,
	event_type VARCHAR(255) NULL
);
--event_log
CREATE TABLE event_log
(
	id_log INT PRIMARY KEY,
	id_event_type INT NULL,
	id_event_category INT NULL,
	timestamp DATETIME NULL,
	object INT NULL,
	data_flow INT NULL,
	rows INT NULL,
	NOTE VARCHAR(255) NULL
)
GO

--FOREIGN KEY
--event_log to event_category
ALTER TABLE event_log  WITH CHECK ADD CONSTRAINT [FK_event_category] FOREIGN KEY(id_event_category)
REFERENCES event_category(id_category)
GO
ALTER TABLE event_log CHECK CONSTRAINT [FK_event_category]
GO

--event_log to event_type
ALTER TABLE event_log  WITH CHECK ADD CONSTRAINT [FK_event_type] FOREIGN KEY(id_event_type)
REFERENCES event_type(id_type)
GO
ALTER TABLE [dbo].[event_log] CHECK CONSTRAINT [FK_event_type]
GO

--event_log to ds_table
ALTER TABLE event_log  WITH CHECK ADD CONSTRAINT [FK_event_table] FOREIGN KEY(object)
REFERENCES ds_table(tb_key)
GO
ALTER TABLE event_log CHECK CONSTRAINT [FK_event_table]
GO

--event_log to data_flow
ALTER TABLE event_log  WITH CHECK ADD CONSTRAINT [FK_event_data_flow] FOREIGN KEY(data_flow)
REFERENCES data_flow(flow_id)
GO
ALTER TABLE event_log CHECK CONSTRAINT [FK_event_data_flow]
GO




