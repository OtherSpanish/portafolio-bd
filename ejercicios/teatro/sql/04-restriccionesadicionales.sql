-- Teatro - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE teatro;

-- quien es cantante debe tener sus datos
ALTER TABLE ACTOR ADD CONSTRAINT ck_actor_cantante CHECK (
  tipo_actor IS NULL OR tipo_actor NOT IN ('cantante', 'ambos') OR (registro_vocal IS NOT NULL));

-- quien es bailarin debe tener sus datos
ALTER TABLE ACTOR ADD CONSTRAINT ck_actor_bailarin CHECK (
  tipo_actor IS NULL OR tipo_actor NOT IN ('bailarin', 'ambos') OR (estilo_baile IS NOT NULL));

-- un actor no puede ser suplente de si mismo
ALTER TABLE SUPLENCIA ADD CONSTRAINT ck_suplencia_distinto CHECK (id_suplente <> id_titular);

-- una silla no se vende dos veces en la misma funcion
ALTER TABLE BOLETA ADD CONSTRAINT uq_boleta_silla UNIQUE (id_funcion, fila, silla);

-- precio y aforo positivos
ALTER TABLE FUNCION ADD CONSTRAINT ck_funcion_precio CHECK (precio > 0);
ALTER TABLE TEATRO ADD CONSTRAINT ck_teatro_aforo CHECK (aforo > 0);
