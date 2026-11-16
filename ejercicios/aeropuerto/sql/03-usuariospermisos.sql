-- Aeropuerto - Bases de Datos 1
-- 03: usuarios del motor con el minimo privilegio
-- CAMBIE las contrasenas de ejemplo antes de ejecutar.
-- Ejecutar con un usuario administrador.

CREATE USER IF NOT EXISTS 'aeropuerto_app'@'%' IDENTIFIED BY 'Cambiar_Esta_1';
CREATE USER IF NOT EXISTS 'aeropuerto_lectura'@'%' IDENTIFIED BY 'Cambiar_Esta_2';

-- la aplicacion lee y escribe datos, pero no cambia la estructura
GRANT SELECT, INSERT, UPDATE, DELETE ON aeropuerto.* TO 'aeropuerto_app'@'%';

-- el usuario de consulta solo puede leer
GRANT SELECT ON aeropuerto.* TO 'aeropuerto_lectura'@'%';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'aeropuerto_app'@'%';
SHOW GRANTS FOR 'aeropuerto_lectura'@'%';
