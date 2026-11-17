-- Agencia de turismo - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE turismo;



START TRANSACTION;



INSERT INTO OFICINA (codigo_oficina, nombre, ciudad, pais) VALUES
('SMR', 'Oficina Rodadero', 'Santa Marta', 'Colombia'),
('BOG', 'Oficina Centro', 'Bogota', 'Colombia'),
('CTG', 'Oficina Bocagrande', 'Cartagena', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     registro_rnt, anios_experiencia, codigo_oficina, correo, puntos) VALUES
('1010', 'Mauricio', 'Aguilar Pena', '1980-03-12', 'guia', 'RNT-1201', 12, 'SMR', NULL, NULL),
('1020', 'Viviana', 'Castro Lugo', '1988-07-25', 'guia', 'RNT-1388', 7, 'BOG', NULL, NULL),
('1030', 'Fernando', 'Ibarra Nieto', '1975-11-02', 'guia', 'RNT-0975', 20, 'SMR', NULL, NULL),
('1040', 'Lina Marcela', 'Barrera Soto', '1992-01-18', 'ambos', 'RNT-1590', 3, 'CTG', 'lina.barrera@correo.co', 300),
('2010', 'Kevin', 'Moreno Toro', '2000-05-30', 'turista', NULL, NULL, NULL, 'kevin.moreno@correo.co', 900),
('2020', 'Adriana', 'Leal Ortiz', '1997-09-14', 'turista', NULL, NULL, NULL, 'adriana.leal@correo.co', 150),
('2030', 'Samuel', 'Velasquez Rey', '1985-12-01', 'turista', NULL, NULL, NULL, 'samuel.velasquez@correo.co', 2100),
('2040', 'Paula', 'Jimenez Cruz', '2003-04-22', 'turista', NULL, NULL, NULL, 'paula.jimenez@correo.co', 0),
('2050', 'Hernan', 'Quiroga Paz', '1979-08-08', 'turista', NULL, NULL, NULL, 'hernan.quiroga@correo.co', 1250);

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

INSERT INTO VEHICULO (placa, modelo, marca, codigo_oficina) VALUES
('TUR-101', 'Sprinter', 'Mercedes', 'SMR'),
('TUR-205', 'H350', 'Hyundai', 'BOG'),
('TUR-310', 'Urvan', 'Nissan', 'CTG'),
('LAN-601', 'Bravo 34', 'Yamaha', 'SMR'),
('TUR-701', 'Vito', 'Mercedes', 'SMR');

INSERT INTO BUSETA (placa, num_sillas) VALUES
('TUR-101', 19),
('TUR-205', 16),
('TUR-310', 15);

INSERT INTO LANCHA (placa, eslora_m) VALUES
('LAN-601', 10.40);

INSERT INTO TOUR (id_tour, codigo, fecha, hora_salida, destino, placa, oficina_tour) VALUES
(1, 'TAY01', '2026-12-10', '06:00', 'Tayrona', 'TUR-101', 'SMR'),
(2, 'ZIP02', '2026-12-10', '07:00', 'Zipaquira', 'TUR-205', 'BOG'),
(3, 'TAY03', '2026-12-11', '05:00', 'Tayrona', 'TUR-310', 'CTG'),
(4, 'TAY01', '2026-12-12', '06:00', 'Tayrona', 'TUR-101', 'SMR'),
(5, 'BAH05', '2026-12-12', '09:00', 'Bahia Concha', 'LAN-601', 'SMR'),
(6, 'GUA06', '2026-12-13', '08:00', 'Guatavita', 'TUR-205', 'BOG');

INSERT INTO GUIANZA (documento, id_tour, rol) VALUES
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

INSERT INTO RESERVA (documento, id_tour, silla, plan) VALUES
('2010', 1, '12', 'basico'),
('2010', 3, '5', 'basico'),
('2010', 4, '14', 'basico'),
('2020', 1, '2', 'premium'),
('2020', 2, '8', 'basico'),
('2030', 2, '1', 'premium'),
('2030', 6, '3', 'premium'),
('2040', 3, '20', 'basico'),
('2040', 6, '22', 'basico'),
('2050', 1, '15', 'basico'),
('2050', 3, '9', 'basico'),
('2050', 4, '4', 'premium'),
('1040', 2, '18', 'basico');



COMMIT;
