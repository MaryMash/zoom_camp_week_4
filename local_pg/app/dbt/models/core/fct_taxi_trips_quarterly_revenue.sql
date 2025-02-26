{{
    config(
        materialized='table'
    )
}}

with grouped_data as (
    select
        EXTRACT(YEAR FROM pickup_datetime) as year,
        EXTRACT(QUARTER FROM pickup_datetime) as quarter,
        service_type,
        sum(total_amount) as revenue
    from {{ ref('fact_trips') }}
    where pickup_datetime::date between '2019-01-01'::date and '2020-12-31'::date
    group by 1, 2, 3
)

select
    t1."year" || ' ' || t1.quarter as cur_year,
    t2."year" || ' ' || t2.quarter as prev_year,
    t1.service_type,
    t1.revenue as revenue_2020,
    t2.revenue as revenue_2019,
    (t1.revenue - t2.revenue) / t1.revenue * 100 as percent_diff
from grouped_data as t1
inner join grouped_data as t2
on t1."year" - 1 = t2."year"
and t1.quarter = t2.quarter
and t1.service_type = t2.service_type