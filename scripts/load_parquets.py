href="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2019-01.parquet"
"""The Requests Pipeline Template provides a simple starting point for a dlt pipeline with the requests library"""

# mypy: disable-error-code="no-untyped-def,arg-type"

from typing import Iterator, Any

import dlt

from dlt.sources.helpers import requests
from dlt.sources import TDataItems
import pandas as pd

BASE_PATH = "https://d37ci6vzurychx.cloudfront.net/trip-data"


@dlt.resource(name="taxi")
def taxis(taxi, year, month):
    """Load player profiles from the chess api."""
    path = f"{BASE_PATH}/{taxi}_tripdata_{year}-{month}.parquet"
    df = pd.read_parquet(path)
    yield df


def load_taxi_data() -> None:
    p = dlt.pipeline(
        pipeline_name="taxis",
        destination='clickhouse',
        dataset_name="taxi_data",
    )

    load_info = p.run(taxis("green", "2019", "01"), table_name="yellow_taxi", write_disposition="replace")

    # pretty print the information on data that was loaded
    print(load_info)  # noqa: T201


if __name__ == "__main__":
    load_taxi_data()
