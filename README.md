
# The Final project was developed as part of Data Engineering Zoomcamp 2025.
## Intro
The main goal of the project is to evaluate crime statistics in the UK and the most criminal areas of the country. In the future, it is planned to develop the project. 
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
- Minio as S3 Data lake storage

_P.S. Cloud solution was outdated_



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
cd ~/DEZC2025proj
```

### Run Docker Desktop
```sh
sudo docker compose up -d
```

Build & Start Services
[+] Running 5/5
 ✔ Network project_kestra_net    Created                                                                 0.3s
 ✔ Container minio                       Started                                                        49.9s
 ✔ Container project-postgres-1  Started                                                                49.8s
 ✔ Container project-kestra-1       Started                                                              9.5s


### Run & configure MinIO
Connect to minio UI http://localhost:9001/login with user: `minioadmin` and password: `minioadmin`
 
Go to http://localhost:9001/access-keys/new-account and create access and secret keys. 
Go to http://localhost:9001/settings/configurations/region and setup region `eu-central-1` to server location and restart the service.

### Run & configure Kestra OSS
Go to Kestra UI http://localhost:8080/ to check 

Change flow `flows/minio_kv.yaml` parameters for own: ACCESS_KEY_ID, SECRET_KEY_ID and so on (see MinIO configuration) 
Importing flow  `minio_kv` in Kestra
```sh
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/dezc_project.minio_kv.yaml
```

Importing flow `minio_create_bucket` in Kestra 
```sh
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/dezc_project.minio_create_bucket.yaml
```
Go to [MinIO UI ](http://localhost:9001/buckets/dezc-project/admin/summary)to check the bucket creation and change access policy to `Public` for the bucket 

Importing flow `zc_flow` in Kestra 
```sh
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/dezc_project.zc_flow.yaml
``` 
and run the flow
![Kestra flow](/img/Kestra%20flow.png "Kestra flow")

Check data file and add permissions to query
```sh
cd ~/DEZC2025proj
sudo chmod 777 ./data/policeuk.duckdb
```
Notes:
- Dbt sources  (`DEZC2025proj/dbt/models/raw/_sources.yml`) configured with bucket name `dezc-project`


### Run & configure Evidence UI 
- Install Evidence with VS Code extension as explained [here](https://docs.evidence.dev/install-evidence/ ) and start Evidence server
- Copy policeuk.duckdb from `./data/` to ` ./reporting/sources/policeuk/`
- Run (if required) to update reports
```bash
npm run sources
```
- Go to http://localhost:3000/ to demo page

![Report example with crime statistics](/img/Example.png "Report example with crime statistics")
