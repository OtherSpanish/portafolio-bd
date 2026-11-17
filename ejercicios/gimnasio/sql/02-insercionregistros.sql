-- Gimnasio - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE gimnasio;

START TRANSACTION;

INSERT INTO PLAN (id_plan, nombre, precio_mes, meses) VALUES
(1, 'Basico', 89000, 1),
(2, 'Trimestral', 240000, 3),
(3, 'Anual', 850000, 12),
(4, 'Estudiante', 69000, 1);

INSERT INTO SOCIO (id_socio, nombres, apellidos, fecha_nacimiento, correo, id_plan) VALUES
('S01', 'Daniela', 'Mejia Rojas', '1995-04-10', 'daniela.mejia@correo.co', 3),
('S02', 'Felipe', 'Arango Diaz', '1990-09-22', 'felipe.arango@correo.co', 1),
('S03', 'Tatiana', 'Mora Gil', '2001-01-05', 'tatiana.mora@correo.co', 4),
('S04', 'Oscar', 'Pineda Ruiz', '1985-06-17', 'oscar.pineda@correo.co', 2),
('S05', 'Lorena', 'Castro Vela', '1998-12-30', 'lorena.castro@correo.co', 3),
('S06', 'Mauricio', 'Leal Soto', '1979-03-08', 'mauricio.leal@correo.co', 1),
('S07', 'Juliana', 'Pena Ortiz', '2003-07-21', 'juliana.pena@correo.co', 4),
('S08', 'Esteban', 'Rios Lara', '1992-11-11', 'esteban.rios@correo.co', 2);

INSERT INTO SEDE (codigo_sede, nombre, direccion, horario) VALUES
('CHA', 'Sede Chapinero', 'Cra 13 # 57-20', '5am a 10pm'),
('SUB', 'Sede Suba', 'Av Suba # 115-50', '5am a 9pm'),
('SOA', 'Sede Soacha', 'Cll 13 # 7-30', '6am a 9pm');

INSERT INTO CARDIO (serial, marca, anio, velocidad_max, codigo_sede) VALUES
('CAR-001', 'Life Fitness', 2021, 20.0, 'CHA'),
('CAR-002', 'Technogym', 2019, 18.5, 'SUB'),
('CAR-003', 'Matrix', 2023, 22.0, 'CHA');

INSERT INTO FUERZA (serial, marca, anio, peso_max_kg, codigo_sede) VALUES
('FUE-001', 'Hammer', 2020, 180, 'CHA'),
('FUE-002', 'Technogym', 2022, 150, 'SUB'),
('FUE-003', 'Matrix', 2018, 200, 'SOA');

INSERT INTO SOC_TELEFONO (id_socio, telefono) VALUES
('S01', '3001112233'),
('S01', '6014567890'),
('S02', '3112223344'),
('S03', '3123334455'),
('S04', '3134445566'),
('S04', '6017654321'),
('S05', '3145556677'),
('S06', '3156667788'),
('S07', '3167778899'),
('S08', '3178889900');

INSERT INTO ASISTENCIA (id_socio, codigo_sede, fecha, hora_entrada) VALUES
('S01', 'CHA', '2026-11-03', '06:10'),
('S01', 'CHA', '2026-11-05', '06:05'),
('S01', 'SUB', '2026-11-08', '09:30'),
('S02', 'CHA', '2026-11-03', '18:20'),
('S03', 'SUB', '2026-11-04', '17:00'),
('S03', 'SUB', '2026-11-06', '17:15'),
('S04', 'CHA', '2026-11-04', '05:45'),
('S04', 'SUB', '2026-11-07', '07:00'),
('S05', 'SOA', '2026-11-05', '19:00'),
('S06', 'CHA', '2026-11-06', '12:30'),
('S07', 'SUB', '2026-11-03', '16:40'),
('S08', 'CHA', '2026-11-07', '20:10');

INSERT INTO ENTRENADOR (id_entrenador, nombres, apellidos, especialidad, certificacion, codigo_sede) VALUES
('T01', 'Carlos', 'Benitez Paz', 'funcional', 'NSCA-CPT', 'CHA'),
('T02', 'Angela', 'Torres Lima', 'pesas', 'ACE', 'SUB'),
('T03', 'Ivan', 'Restrepo Cano', 'cardio', 'ISSA', 'CHA'),
('T04', 'Sara', 'Gomez Luna', 'yoga', 'RYT-200', 'SOA');

INSERT INTO ASESORIA (id_socio, id_entrenador, desde) VALUES
('S01', 'T01', '2026-06-01'),
('S03', 'T02', '2026-08-15'),
('S04', 'T01', '2026-09-10'),
('S05', 'T04', '2026-10-01'),
('S07', 'T02', '2026-10-20');

COMMIT;
