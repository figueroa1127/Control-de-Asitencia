SELECT
    ct.nombre                       AS centro_trabajo,
    SUM(a.horas_laborales)          AS total_horas_laborales
FROM asistencia a
JOIN centros_trabajo ct ON ct.id_centro = a.id_centro
WHERE EXTRACT(MONTH FROM a.fech) = 4
  AND EXTRACT(YEAR  FROM a.fech) = 2025
GROUP BY ct.id_centro, ct.nombre
ORDER BY total_horas_laborales DESC
LIMIT 1;


WITH inasistencias AS (
    SELECT
        p.id_centro,
        p.id_empleado,
        COUNT(*) AS total_inasistencias
    FROM planificacion p
    LEFT JOIN asistencias a
        ON  a.id_empleado = p.id_empleado
        AND a.id_centro   = p.id_centro
        AND a.fecha	      = p.fecha
    WHERE a.id_asistencia IS NULL       
      AND EXTRACT(MONTH FROM p.fecha) = 4
      AND EXTRACT(YEAR  FROM p.fecha) = 2025
    GROUP BY p.id_centro, p.id_empleado
),
ranking AS (
    SELECT
        i.*,
        RANK() OVER (PARTITION BY id_centro ORDER BY total_inasistencias DESC) AS rn
    FROM inasistencias i
)
SELECT
    ct.nombre                       AS centro_trabajo,
    e.nombre || ' ' || e.apellido   AS empleado,
    r.total_inasistencias
FROM ranking r
JOIN empleados       e  ON e.id_empleado = r.id_empleado
JOIN centros_trabajo ct ON ct.id_centro  = r.id_centro
WHERE r.rn = 1
ORDER BY ct.nombre;


SELECT
    e.nombre || ' ' || e.apellido       AS empleado,
    SUM(a.horas_laborales)              AS total_horas_laborales,
    SUM(p.horas_planificadas)           AS total_horas_planificadas,
    SUM(a.horas_laborales)
        - SUM(p.horas_planificadas)     AS horas_extras
FROM planificacion p
JOIN asistencias a
    ON  a.id_empleado = p.id_empleado
    AND a.id_centro   = p.id_centro
    AND a.fecha       = p.fecha
JOIN empleados e ON e.id_empleado = p.id_empleado
WHERE EXTRACT(MONTH FROM p.fecha) = 4
  AND EXTRACT(YEAR  FROM p.fecha) = 2025
GROUP BY e.id_empleado, e.nombre, e.apellido
HAVING SUM(a.horas_laborales) > SUM(p.horas_planificadas)
ORDER BY horas_extras DESC;
