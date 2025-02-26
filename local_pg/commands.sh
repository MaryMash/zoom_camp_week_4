docker run \
--network=pg-dbt-net \
--mount type=bind,source=C:/Users/Maria/PycharmProjects/zoom_camp_week_4/local_pg/app,target=/usr/app \
--mount type=bind,source=C:/Users/Maria/PycharmProjects/zoom_camp_week_4/local_pg/root/.dbt,target=/root/.dbt \
--rm -it \
ghcr.io/dbt-labs/dbt-postgres \
init ny_taxi_rides


docker run \
--network=pg-dbt-net \
--mount type=bind,source=C:/Users/Maria/PycharmProjects/zoom_camp_week_4/local_pg/app,target=/usr/app \
--mount type=bind,source=C:/Users/Maria/PycharmProjects/zoom_camp_week_4/local_pg/root/.dbt,target=/root/.dbt \
--rm -it \
ghcr.io/dbt-labs/dbt-postgres \
debug
