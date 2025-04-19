
# The Final project was developed as part of [Data Engineering Zoomcamp 2025](https://courses.datatalks.club/de-zoomcamp-2025/).

## Intro
The main goal of the project is to evaluate crime statistics in the UK and the most criminal regions and types of crime.
In the future, it is planned to develop the project with MoterDuck
Using the Police UK (Home | data.police.uk) extract the data related to street-level crime and outcome data as well as the nearest police stations. 

### Data source info
- Data summary:  https://data.police.uk/about/
- Police API Documentation: https://data.police.uk/docs/


#### Data flow schema
![Data flow shema](/img/Data%20flow%20schema.png "Data flow shema")

The next technologies were selected for this project
- Kestra as orchestrator
- Dbt as popular transformation framework
- DuckDB as "pocket" data warehouse and in-progress database
- Evidence as reporting tool
- Minio as S3 Data lake


From the address provided by the API, we download the zip file of our choice. One zip file has~1.6 Gb compressed size and contains several thousand CSV files (~7Gb in raw size). To reduce the amount of processing data and time, DuckDB in in-memory mode was selected. 

The transformed data is saved to parquet files in Minio S3, which are then used as Dbt sources in the DuckDB persistent database (our data warehouse)

If you want to reproduce this project, please follow the instructions below:
To configure environment for the project follow instructions bellow

## Setup environment

### Setup requirements
- Docker project deployment in WSL2
- This project doesn't have security requirements for debugging needs and fan
- Data are loaded in archives and can partially overwritten in Minio s3 and processing in Dbt

### Clone the Repository
```sh
git clone https://github.com/alexanderlazutkin/DEZC2025proj.git

# rename folder
mv ~/DEZC2025proj ~/project
cd ~/project
```

### Run Docker Desktop
```sh
sudo docker compose up -d
```

Build & Start Services
```sh
[+] Running 6/6
 ✔ Network project_kestra_net      Created         0.2s
 ✔ Volume "project_postgres-data"  Created         0.1s
 ✔ Volume "project_minio_data"     Created         0.1s
 ✔ Container project-postgres-1    Started        17.3s
 ✔ Container minio                 Started        17.6s
 ✔ Container project-kestra-1      Started         5.3s
```


### Run & configure MinIO
Connect to minio UI http://localhost:9001/login with user: `minioadmin` and password: `minioadmin`
 
Go to http://localhost:9001/access-keys/new-account and create access and secret keys (you can use existing in dezc_project.minio_kv.yml) 

Go to http://localhost:9001/settings/configurations/region and setup region `eu-central-1` to server location and restart the service.

### Run & configure Kestra OSS
Go to Kestra UI http://localhost:8080/ to check 

Change flow `dezc_project.minio_kv.yml` parameters for own: ACCESS_KEY_ID, SECRET_KEY_ID and so on (see MinIO configuration) 
Importing flow  `minio_kv` in Kestra
```sh
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/dezc_project.minio_kv.yml
```

Importing flow `minio_create_bucket` in Kestra or do it manually
```sh
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/dezc_project.minio_create_bucket.yml
```
Go to [MinIO UI ](http://localhost:9001/buckets/dezc-project/admin/summary) to check the bucket creation and change access policy to `Public` for the bucket 

Importing flow `main_flow` in Kestra 
```sh
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/dezc_project.main_flow.yml
``` 
and run the flow
![Kestra flow](/img/Kestra%20flow.png "Kestra flow")

Notes:
- Dbt sources  (`project/dbt/models/raw/_sources.yml`) configured with bucket name `dezc-project`


### Run & configure Evidence UI 
- Install Evidence with VS Code extension as explained [here](https://docs.evidence.dev/install-evidence/ ) and start Evidence server
- Copy policeuk.duckdb from `./data/` to ` ./reporting/sources/policeuk/` (if required)
- Run to update reports (if required) 
```bash
npm run sources
```
- Go to http://localhost:3000/ to demo page

![Report example with crime statistics](/img/Example.png "Report example with crime statistics")
