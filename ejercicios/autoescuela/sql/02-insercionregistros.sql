-- Escuela de conducción - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE autoescuela;

START TRANSACTION;

INSERT INTO SEDE (codigo_sede, nombre, direccion) VALUES
('KEN', 'Sede Kennedy', 'Av 1 de Mayo # 72-10'),
('ENG', 'Sede Engativa', 'Cll 80 # 78-20'),
('USA', 'Sede Usaquen', 'Cra 7 # 140-15');

INSERT INTO CURSO (codigo_curso, nombre, horas_teoria, horas_practica) VALUES
('A1', 'Moto hasta 125 cc', 20, 10),
('A2', 'Moto de mas de 125 cc', 20, 15),
('B1', 'Carro particular', 30, 20),
('C2', 'Camion rigido', 40, 30);

INSERT INTO ALUMNO (documento, nombres, apellidos, fecha_nacimiento, correo, codigo_curso) VALUES
('9010', 'Santiago', 'Uribe Lara', '2006-03-14', 'santiago.uribe@correo.co', 'B1'),
('9020', 'Melissa', 'Torres Rey', '2001-08-09', 'melissa.torres@correo.co', 'A2'),
('9030', 'Cristian', 'Galvis Soto', '1998-12-01', 'cristian.galvis@correo.co', 'C2'),
('9040', 'Juliana', 'Pineda Mejia', '2004-05-22', 'juliana.pineda@correo.co', 'B1'),
('9050', 'Hugo', 'Arevalo Diaz', '1979-07-30', 'hugo.arevalo@correo.co', 'A2'),
('9060', 'Ximena', 'Rozo Gil', '2000-10-10', 'ximena.rozo@correo.co', 'B1');

INSERT INTO INSTRUCTOR (documento, nombres, apellidos, fecha_nacimiento, licencia_instructor, codigo_sede) VALUES
('8010', 'Orlando', 'Bernal Rojas', '1976-04-03', 'INS-3301', 'KEN'),
('8020', 'Claudia', 'Benavides Paz', '1983-09-12', 'INS-4472', 'ENG'),
('8030', 'Rafael', 'Contreras Gil', '1969-01-25', 'INS-2208', 'KEN'),
('8040', 'Angela Maria', 'Rendon Cruz', '1990-06-30', 'INS-5019', 'USA'),
('8050', 'Jairo', 'Ospina Vela', '1981-02-17', 'INS-6120', 'USA');

INSERT INTO ALU_TELEFONO (documento, telefono) VALUES
('9010', '3001230001'),
('9010', '6011230002'),
('9020', '3101230003'),
('9030', '3111230004'),
('9040', '3121230005'),
('9040', '6011230006'),
('9050', '3131230007'),
('9060', '3141230008');

INSERT INTO OFERTA (codigo_sede, codigo_curso, precio) VALUES
('KEN', 'A2', 950000),
('KEN', 'B1', 1450000),
('ENG', 'B1', 1400000),
('ENG', 'C2', 2300000),
('USA', 'B1', 1550000),
('USA', 'A2', 990000),
('USA', 'A1', 780000);

INSERT INTO VEHICULO (placa, marca, anio, doc_responsable) VALUES
('ABC123', 'Chevrolet', 2022, '8010'),
('XYZ789', 'Renault', 2021, '8020'),
('MTO11F', 'AKT', 2023, '8030'),
('TRK701', 'Chevrolet', 2019, '8040'),
('BUS900', 'Hino', 2018, '8050');

INSERT INTO CARRO (placa, num_puertas) VALUES
('ABC123', 5),
('XYZ789', 4);

INSERT INTO MOTO (placa, cilindraje_cc) VALUES
('MTO11F', 150);

INSERT INTO CAMION (placa, capacidad_ton) VALUES
('TRK701', 4.5);

INSERT INTO PRACTICA (doc_alumno, doc_instructor, placa, fecha, hora, kilometros) VALUES
('9010', '8010', 'ABC123', '2026-11-10', '07:00', 12),
('9010', '8010', 'ABC123', '2026-11-12', '07:00', 15),
('9010', '8020', 'XYZ789', '2026-11-14', '09:00', 18),
('9040', '8010', 'ABC123', '2026-11-10', '09:00', 10),
('9040', '8020', 'XYZ789', '2026-11-11', '15:00', 14),
('9060', '8040', 'XYZ789', '2026-11-13', '10:00', 9),
('9060', '8020', 'ABC123', '2026-11-16', '11:00', 8),
('9020', '8030', 'MTO11F', '2026-11-11', '08:00', 20),
('9050', '8030', 'MTO11F', '2026-11-12', '08:00', 22),
('9030', '8040', 'TRK701', '2026-11-15', '06:30', 30);

COMMIT;
