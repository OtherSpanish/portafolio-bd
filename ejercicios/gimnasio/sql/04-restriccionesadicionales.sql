-- Gimnasio - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE gimnasio;

-- precios y meses positivos
ALTER TABLE PLAN ADD CONSTRAINT ck_plan_valores CHECK (precio_mes > 0 AND meses > 0);

-- cada maquina con su dato positivo
ALTER TABLE CARDIO ADD CONSTRAINT ck_cardio_vel CHECK (velocidad_max > 0);
ALTER TABLE FUERZA ADD CONSTRAINT ck_fuerza_peso CHECK (peso_max_kg > 0);

-- un serial no puede estar en las dos tablas: se revisa con la vista v_maquina
-- (MySQL no deja CHECK entre tablas)
