from pathlib import Path
import pandas as pd
import os
from sqlalchemy import create_engine
from dotenv import load_dotenv

# 1. Dynamic Pathing
# Resolves the exact path of this script so it runs from anywhere
script_dir = Path(__file__).resolve().parent
data_path = script_dir / "logistics_data.csv" 

# Load the secret credentials from the .env file we just created
load_dotenv(script_dir / ".env")

db_host = os.getenv("DB_HOST")
db_port = os.getenv("DB_PORT")
db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
db_name = os.getenv("DB_NAME")

# 2. Load the raw dataset
print(f"Loading CSV from {data_path}...")
df = pd.read_csv(data_path)

# (Optional) Map clean Kaggle columns to a messy enterprise schema
# NOTE: You will need to change the left-side names to match the exact column headers in your CSV
legacy_mapping = {
    'timestamp': 'TS_UTC',
    'vehicle_gps_latitude': 'V_LAT',
    'vehicle_gps_longitude': 'V_LON',
    'iot_temperature': 'IOT_TEMP_VAL_C',
    'cargo_condition_status': 'CGO_COND_CD',
    'risk_classification': 'RISK_CLS_TXT',
    'delay_probability': 'DELAY_PROB_DEC',
    'port_congestion_level': 'PRT_CNG_LVL',
    'route_risk_level': 'RT_RSK_IDX'
}

print("Standardizing column names...")
# Rename the columns if they exist in the CSV, otherwise keep original
df_legacy = df.rename(columns=legacy_mapping)

# Add a fake ingestion flag to mimic an automated legacy system
df_legacy['SYS_INGEST_FLAG'] = 'Y'

# 3. Connect to Docker PostgreSQL Server
print("Connecting to local PostgreSQL Database...")
# Format: postgresql://username:password@host:port/database
connection_string = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

engine = create_engine(connection_string)

# 4. Ingest data into the table
table_name = 'TBL_SC_FLEET_HIST_RAW'
print(f"Ingesting into {table_name}. This may take a minute...")

# Writes the dataframe to SQL. 'replace' overwrites the table if it already exists.
df_legacy.to_sql(table_name, engine, if_exists='replace', index=False)

print("✅ Legacy data ingestion complete!")