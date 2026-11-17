-- Teatro - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE teatro;

START TRANSACTION;

INSERT INTO ESPECTADOR (documento, nombres, apellidos, fecha_nacimiento, correo) VALUES
('3010', 'Mariana', 'Acosta Rey', '1991-02-11', 'mariana.acosta@correo.co'),
('3020', 'Julian', 'Bravo Diaz', '1987-05-23', 'julian.bravo@correo.co'),
('3030', 'Natalia', 'Cortes Gil', '2000-09-02', 'natalia.cortes@correo.co'),
('3040', 'Hernan', 'Duarte Paz', '1965-12-15', 'hernan.duarte@correo.co'),
('3050', 'Isabel', 'Franco Luna', '1995-03-30', 'isabel.franco@correo.co'),
('3060', 'Tomas', 'Guerra Vela', '2004-07-18', 'tomas.guerra@correo.co');

INSERT INTO TEATRO (codigo_teatro, nombre, direccion, aforo) VALUES
('COL', 'Teatro Colon', 'Cll 10 # 5-32', 900),
('MAY', 'Teatro Mayor', 'Av Cll 170 # 67-51', 1300),
('LIB', 'Teatro Libre', 'Cra 11 # 61-80', 350);

INSERT INTO OBRA (id_obra, titulo, autor, duracion_min) VALUES
(1, 'La Casa de Bernarda Alba', 'Federico Garcia Lorca', 110),
(2, 'Cats', 'Andrew Lloyd Webber', 150),
(3, 'El Avaro', 'Moliere', 95),
(4, 'Chicago', 'John Kander', 140),
(5, 'Esperando a Godot', 'Samuel Beckett', 120);

INSERT INTO ACTOR (id_actor, nombre_artistico, nombres, apellidos, tipo_actor, registro_vocal, estilo_baile) VALUES
('A01', 'Lucho Ramos', 'Luis Fernando', 'Ramos Pardo', NULL, NULL, NULL),
('A02', 'Vicky Mar', 'Victoria', 'Martinez Cruz', 'cantante', 'soprano', NULL),
('A03', 'Tono Danza', 'Antonio', 'Gil Rojas', 'bailarin', NULL, 'jazz'),
('A04', 'Cami Luz', 'Camila', 'Luz Herrera', 'ambos', 'mezzosoprano', 'contemporaneo'),
('A05', 'Pedro Sol', 'Pedro', 'Soler Mesa', NULL, NULL, NULL),
('A06', 'Sara Vega', 'Sara', 'Vega Leon', 'ambos', 'contralto', 'tap'),
('A07', 'Diego Ruiz', 'Diego', 'Ruiz Tapia', 'cantante', 'baritono', NULL);

INSERT INTO ESP_TELEFONO (documento, telefono) VALUES
('3010', '3011234567'),
('3010', '6012345678'),
('3020', '3022345678'),
('3030', '3033456789'),
('3030', '6014567890'),
('3040', '3044567890'),
('3050', '3055678901'),
('3060', '3066789012');

INSERT INTO OBR_GENERO (id_obra, genero) VALUES
(1, 'drama'),
(2, 'musical'),
(2, 'infantil'),
(3, 'comedia'),
(4, 'musical'),
(4, 'comedia'),
(5, 'drama'),
(5, 'absurdo');

INSERT INTO REPARTO (id_actor, id_obra, personaje) VALUES
('A01', 3, 'Harpagon'),
('A05', 3, 'Cleante'),
('A02', 2, 'Grizabella'),
('A04', 2, 'Jellylorum'),
('A03', 2, 'Mistoffelees'),
('A04', 4, 'Roxie Hart'),
('A06', 4, 'Velma Kelly'),
('A07', 4, 'Billy Flynn'),
('A06', 1, 'Adela'),
('A02', 1, 'Bernarda'),
('A01', 5, 'Vladimir'),
('A05', 5, 'Estragon');

INSERT INTO SUPLENCIA (id_suplente, id_titular) VALUES
('A05', 'A01'),
('A06', 'A04'),
('A07', 'A02');

INSERT INTO FUNCION (id_funcion, fecha, hora, precio, codigo_teatro, id_obra) VALUES
(1, '2026-12-04', '20:00', 85000, 'COL', 1),
(2, '2026-12-05', '20:00', 85000, 'COL', 1),
(3, '2026-12-05', '19:30', 120000, 'MAY', 2),
(4, '2026-12-06', '16:00', 95000, 'MAY', 4),
(5, '2026-12-06', '20:00', 45000, 'LIB', 3),
(6, '2026-12-07', '18:00', 45000, 'LIB', 3);

INSERT INTO BOLETA (documento, id_funcion, fila, silla) VALUES
('3010', 1, 'C', 10),
('3010', 3, 'F', 4),
('3010', 5, 'A', 2),
('3020', 1, 'C', 11),
('3030', 1, 'D', 1),
('3030', 2, 'B', 7),
('3040', 3, 'F', 5),
('3050', 4, 'H', 12),
('3060', 4, 'H', 13),
('3020', 6, 'A', 1);

COMMIT;
