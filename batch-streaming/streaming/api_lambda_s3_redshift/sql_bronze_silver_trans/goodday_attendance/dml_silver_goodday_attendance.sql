INSERT INTO `silver_terranova.goodday_attendance` (
    attendance_id,
    date,
    hour,
    attendance_created_at,
    attendance_updated_at,
    user_id,
    unity_id,
    area_id,
    area_name,
    area_description,
    area_active,
    area_created_at,
    area_updated_at,
    timestamp

)
SELECT
    a.id AS attendance_id,
    a.date,
    a.hour,
    a.created_at AS attendance_created_at,
    a.updated_at AS attendance_updated_at,
    a.user AS user_id,
    a.unity AS unity_id,
    ar.area_id,
    ar.name AS area_name,
    ar.description AS area_description,
    ar.active AS area_active,
    ar.created_at AS area_created_at,
    ar.updated_at AS area_updated_at,
    CURRENT_TIMESTAMP() AS timestamp
FROM
    `bronze_terranova.goodday_attendance_att` a
LEFT JOIN
    `bronze_terranova.goodday_attendance_areas` ar
ON
    a.id = ar.att_id;
