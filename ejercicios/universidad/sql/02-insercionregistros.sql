-- Universidad - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE universidad;



START TRANSACTION;



INSERT INTO SEDE (codigo_sede, nombre, ciudad, pais) VALUES
('BOG', 'Sede Usaquen', 'Bogota', 'Colombia'),
('MED', 'Sede Poblado', 'Medellin', 'Colombia'),
('CAL', 'Sede Granada', 'Cali', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     registro, anios_experiencia, codigo_sede, correo, creditos) VALUES
('1010', 'Jorge Ivan', 'Pardo Silva', '1980-03-12', 'profesor', 'REG-1201', 18, 'BOG', NULL, NULL),
('1020', 'Diana Carolina', 'Mesa Rios', '1988-07-25', 'profesor', 'REG-1388', 9, 'MED', NULL, NULL),
('1030', 'Ricardo', 'Nunez Vela', '1975-11-02', 'profesor', 'REG-0975', 25, 'BOG', NULL, NULL),
('1040', 'Sara Lucia', 'Quintero Paz', '1992-01-18', 'ambos', 'REG-1590', 4, 'CAL', 'sara.quintero@correo.co', 30),
('2010', 'Tomas', 'Bermudez Cano', '2000-05-30', 'estudiante', NULL, NULL, NULL, 'tomas.bermudez@correo.co', 112),
('2020', 'Camila', 'Ospina Reyes', '1997-09-14', 'estudiante', NULL, NULL, NULL, 'camila.ospina@correo.co', 64),
('2030', 'Juan David', 'Arango Mejia', '1985-12-01', 'estudiante', NULL, NULL, NULL, 'juan.arango@correo.co', 140),
('2040', 'Mariana', 'Cardenas Ruiz', '2003-04-22', 'estudiante', NULL, NULL, NULL, 'mariana.cardenas@correo.co', 16),
('2050', 'Felipe', 'Salazar Duque', '1979-08-08', 'estudiante', NULL, NULL, NULL, 'felipe.salazar@correo.co', 88);

INSERT INTO PER_TELEFONO (documento, telefono) VALUES
('1010', '3001112233'),
('1010', '6015550101'),
('1020', '3104445566'),
('1030', '3207778899'),
('1040', '3156667788'),
('1040', '3019990000'),
('2010', '3121234567'),
('2020', '3189876543'),
('2030', '3001239876'),
('2030', '6047771234'),
('2040', '3165554433'),
('2050', '3112223344');

INSERT INTO SALON (codigo_salon, bloque, piso, codigo_sede) VALUES
('S-101', 'Bloque A', 'Piso 1', 'BOG'),
('S-205', 'Bloque B', 'Piso 2', 'MED'),
('S-310', 'Bloque C', 'Piso 3', 'CAL'),
('S-401', 'Bloque B', 'Piso 4', 'BOG'),
('S-115', 'Bloque A', 'Piso 1', 'BOG');

INSERT INTO LABORATORIO (codigo_salon, num_equipos) VALUES
('S-101', 30),
('S-205', 24),
('S-310', 20);

INSERT INTO AUDITORIO (codigo_salon, area_m2) VALUES
('S-401', 180.50);

INSERT INTO CURSO (id_curso, codigo, fecha, hora_inicio, asignatura, codigo_salon, sede_curso) VALUES
(1, 'BD101', '2026-02-02', '07:00', 'Bases de Datos', 'S-101', 'BOG'),
(2, 'PR201', '2026-02-02', '09:00', 'Programacion', 'S-205', 'MED'),
(3, 'BD301', '2026-02-03', '14:00', 'Bases de Datos', 'S-310', 'CAL'),
(4, 'BD101', '2026-02-04', '07:00', 'Bases de Datos', 'S-101', 'BOG'),
(5, 'SE900', '2026-02-04', '18:00', 'Seminario', 'S-401', 'BOG'),
(6, 'CA420', '2026-02-05', '11:00', 'Calculo', 'S-205', 'MED');

INSERT INTO DOCENCIA (documento, id_curso, rol) VALUES
('1010', 1, 'titular'),
('1040', 1, 'auxiliar'),
('1020', 2, 'titular'),
('1030', 2, 'auxiliar'),
('1040', 3, 'titular'),
('1020', 3, 'auxiliar'),
('1030', 4, 'titular'),
('1010', 4, 'auxiliar'),
('1030', 5, 'titular'),
('1010', 5, 'auxiliar'),
('1020', 6, 'titular'),
('1040', 6, 'auxiliar');

INSERT INTO INSCRIPCION (documento, id_curso, puesto, modalidad) VALUES
('2010', 1, '12', 'presencial'),
('2010', 3, '5', 'presencial'),
('2010', 4, '14', 'presencial'),
('2020', 1, '2', 'virtual'),
('2020', 2, '8', 'presencial'),
('2030', 2, '1', 'virtual'),
('2030', 6, '3', 'virtual'),
('2040', 3, '20', 'presencial'),
('2040', 6, '22', 'presencial'),
('2050', 1, '15', 'presencial'),
('2050', 3, '9', 'presencial'),
('2050', 4, '4', 'virtual'),
('1040', 2, '18', 'presencial');



COMMIT;
