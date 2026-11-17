-- Terminal de transporte - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE terminal;

START TRANSACTION;

INSERT INTO EMPRESA (nit, razon_social, ciudad_sede) VALUES
('860001234', 'Expreso Bolivariano', 'Bogota'),
('890905678', 'Rapido Ochoa', 'Medellin'),
('800204321', 'Coomotor', 'Neiva');

INSERT INTO BUS (placa, marca, capacidad, nit) VALUES
('TSX123', 'Mercedes Benz', 40, '860001234'),
('WMR456', 'Volvo', 42, '890905678'),
('UFT789', 'Chevrolet', 30, '800204321'),
('TSX321', 'Mercedes Benz', 40, '860001234'),
('KLM654', 'Scania', 44, '890905678');

INSERT INTO TERMINAL (codigo_terminal, nombre, ciudad) VALUES
('BOG', 'Terminal Salitre', 'Bogota'),
('MED', 'Terminal del Norte', 'Medellin'),
('TUN', 'Terminal de Tunja', 'Tunja'),
('CAL', 'Terminal de Cali', 'Cali');

INSERT INTO TAQUILLA (nit, codigo_terminal, numero_taquilla) VALUES
('860001234', 'BOG', 'T-12'),
('860001234', 'TUN', 'T-03'),
('860001234', 'CAL', 'T-07'),
('890905678', 'BOG', 'T-20'),
('890905678', 'MED', 'T-01'),
('800204321', 'BOG', 'T-31'),
('800204321', 'CAL', 'T-15');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona, licencia, categoria_licencia, correo, nit) VALUES
('1010', 'Luis Alberto', 'Gomez Pardo', '1978-02-14', 'conductor', 'LC-55120', 'C2', NULL, '860001234'),
('1020', 'Ramiro', 'Castano Ruiz', '1982-06-30', 'conductor', 'LC-60311', 'C3', NULL, '890905678'),
('1030', 'Wilson', 'Pena Mora', '1975-10-09', 'conductor', 'LC-48877', 'C2', NULL, '800204321'),
('1040', 'Gloria Ines', 'Ramirez Toro', '1986-03-22', 'ambos', 'LC-71002', 'C2', 'gloria.ramirez@correo.co', '860001234'),
('2010', 'Andrea', 'Lozano Diaz', '1999-08-15', 'viajero', NULL, NULL, 'andrea.lozano@correo.co', NULL),
('2020', 'Cristian', 'Mendoza Vela', '1994-01-27', 'viajero', NULL, NULL, 'cristian.mendoza@correo.co', NULL),
('2030', 'Paula', 'Rincon Gil', '2002-05-03', 'viajero', NULL, NULL, 'paula.rincon@correo.co', NULL),
('2040', 'Jaime', 'Ortiz Luna', '1968-11-19', 'viajero', NULL, NULL, 'jaime.ortiz@correo.co', NULL),
('2050', 'Lucia', 'Fajardo Rey', '1990-07-07', 'viajero', NULL, NULL, 'lucia.fajardo@correo.co', NULL);

INSERT INTO RUTA (codigo_ruta, duracion_min, valor, terminal_origen, terminal_destino, nit) VALUES
('BT-01', 180, 38000, 'BOG', 'TUN', '860001234'),
('BM-01', 540, 95000, 'BOG', 'MED', '890905678'),
('BC-01', 600, 110000, 'BOG', 'CAL', '800204321'),
('MB-01', 540, 95000, 'MED', 'BOG', '890905678'),
('TB-01', 180, 38000, 'TUN', 'BOG', '860001234'),
('CB-01', 600, 105000, 'CAL', 'BOG', '860001234');

INSERT INTO PER_TELEFONO (documento, telefono) VALUES
('1010', '3001112222'),
('1010', '6013334444'),
('1020', '3105556666'),
('1030', '3117778888'),
('1040', '3129990000'),
('1040', '6012223333'),
('2010', '3134445555'),
('2010', '6016667777'),
('2020', '3148889999'),
('2030', '3150001111'),
('2040', '3162223333'),
('2050', '3174445555');

INSERT INTO TIQUETE (documento, codigo_ruta, fecha_viaje, silla) VALUES
('2010', 'BT-01', '2026-12-18', 12),
('2010', 'TB-01', '2026-12-22', 5),
('2010', 'BM-01', '2027-01-03', 20),
('2020', 'BT-01', '2026-12-18', 13),
('2030', 'BM-01', '2026-12-19', 7),
('2030', 'MB-01', '2027-01-02', 8),
('2040', 'BC-01', '2026-12-20', 1),
('1040', 'BT-01', '2026-12-18', 30),
('2050', 'BM-01', '2026-12-19', 8),
('2020', 'TB-01', '2026-12-22', 6);

COMMIT;
