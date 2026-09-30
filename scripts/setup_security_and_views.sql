-- 1. Create Schema
CREATE SCHEMA fde_views;

-- 2. Create View
CREATE VIEW fde_views.vw_active_fleet AS
SELECT
    "TS_UTC" AS "Timestamp",
    "V_LAT" AS "Latitude",
    "V_LON" AS "Longitude",
    CAST(
        "IOT_TEMP_VAL_C" AS DOUBLE PRECISION
    ) AS "Current_Temperature_C",
    "CGO_COND_CD" AS "Cargo_Condition_Code",
    "RISK_CLS_TXT" AS "Risk_Classification",
    "DELAY_PROB_DEC" AS "Delay_Probability",
    "PRT_CNG_LVL" AS "Port_Congestion_Level",
    "RT_RSK_IDX" AS "Route_Risk_Index"
FROM public."TBL_SC_FLEET_HIST_RAW";

-- 3. Create Role
CREATE ROLE usr_fde_ro WITH LOGIN PASSWORD 'AgentPassword2026!';

-- 4. Assign Permissions
GRANT USAGE ON SCHEMA fde_views TO usr_fde_ro;

GRANT SELECT ON fde_views.vw_active_fleet TO usr_fde_ro;

REVOKE ALL ON SCHEMA public FROM usr_fde_ro;

REVOKE ALL ON public."TBL_SC_FLEET_HIST_RAW" FROM usr_fde_ro;