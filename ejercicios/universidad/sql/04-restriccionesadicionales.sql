-- Universidad - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE universidad;

-- la nota va de 0 a 5
ALTER TABLE MATRICULA ADD CONSTRAINT ck_matricula_nota CHECK (nota IS NULL OR nota BETWEEN 0 AND 5);

-- una asignatura no puede ser requisito de si misma
ALTER TABLE PRERREQUISITO ADD CONSTRAINT ck_prerrequisito_distinto CHECK (cod_asignatura <> cod_requisito);

-- los creditos y los pagos son positivos
ALTER TABLE ASIGNATURA ADD CONSTRAINT ck_asignatura_creditos CHECK (creditos > 0);
ALTER TABLE PLANTA ADD CONSTRAINT ck_planta_salario CHECK (salario > 0);
ALTER TABLE CATEDRA ADD CONSTRAINT ck_catedra_valor CHECK (valor_hora > 0 AND horas_semana > 0);
