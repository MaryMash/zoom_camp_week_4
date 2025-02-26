{{
    config(
        materialized='table'
    )
}}

with filtered_data as (
    select
        service_type,
        EXTRACT(YEAR FROM pickup_datetime) as year,
        EXTRACT(MONTH FROM pickup_datetime) as month,
        fare_amount
    from {{ ref('fact_trips') }}
    where fare_amount > 0
    and trip_distance > 0
    and payment_type_description in ('Cash', 'Credit Card')
)
select
        service_type,
        year,
        month,
        percentile_cont(0.97) WITHIN GROUP (ORDER BY fare_amount) AS p97,
        percentile_cont(0.95) WITHIN GROUP (ORDER BY fare_amount) AS p95,
        percentile_cont(0.90) WITHIN GROUP (ORDER BY fare_amount) AS p90
from filtered_data
group by service_type, year, month
