-- 1. Create Schema
CREATE SCHEMA fde_views;

-- 2. Create View
CREATE VIEW fde_views.vw_active_fleet AS
SELECT
    ts_utc AS "Timestamp",
    v_lat AS "Latitude",
    v_lon AS "Longitude",
    CAST(
        iot_temp_val_c AS DOUBLE PRECISION
    ) AS "Current_Temperature_C",
    cgo_cond_cd AS "Cargo_Condition_Code",
    risk_cls_txt AS "Risk_Classification",
    delay_prob_dec AS "Delay_Probability",
    prt_cng_lvl AS "Port_Congestion_Level",
    rt_rsk_idx AS "Route_Risk_Index"
FROM public.tbl_sc_fleet_hist_raw;

-- 3. Create Role
CREATE ROLE usr_fde_ro WITH LOGIN PASSWORD 'AgentPassword2026!';

-- 4. Assign Permissions
GRANT USAGE ON SCHEMA fde_views TO usr_fde_ro;

GRANT SELECT ON fde_views.vw_active_fleet TO usr_fde_ro;

REVOKE ALL ON SCHEMA public FROM usr_fde_ro;

REVOKE ALL ON public.tbl_sc_fleet_hist_raw FROM usr_fde_ro;