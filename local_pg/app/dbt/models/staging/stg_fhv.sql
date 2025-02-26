{{
    config(
        materialized='view'
    )
}}
select
    unique_row_id,
    filename,
    dispatching_base_num,
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,
    pulocationid,
    dolocationid,
    sr_flag,
    affiliated_base_number
from {{ source('staging','fhv_tripdata') }}
where dispatching_base_num is not null