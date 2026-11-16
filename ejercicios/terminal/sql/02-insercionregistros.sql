-- Terminal de transporte - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE terminal;



START TRANSACTION;



INSERT INTO TERMINAL (codigo_terminal, nombre, ciudad, pais) VALUES
('BOG', 'Terminal Salitre', 'Bogota', 'Colombia'),
('MED', 'Terminal del Norte', 'Medellin', 'Colombia'),
('BUC', 'Terminal Bucaramanga', 'Bucaramanga', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     licencia, horas_manejo, codigo_terminal, correo, puntos) VALUES
('1010', 'Hector Fabio', 'Rincon Leal', '1980-03-12', 'conductor', 'C2-4410', 21000, 'BOG', NULL, NULL),
('1020', 'Martha Lucia', 'Acosta Vera', '1988-07-25', 'conductor', 'C2-7821', 8400, 'MED', NULL, NULL),
('1030', 'Oscar', 'Guzman Rey', '1975-11-02', 'conductor', 'C3-2190', 30500, 'BOG', NULL, NULL),
('1040', 'Gloria Ines', 'Becerra Sol', '1992-01-18', 'ambos', 'C2-9033', 3900, 'BUC', 'gloria.becerra@correo.co', 200),
('2010', 'Nicolas', 'Pena Franco', '2000-05-30', 'viajero', NULL, NULL, NULL, 'nicolas.pena@correo.co', 640),
('2020', 'Daniela', 'Rivas Ochoa', '1997-09-14', 'viajero', NULL, NULL, NULL, 'daniela.rivas@correo.co', 80),
('2030', 'Julian', 'Montoya Ariza', '1985-12-01', 'viajero', NULL, NULL, NULL, 'julian.montoya@correo.co', 1530),
('2040', 'Sofia', 'Lozano Vega', '2003-04-22', 'viajero', NULL, NULL, NULL, 'sofia.lozano@correo.co', 0),
('2050', 'Camilo', 'Cifuentes Mar', '1979-08-08', 'viajero', NULL, NULL, NULL, 'camilo.cifuentes@correo.co', 910);

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

INSERT INTO BUS (placa, modelo, marca, codigo_terminal) VALUES
('TSX-101', 'Paradiso 1800', 'Marcopolo', 'BOG'),
('WPK-205', 'Volvo B450', 'Volvo', 'MED'),
('ESR-310', 'Andare', 'Busscar', 'BUC'),
('WPK-601', 'FH 540', 'Volvo', 'BOG'),
('TSX-701', 'Sprinter', 'Mercedes', 'BOG');

INSERT INTO BUS_PASAJEROS (placa, num_sillas) VALUES
('TSX-101', 42),
('WPK-205', 46),
('ESR-310', 40);

INSERT INTO BUS_CARGA (placa, capacidad_kg) VALUES
('WPK-601', 18000.00);

INSERT INTO VIAJE (id_viaje, codigo, fecha, hora_salida, destino, placa, terminal_origen) VALUES
(1, 'RT101', '2026-12-20', '06:30', 'Tunja', 'TSX-101', 'BOG'),
(2, 'RT205', '2026-12-20', '09:15', 'Bogota', 'WPK-205', 'MED'),
(3, 'RT310', '2026-12-21', '14:00', 'Tunja', 'ESR-310', 'BUC'),
(4, 'RT101', '2026-12-22', '06:30', 'Tunja', 'TSX-101', 'BOG'),
(5, 'CG900', '2026-12-22', '22:00', 'Cartagena', 'WPK-601', 'BOG'),
(6, 'RT420', '2026-12-23', '11:45', 'Manizales', 'WPK-205', 'MED');

INSERT INTO CONDUCCION (documento, id_viaje, rol) VALUES
('1010', 1, 'principal'),
('1040', 1, 'relevo'),
('1020', 2, 'principal'),
('1030', 2, 'relevo'),
('1040', 3, 'principal'),
('1020', 3, 'relevo'),
('1030', 4, 'principal'),
('1010', 4, 'relevo'),
('1030', 5, 'principal'),
('1010', 5, 'relevo'),
('1020', 6, 'principal'),
('1040', 6, 'relevo');

INSERT INTO TIQUETE (documento, id_viaje, silla, servicio) VALUES
('2010', 1, '12', 'basico'),
('2010', 3, '5', 'basico'),
('2010', 4, '14', 'basico'),
('2020', 1, '2', 'preferencial'),
('2020', 2, '8', 'basico'),
('2030', 2, '1', 'preferencial'),
('2030', 6, '3', 'preferencial'),
('2040', 3, '20', 'basico'),
('2040', 6, '22', 'basico'),
('2050', 1, '15', 'basico'),
('2050', 3, '9', 'basico'),
('2050', 4, '4', 'preferencial'),
('1040', 2, '18', 'basico');



COMMIT;
