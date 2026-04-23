CREATE TABLE empleados (
    id_empleado     SERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    apellido        VARCHAR(100) NOT NULL,
    codigo          VARCHAR(20)  UNIQUE NOT NULL
);
CREATE TABLE centros_trabajo (
    id_centro   SERIAL PRIMARY KEY,
    nombre      VARCHAR(150) NOT NULL,
    direccion   VARCHAR(255)
);
CREATE TABLE planificacion (
    id_planificacion    SERIAL PRIMARY KEY,
    id_empleado         INT NOT NULL REFERENCES empleados(id_empleado),
    id_centro           INT NOT NULL REFERENCES centros_trabajo(id_centro),
    fecha               DATE NOT NULL,
    horas_planificadas  DECIMAL(5,2) NOT NULL
);
CREATE TABLE asistencias (
	id_asistencia		SERIAL PRIMARY KEY,
	id_empleado 		INT NOT NULL REFERENCES empleados(id_empleado),
	id_centro			INT NOT NULL REFERENCES centros_trabajo(id_centro),
	fecha				DATE NOT NULL,
	hora_entrada		TIME NOT NULL,
	hora_salida			TIME NOT NULL,
	horas_laborales		DECIMAL(5,2) GENERATED ALWAYS AS (
		EXTRACT(EPOCH FROM (hora_salida - hora_entrada)) / 3600
	) STORED
);

INSERT INTO empleados (nombre, apellido, codigo) VALUES
('Gustavo', 'Orellana', 'EMP001'),
('Ana', 'Cecilia', 'EMP002'),
('Armando', 'Gutierrez', 'EMP003'),
('Maria', 'Ordoñez', 'EMP004');

INSERT INTO centros_trabajo (nombre, direccion) VALUES
('Centro Norte', 'Zona 1, Ciudad'),
('Centro Sur',	'Zona 12, Ciudad'),
('Centro Oriente', 'Zona 4, Ciudad');

--PLANIFICACION DEL MES DE ABRIL--
INSERT INTO planificacion (id_empleado, id_centro, fecha, horas_planificadas) VALUES
-- 	Gustavo en Centro Norte
    (1, 1, '2025-04-01', 8), (1, 1, '2025-04-02', 8), (1, 1, '2025-04-03', 8),
    (1, 1, '2025-04-04', 8), (1, 1, '2025-04-07', 8), (1, 1, '2025-04-08', 8),
    -- Ana en Centro Sur
    (2, 2, '2025-04-01', 8), (2, 2, '2025-04-02', 8), (2, 2, '2025-04-03', 8),
    (2, 2, '2025-04-04', 8), (2, 2, '2025-04-07', 8), (2, 2, '2025-04-08', 8),
    -- Armando en Centro Norte
    (3, 1, '2025-04-01', 8), (3, 1, '2025-04-02', 8), (3, 1, '2025-04-03', 8),
    (3, 1, '2025-04-04', 8), (3, 1, '2025-04-07', 8), (3, 1, '2025-04-08', 8),
    -- Maria en Centro Oriente
    (4, 3, '2025-04-01', 8), (4, 3, '2025-04-02', 8), (4, 3, '2025-04-03', 8),
    (4, 3, '2025-04-04', 8), (4, 3, '2025-04-07', 8), (4, 3, '2025-04-08', 8);

INSERT INTO asistencias (id_empleado, id_centro, fecha, hora_entrada, hora_salida) VALUES
    -- Gustavo asistió todos sus días pero hizo horas extra algunos días
    (1, 1, '2025-04-01', '08:00', '17:00'),
    (1, 1, '2025-04-02', '08:00', '16:00'),  
    (1, 1, '2025-04-03', '08:00', '18:00'),  
    (1, 1, '2025-04-04', '08:00', '16:00'), 
    (1, 1, '2025-04-07', '08:00', '16:00'),  
    -- (2025-04-08 falta Carlos) → inasistencia

    -- Ana faltó 2 días
    (2, 2, '2025-04-01', '08:00', '16:00'), 
    (2, 2, '2025-04-02', '08:00', '16:00'),  
    -- (04-03 y 04-04 faltan María) → 2 inasistencias
    (2, 2, '2025-04-07', '08:00', '17:00'),  
    (2, 2, '2025-04-08', '08:00', '16:00'),  

    -- Armando asistió todos sus días
    (3, 1, '2025-04-01', '08:00', '16:00'),
    (3, 1, '2025-04-02', '08:00', '16:00'),
    (3, 1, '2025-04-03', '08:00', '16:00'),
    (3, 1, '2025-04-04', '08:00', '16:00'),
    (3, 1, '2025-04-07', '08:00', '16:00'),
    (3, 1, '2025-04-08', '08:00', '16:00'),

    -- Maria faltó 3 días
    (4, 3, '2025-04-01', '08:00', '16:00'),
    -- (04-02, 04-03, 04-04 faltan Ana) → 3 inasistencias
    (4, 3, '2025-04-07', '08:00', '16:00'),
    (4, 3, '2025-04-08', '08:00', '16:00');
