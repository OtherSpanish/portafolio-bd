-- Clínica - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE clinica;

START TRANSACTION;

INSERT INTO EPS (nit_eps, nombre) VALUES
('900156264', 'Nueva EPS'),
('800251440', 'Sanitas'),
('830003564', 'Famisanar');

INSERT INTO PACIENTE (documento, nombres, apellidos, fecha_nacimiento, tipo_sangre, nit_eps) VALUES
('7010', 'Rosa Elena', 'Patino Gil', '1958-05-12', 'O+', '900156264'),
('7020', 'Kevin', 'Zapata Ruiz', '1999-09-30', 'A+', '800251440'),
('7030', 'Gladys', 'Cifuentes Mora', '1971-01-21', 'B-', '830003564'),
('7040', 'Mateo', 'Quintana Lara', '1988-11-05', 'O-', '900156264'),
('7050', 'Liliana', 'Bohorquez Paz', '1993-04-17', 'AB+', '800251440'),
('7060', 'Arturo', 'Velandia Rey', '1949-08-08', 'O+', '830003564');

INSERT INTO ESPECIALIDAD (id_especialidad, nombre) VALUES
(1, 'Medicina general'),
(2, 'Pediatria'),
(3, 'Cardiologia'),
(4, 'Dermatologia');

INSERT INTO MEDICAMENTO (codigo_medicamento, nombre, presentacion) VALUES
('MED-001', 'Acetaminofen', 'tabletas 500 mg'),
('MED-002', 'Losartan', 'tabletas 50 mg'),
('MED-003', 'Amoxicilina', 'capsulas 500 mg'),
('MED-004', 'Hidrocortisona', 'crema 1%'),
('MED-005', 'Loratadina', 'tabletas 10 mg'),
('MED-006', 'Ibuprofeno', 'tabletas 400 mg');

INSERT INTO MEDICO (id_medico, nombres, apellidos, registro_medico, id_especialidad) VALUES
('M01', 'Adriana', 'Lopez Mejia', 'RM-24051', 1),
('M02', 'Fabio', 'Sandoval Ortiz', 'RM-31882', 3),
('M03', 'Claudia', 'Rivas Toro', 'RM-18190', 1),
('M04', 'Esteban', 'Mora Quintero', 'RM-40233', 4);

INSERT INTO SEDE (codigo_sede, nombre, direccion) VALUES
('NOR', 'Sede Norte', 'Cll 134 # 7-83'),
('CEN', 'Sede Centro', 'Cra 7 # 22-15'),
('SUR', 'Sede Sur', 'Av 1 de Mayo # 52-20');

INSERT INTO PAC_TELEFONO (documento, telefono) VALUES
('7010', '3101234567'),
('7010', '6012345601'),
('7020', '3112345678'),
('7030', '3123456789'),
('7030', '6013456702'),
('7040', '3134567890'),
('7050', '3145678901'),
('7060', '3156789012');

INSERT INTO TURNO (id_medico, codigo_sede, dia) VALUES
('M01', 'NOR', 'lunes'),
('M01', 'NOR', 'miercoles'),
('M01', 'CEN', 'viernes'),
('M02', 'NOR', 'martes'),
('M02', 'SUR', 'jueves'),
('M03', 'CEN', 'lunes'),
('M03', 'SUR', 'martes'),
('M04', 'CEN', 'miercoles');

INSERT INTO CITA (id_cita, fecha, hora, motivo, documento, id_medico) VALUES
(1, '2026-11-20', '08:00', 'control de presion', '7010', 'M02'),
(2, '2026-11-20', '09:00', 'dolor de garganta', '7020', 'M01'),
(3, '2026-11-21', '10:30', 'revision de lunar', '7030', 'M04'),
(4, '2026-11-23', '07:30', 'control general', '7010', 'M01'),
(5, '2026-11-23', '11:00', 'dolor en el pecho', '7060', 'M02'),
(6, '2026-11-24', '15:00', 'alergia', '7050', 'M03'),
(7, '2026-11-25', '09:30', 'control de presion', '7010', 'M02'),
(8, '2026-11-25', '16:00', 'fiebre', '7040', 'M03');

INSERT INTO PRESENCIAL (id_cita, consultorio, codigo_sede) VALUES
(1, 'C-201', 'NOR'),
(3, 'C-105', 'CEN'),
(4, 'C-110', 'NOR'),
(5, 'C-201', 'NOR'),
(7, 'C-202', 'SUR');

INSERT INTO TELECONSULTA (id_cita, enlace, plataforma) VALUES
(2, 'https://meet.clinica.co/a12', 'Meet'),
(6, 'https://teams.clinica.co/b34', 'Teams'),
(8, 'https://meet.clinica.co/c56', 'Meet');

INSERT INTO FORMULA (id_cita, codigo_medicamento, dosis) VALUES
(1, 'MED-002', '1 tableta cada 12 horas'),
(2, 'MED-003', '1 capsula cada 8 horas por 7 dias'),
(2, 'MED-001', '1 tableta cada 6 horas si hay fiebre'),
(3, 'MED-004', 'aplicar 2 veces al dia'),
(5, 'MED-002', '1 tableta cada 12 horas'),
(5, 'MED-001', '1 tableta cada 8 horas'),
(6, 'MED-005', '1 tableta diaria'),
(8, 'MED-001', '1 tableta cada 6 horas');

COMMIT;
