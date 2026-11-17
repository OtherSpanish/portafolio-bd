-- Clínica - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE clinica;

-- tipo de sangre valido
ALTER TABLE PACIENTE ADD CONSTRAINT ck_paciente_sangre CHECK (tipo_sangre IN ('O+','O-','A+','A-','B+','B-','AB+','AB-'));

-- un medico no tiene dos citas a la misma hora
ALTER TABLE CITA ADD CONSTRAINT uq_cita_medico_hora UNIQUE (id_medico, fecha, hora);

-- dias validos del turno
ALTER TABLE TURNO ADD CONSTRAINT ck_turno_dia CHECK (dia IN ('lunes','martes','miercoles','jueves','viernes','sabado'));
