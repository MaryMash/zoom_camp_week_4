import dlt
import pandas as pd
from clickhouse_driver import Client

# dlt.resource(table_name="yellow_taxi")
# def load_parquet():
#     path = f"https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2019-01.parquet"
#     df = pd.read_parquet(path)
#     yield df

#
# pipeline = dlt.pipeline(
#     pipeline_name="taxi_data",
#     destination="clickhouse",
# )
#
# load_info = pipeline.run(load_parquet)

url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2019-01.parquet"
df = pd.read_parquet(url)
print(df.head(3))

destination_config = {
    "host": "localhost",  # or "127.0.0.1"
    "port": 8123,         # Change to HTTP port 8123
    "database": "dlt_taxi"  # Make sure the correct database is specified
}

pipeline = dlt.pipeline(
    pipeline_name="taxi_data",
    destination="clickhouse",
    dataset_name="yellow_tripdata_2019-01"
)

load_info = pipeline.run(df, table_name="yellow_trip_data")