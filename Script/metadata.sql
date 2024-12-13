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
	DBMS VARCHAR(50),
	collation VARCHAR(100),
	current_size INT,
	growth INT,
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
	entity_type INT,
	data_store INT,
	description NVARCHAR(1000),

	--Foreign key
	CONSTRAINT FK_table_datastore
	FOREIGN KEY (data_store)
	REFERENCES ds_data_store (ds_key),

	CONSTRAINT FK_table_tabletype 
	FOREIGN KEY (entity_type)
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

--Metadata definition and mapping
CREATE TABLE data_definition (
	table_key INT,
	column_key INT,
	column_type INT,
	description NVARCHAR(100),
	sample_value VARCHAR(100),
	create_timestampt DATE,
	update_timestamp DATE,

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

--Metadata source system
CREATE TABLE source_table_data_profile (
	table_key INT PRIMARY KEY,
	rows INT,
	row_size INT,
	column_count INT,
	has_timestamp CHAR(5)

	CONSTRAINT FK_source_table_table 
	FOREIGN KEY (table_key)
	REFERENCES ds_table (tb_key)
)
GO

CREATE TABLE source_column_data_profile (
	column_key INT,
	table_key INT,
	unique_values INT,
	minimum CHAR(100),
	maximum CHAR(100),
	average CHAR(100),
	max_length INT,
	null_count INT,

	CONSTRAINT FK_source_column_table
	FOREIGN KEY (table_key)
	REFERENCES ds_table (tb_key),

	CONSTRAINT FK_source_column_column
	FOREIGN KEY (column_key)
	REFERENCES ds_column (column_key)
)

--ETL Process Metadata
CREATE TABLE package (
    package_id INT PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(500), 
    schedule VARCHAR(100)
);

go
CREATE TABLE status (
    status_id INT PRIMARY KEY,
    status VARCHAR(50)
);

go
CREATE TABLE data_flow (
    flow_id INT PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(255),
    source VARCHAR(50),
    target VARCHAR(50),
    transformation VARCHAR(255),
    package_id INT,
    status_id INT,
    LSET DATETIME,
    CET DATETIME,
    FOREIGN KEY (package_id) REFERENCES package(package_id),
    FOREIGN KEY (status_id) REFERENCES status(status_id)
);

--Data Quality Metadata

CREATE TABLE dq_rules (
    rule_key INT PRIMARY KEY,
    rule_name VARCHAR(255),
    rule_description TEXT,
    rule_type VARCHAR(50),
    category VARCHAR(50),
    risk_level VARCHAR(50),
    status VARCHAR(50),
    action VARCHAR(50),
    create_timestamp DATETIME,
    update_timestamp DATETIME
);
GO

CREATE TABLE data_warehouse_user (
    user_key INT PRIMARY KEY,
    user_name VARCHAR(255),
    department VARCHAR(100),
    role VARCHAR(100),
    email_address VARCHAR(100),
    phone_number VARCHAR(20),
    group_id INT
);
GO

CREATE TABLE dq_notification (
    notification_key INT PRIMARY KEY,
    rule_key INT,
    recipient_type VARCHAR(50),
	recipient INT,
    recipient_method VARCHAR(50),
    FOREIGN KEY (rule_key) REFERENCES dq_rules(rule_key),
	FOREIGN KEY (recipient) REFERENCES data_warehouse_user(user_key),
);
GO

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

--event_log
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_log](
	[id] [int] NOT NULL,
	[event_type] [int] NULL,
	[event_category] [int] NULL,
	[timestamp] [datetime] NULL,
	[object] [int] NULL,
	[data_flow] [int] NULL,
	[rows] [int] NULL,
	[note] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--FOREIGN KEY
--event_log to event_category
ALTER TABLE [dbo].[event_log]  WITH CHECK ADD  CONSTRAINT [FK_event_category] FOREIGN KEY([event_category])
REFERENCES [dbo].[event_category] ([id])
GO
ALTER TABLE [dbo].[event_log] CHECK CONSTRAINT [FK_event_category]
GO
--event_log to event_type
ALTER TABLE [dbo].[event_log]  WITH CHECK ADD  CONSTRAINT [FK_event_type] FOREIGN KEY([event_type])
REFERENCES [dbo].[event_type] ([id])
GO
ALTER TABLE [dbo].[event_log] CHECK CONSTRAINT [FK_event_type]
GO
--event_log to ds_table
ALTER TABLE [dbo].[event_log]  WITH CHECK ADD  CONSTRAINT [FK_event_table] FOREIGN KEY([object])
REFERENCES [dbo].[ds_table] ([tb_key])
GO
ALTER TABLE [dbo].[event_log] CHECK CONSTRAINT [FK_event_table]
--event_log to data_flow
ALTER TABLE [dbo].[event_log]  WITH CHECK ADD  CONSTRAINT [FK_event_data_flow] FOREIGN KEY([data_flow])
REFERENCES [dbo].[data_flow] ([flow_id])
GO
ALTER TABLE [dbo].[event_log] CHECK CONSTRAINT [FK_event_data_flow]

--Usage Metadata
CREATE TABLE usage_log (
    id INTEGER PRIMARY KEY,
    usage_user INTEGER,
    object INTEGER,
    timestamp datetime,
    parameters VARCHAR(50),
    note TEXT

	CONSTRAINT FK_usage_table
	FOREIGN KEY (object)
	REFERENCES ds_table(tb_key),

	CONSTRAINT FK_usage_user
	FOREIGN KEY (usage_user)
	REFERENCES data_warehouse_user (user_key)
);



