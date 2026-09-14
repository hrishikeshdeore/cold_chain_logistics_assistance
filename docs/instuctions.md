# Data ingestion

## 1-data is downloaded from kaggle in csv
## 2-create ec2 instance >docker container for postgres>

Run the following command to start a PostgreSQL container:

```bash
docker run --name custom-postgres -e POSTGRES_PASSWORD=MySecretPass123! -p 5432:5432 -d postgres
```