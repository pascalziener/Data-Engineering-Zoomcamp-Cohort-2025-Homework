# Homework 1 - Docker, SQL and Terraform for Data Engineering Zoomcamp 2025

## Question 1

Command to run container based on `python:3.12.8` image in an interactive mode, using the `bash` entry point:

```sh
docker run -it --rm python:3.12.8 bash
```
Command to find the version of `pip` inside of container:

```sh
pip --version
```

Output:
```sh
pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)
```

## Question 2

Since the internal port of the postgres container is 5432 this is the port that needs to be used to connect from pgadmin to the database in the postgres container.

The hostname can be either the name of the service, which is `db` or the name of the container of the postgres container which is `postgres`.

So the answer is either `postgres:5432` or `db:5432`.

## Question 3
### Preparation for data ingestion
- update ingest_data.py script to update the column name for pickup_datetime and dropoff_datetime: e.g. lpep_pickup_datetime instead of tpep_pickup_datetime
- run docker compose for the postgres and pgadmin container
- update Dockerfile for container with ingest_data.py script: added parameters for ingest script to `ENTRYPOINT`
  - ATTENTION: take hostname and port for postgres DB container for the internal Docker network that is created by docker compose.
```sh
docker build --tag ny-taxi-ingest:4 .
```
- run container from image create from the Docker files
```sh
docker run -it --rm --network=01-docker-terraform_default ny-taxi-ingest:4
```
- To ingest the zones data, just copy the existing ingest_data.py and remove all unnecessary code.
- Create a copy of the existing Dockerfile and update it to take the ingest script for the zones data.
- Build the image and run the container
```sh
docker run -it --rm --network=01-docker-terraform_default ny-taxi-zones-ingest:5
```
- SQL query to count trips up to 1 miles in the given date range
  - Answer: 104802
```sql
SELECT COUNT(*) AS trip_count_up_to_1_mi
FROM green_trips
WHERE lpep_pickup_datetime >= ('2019-10-01 00:00:00')
	AND lpep_dropoff_datetime < ('2019-11-01 00:00:00')
	AND trip_distance <= 1.0
```


- SQL query to count trips between 1 (exclusive) and 3 miles (inclusive)
  - Answer: 198924
```sql
SELECT COUNT(*) AS trip_count_between_1mi_and_3mi
FROM green_trips
WHERE lpep_pickup_datetime >= ('2019-10-01 00:00:00')
	AND lpep_dropoff_datetime < ('2019-11-01 00:00:00')
	AND trip_distance > 1.0 AND trip_distance <= 3.0
```


- SQL query to count trips between 3 (exclusive) and 7 miles (inclusive):
  - Answer: 109603
```sql
SELECT COUNT(*) AS trip_count_between_3mi_and_7mi
FROM green_trips
WHERE lpep_pickup_datetime >= ('2019-10-01 00:00:00')
	AND lpep_dropoff_datetime < ('2019-11-01 00:00:00')
	AND trip_distance > 3.0 AND trip_distance <= 7.0

```

- SQL query to count trips between 7 (exclusive) and 10 miles (inclusive)
  - Query result: 27678
```sql
SELECT COUNT(*) AS trip_count_between_7mi_and_10mi
FROM green_trips
WHERE lpep_pickup_datetime >= ('2019-10-01 00:00:00')
	AND lpep_dropoff_datetime < ('2019-11-01 00:00:00')
	AND trip_distance > 7.0 AND trip_distance <= 10.0

```

- SQL query to count trips over 10 miles
  - Query result: 35189
```sql
SELECT COUNT(*) AS trip_count_over_10mi
FROM green_trips
WHERE lpep_pickup_datetime >= ('2019-10-01 00:00:00')
	AND lpep_dropoff_datetime < ('2019-11-01 00:00:00')
	AND trip_distance > 10.0
```

## Question 4
Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.
- Query result: "2019-10-31 23:23:41"	515.89
```sql
SELECT lpep_pickup_datetime, trip_distance
FROM green_trips
ORDER BY trip_distance DESC
LIMIT 1;

```

## Question 5
- Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

"Zone"	"total"
"East Harlem North"	18686.680000000077
"East Harlem South"	16797.26000000006
"Morningside Heights"	13029.790000000034

```sql
SELECT z."Zone", SUM(total_amount) AS total
FROM green_trips AS t
LEFT JOIN zones AS z
	ON t."PULocationID" = z."LocationID"
WHERE t.lpep_pickup_datetime >= '2019-10-18 00:00:00' AND t.lpep_pickup_datetime < '2019-10-19 00:00:00'
GROUP BY z."Zone"
HAVING SUM(total_amount) > 13000
ORDER BY total DESC
```

## Question 6
- For the passengers picked up in October 2019 in the zone named "East Harlem North" which was the drop off zone that had the largest tip?
  - Query Result: JFK Airport

```sql
SELECT t.lpep_pickup_datetime, pu_zones."Zone" AS PU_Zone, do_zones."Zone" AS DO_Zone, t.tip_amount
FROM green_trips AS t
LEFT JOIN zones AS pu_zones
	ON t."PULocationID" = pu_zones."LocationID"
LEFT JOIN zones AS do_zones
	ON t."DOLocationID" = do_zones."LocationID"
WHERE t.lpep_pickup_datetime >= '2019-10-01 00:00:00'
	AND t.lpep_pickup_datetime < '2019-11-01 00:00:00'
	AND pu_zones."Zone" = 'East Harlem North'
ORDER BY tip_amount DESC
```

## Question 7
- The terraform workflow to deploy a bucket and bigquery dataset in GCP and to remove all resources again with is:
```sh
terraform init
terraform apply -auto-approve
terraform destroy


