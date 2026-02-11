SELECT COALESCE(SUM("ventes__v_ventes_comp"."MTT_TTC_EUR"), 0) AS "MTT_TTC_EUR_SUM",
    CASE
        WHEN COUNT(DISTINCT CASE
            WHEN "ventes__v_ventes_comp"."PERIODE" = 'N-1 ORCHESTRA' THEN "ventes__v_ventes_comp"."TCK_ID"
            ELSE NULL
        END) = 0 THEN 0
        ELSE CASE
        WHEN COUNT(DISTINCT CASE
            WHEN "ventes__v_ventes_comp"."PERIODE" = 'N-1 ORCHESTRA' THEN "ventes__v_ventes_comp"."TCK_ID"
            ELSE NULL
        END) = 0 THEN NULL
        ELSE COALESCE(COALESCE(COUNT(DISTINCT CASE
            WHEN "ventes__v_ventes_comp"."PERIODE" = 'N' THEN "ventes__v_ventes_comp"."TCK_ID"
            ELSE NULL
        END), 0) - COALESCE(COUNT(DISTINCT CASE
            WHEN "ventes__v_ventes_comp"."PERIODE" = 'N-1 ORCHESTRA' THEN "ventes__v_ventes_comp"."TCK_ID"
            ELSE NULL
        END), 0), 0) / COUNT(DISTINCT CASE
            WHEN "ventes__v_ventes_comp"."PERIODE" = 'N-1 ORCHESTRA' THEN "ventes__v_ventes_comp"."TCK_ID"
            ELSE NULL
        END)
        END
    END AS "OMNI__VOLUTION_TICKETS_N_VS_N_1_ORCHESTRA"
FROM "VENTES"."DT_VENTES_COMP" AS "ventes__v_ventes_comp"
    LEFT JOIN "REFERENTIEL"."V_DTV_DEPOTS" AS "referentiel__v_dtv_depots" ON "ventes__v_ventes_comp"."CODE_DEPOT" = "referentiel__v_dtv_depots"."DEP_CODE" AND "ventes__v_ventes_comp"."DATE_COMP" >= "referentiel__v_dtv_depots"."DEP_DATE_DEB" AND "ventes__v_ventes_comp"."DATE_COMP" <= "referentiel__v_dtv_depots"."DEP_DATE_FIN"
    LEFT JOIN "REFERENTIEL"."V_DTV_CALENDRIER" AS "referentiel__v_dtv_calendrier" ON "ventes__v_ventes_comp"."DATE_COMP" = "referentiel__v_dtv_calendrier"."CAL_KEY"
WHERE "referentiel__v_dtv_depots"."DEP_CODE" = 'F4T' AND "referentiel__v_dtv_calendrier"."CAL_DT_JOUR" >= CAST(DATE_TRUNC('DAY', (CAST(CURRENT_TIMESTAMP AS TIMESTAMP(0)) + INTERVAL '-6 day')) AS DATE) AND "referentiel__v_dtv_calendrier"."CAL_DT_JOUR" < CAST(DATE_TRUNC('DAY', (DATE_TRUNC('DAY', (CAST(CURRENT_TIMESTAMP AS TIMESTAMP(0)) + INTERVAL '-6 day')) + INTERVAL '7 day')) AS DATE)
