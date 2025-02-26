{{ config(materialized='table') }}

select
    EXTRACT(YEAR FROM pickup_datetime) as year,
    EXTRACT(MONTH FROM pickup_datetime) as month,
    t1.*,
    pull.borough as pull_borough,
    pull.zone as pull_zone,
    pull.service_zone as pull_service_zone,
    dol.borough as dol_borough,
    dol.zone as dol_zone,
    dol.service_zone as dol_service_zone
from {{ ref('stg_fhv') }} as t1
inner join {{ ref('dim_zones') }} as pull
on t1.pulocationid::integer = pull.locationid
inner join {{ ref('dim_zones') }} as dol
on t1.dolocationid::integer = dol.locationid