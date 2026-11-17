-- Escuela de conducción - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE autoescuela;



START TRANSACTION;



INSERT INTO SEDE (codigo_sede, nombre, ciudad, pais) VALUES
('BOG', 'Sede Suba', 'Bogota', 'Colombia'),
('MED', 'Sede Belen', 'Medellin', 'Colombia'),
('BUC', 'Sede Cabecera', 'Bucaramanga', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     licencia, horas_instruccion, codigo_sede, correo, horas_practica) VALUES
('1010', 'Wilson', 'Ardila Mora', '1980-03-12', 'instructor', 'INS-3301', 8400, 'BOG', NULL, NULL),
('1020', 'Claudia', 'Benavides Paz', '1988-07-25', 'instructor', 'INS-4472', 3100, 'MED', NULL, NULL),
('1030', 'Rafael', 'Contreras Gil', '1975-11-02', 'instructor', 'INS-2208', 12000, 'BOG', NULL, NULL),
('1040', 'Angela Maria', 'Rendon Cruz', '1992-01-18', 'ambos', 'INS-5019', 1500, 'BUC', 'angela.rendon@correo.co', 12),
('2010', 'Santiago', 'Uribe Lara', '2000-05-30', 'alumno', NULL, NULL, NULL, 'santiago.uribe@correo.co', 20),
('2020', 'Melissa', 'Torres Rey', '1997-09-14', 'alumno', NULL, NULL, NULL, 'melissa.torres@correo.co', 6),
('2030', 'Cristian', 'Galvis Soto', '1985-12-01', 'alumno', NULL, NULL, NULL, 'cristian.galvis@correo.co', 18),
('2040', 'Juliana', 'Pineda Mejia', '2003-04-22', 'alumno', NULL, NULL, NULL, 'juliana.pineda@correo.co', 2),
('2050', 'Orlando', 'Bernal Rojas', '1979-08-08', 'alumno', NULL, NULL, NULL, 'orlando.bernal@correo.co', 25);

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

INSERT INTO VEHICULO (placa, modelo, marca, codigo_sede) VALUES
('ABC-101', 'Spark', 'Chevrolet', 'BOG'),
('XYZ-205', 'Logan', 'Renault', 'MED'),
('DEF-310', 'Picanto', 'Kia', 'BUC'),
('MTO-11F', 'NKD 125', 'AKT', 'BOG'),
('TRK-701', 'NHR', 'Chevrolet', 'BOG');

INSERT INTO CARRO (placa, num_puertas) VALUES
('ABC-101', 5),
('XYZ-205', 4),
('DEF-310', 5);

INSERT INTO MOTO (placa, cilindraje_cc) VALUES
('MTO-11F', 125.00);

INSERT INTO PRACTICA (id_practica, codigo, fecha, hora_inicio, recorrido, placa, sede_practica) VALUES
(1, 'URB01', '2026-12-01', '07:00', 'Ruta urbana', 'ABC-101', 'BOG'),
(2, 'PAR02', '2026-12-01', '08:00', 'Parqueo', 'XYZ-205', 'MED'),
(3, 'URB03', '2026-12-02', '07:00', 'Ruta urbana', 'DEF-310', 'BUC'),
(4, 'URB01', '2026-12-03', '07:00', 'Ruta urbana', 'ABC-101', 'BOG'),
(5, 'MOT05', '2026-12-03', '15:00', 'Circuito motos', 'MTO-11F', 'BOG'),
(6, 'CAR06', '2026-12-04', '06:00', 'Carretera', 'XYZ-205', 'MED');

INSERT INTO INSTRUCCION (documento, id_practica, rol) VALUES
('1010', 1, 'principal'),
('1040', 1, 'apoyo'),
('1020', 2, 'principal'),
('1030', 2, 'apoyo'),
('1040', 3, 'principal'),
('1020', 3, 'apoyo'),
('1030', 4, 'principal'),
('1010', 4, 'apoyo'),
('1030', 5, 'principal'),
('1010', 5, 'apoyo'),
('1020', 6, 'principal'),
('1040', 6, 'apoyo');

INSERT INTO INSCRIPCION (documento, id_practica, turno, nivel) VALUES
('2010', 1, '12', 'basico'),
('2010', 3, '5', 'basico'),
('2010', 4, '14', 'basico'),
('2020', 1, '2', 'avanzado'),
('2020', 2, '8', 'basico'),
('2030', 2, '1', 'avanzado'),
('2030', 6, '3', 'avanzado'),
('2040', 3, '20', 'basico'),
('2040', 6, '22', 'basico'),
('2050', 1, '15', 'basico'),
('2050', 3, '9', 'basico'),
('2050', 4, '4', 'avanzado'),
('1040', 2, '18', 'basico');



COMMIT;
