USE parcial2_biblioteca;

-- 1. Trigger de stock
DROP TRIGGER IF EXISTS trg_prestamo_devuelto;
DELIMITER $$
CREATE TRIGGER trg_prestamo_devuelto
AFTER UPDATE ON prestamos FOR EACH ROW
BEGIN
    IF OLD.estado = 'ACTIVO' AND NEW.estado = 'DEVUELTO' THEN
        UPDATE libros SET ejemplares_disponibles = ejemplares_disponibles + 1 
        WHERE id = NEW.libro_id;
    END IF;
END$$
DELIMITER ;

-- 2. Trigger de auditoría
DROP TRIGGER IF EXISTS trg_auditar_socios;
DELIMITER $$
CREATE TRIGGER trg_auditar_socios
AFTER UPDATE ON socios FOR EACH ROW
BEGIN
    -- Auditar email
    IF NOT (OLD.email <=> NEW.email) THEN
        INSERT INTO auditoria_socios (socio_id, campo, valor_anterior, valor_nuevo, usuario_sesion, usuario_privilegios)
        VALUES (NEW.id, 'email', OLD.email, NEW.email, USER(), CURRENT_USER());
    END IF;
    
    -- Auditar teléfono
    IF NOT (OLD.telefono <=> NEW.telefono) THEN
        INSERT INTO auditoria_socios (socio_id, campo, valor_anterior, valor_nuevo, usuario_sesion, usuario_privilegios)
        VALUES (NEW.id, 'telefono', OLD.telefono, NEW.telefono, USER(), CURRENT_USER());
    END IF;
    
    -- Auditar estado
    IF NOT (OLD.estado <=> NEW.estado) THEN
        INSERT INTO auditoria_socios (socio_id, campo, valor_anterior, valor_nuevo, usuario_sesion, usuario_privilegios)
        VALUES (NEW.id, 'estado', OLD.estado, NEW.estado, USER(), CURRENT_USER());
    END IF;
END$$
DELIMITER ;