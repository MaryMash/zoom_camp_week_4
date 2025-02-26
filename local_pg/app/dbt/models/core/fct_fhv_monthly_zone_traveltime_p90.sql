{{ config(materialized='table') }}

with data as (
    select
        *,
        EXTRACT(EPOCH FROM (dropoff_datetime - pickup_datetime)) as trip_duration
    from {{ ref('dim_fhv_trips') }}
)
select
    year,
    month,
    pulocationid as pickup_location_id,
    pull_zone as pickup_zone,
    dolocationid as dropoff_location_id,
    dol_zone as dropoff_zone,
    percentile_cont(0.90) WITHIN GROUP (ORDER BY trip_duration) AS p90
from data
group by 1, 2, 3, 4, 5, 6