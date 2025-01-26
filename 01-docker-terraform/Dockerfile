FROM python:3.9.1

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY ingest_data.py ingest_data.py


ENTRYPOINT [ "python", "ingest_data.py", "--user", "postgres", "--password", "postgres", "--host", "postgres", "--port", "5432", "--db", "ny_taxi", "--table_name", "green_trips", "--url", "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz"]