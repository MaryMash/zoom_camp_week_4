import pandas as pd
import clickhouse_connect

parquet_url = 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2019-02.parquet'
clickhouse_table = 'yellow_tripdata'
# Read the Parquet file into a pandas DataFrame
df = pd.read_parquet(parquet_url)

# Establish a ClickHouse client connection
# client = Client(host='localhost', port=9000, user='ch_admin', password='12345', database='ny_taxi')
#client = Client.from_url("http://ch_admin:12345@localhost:8123/ny_taxi")
client = clickhouse_connect.get_client(host='localhost', port=8123, username='ch_admin', password='12345', database='ny_taxi')

# Step 1: Create a table in ClickHouse based on the DataFrame's schema
columns = df.columns
column_definitions = []
for column in columns:
    dtype = str(df[column].dtype)
    # Map pandas data types to ClickHouse data types
    if dtype == 'object':
        dtype = 'Nullable(String)'
    elif dtype == 'float64':
        dtype = 'Nullable(Float64)'
    elif dtype == 'int64':
        dtype = 'Nullable(Int64)'
    elif dtype == 'datetime64[us]':
        dtype = 'Nullable(DateTime)'
    column_definitions.append(f"{column} {dtype}")

# Join the column definitions into a string for the CREATE TABLE query
column_definitions_str = ', '.join(column_definitions)

# Create the ClickHouse table if it doesn't exist
create_table_query = f'''
CREATE TABLE IF NOT EXISTS {clickhouse_table} (
    {column_definitions_str}
) ENGINE = MergeTree()
ORDER BY tuple()
'''

print(create_table_query)
client.command(create_table_query)
print(f"Table '{clickhouse_table}' created successfully.")

client.insert_df("yellow_tripdata", df)

print(f"Successfully inserted {len(df)} rows into {clickhouse_table}.")
