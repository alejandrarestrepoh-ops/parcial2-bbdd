USE parcial2_biblioteca;

DROP PROCEDURE IF EXISTS sp_registrar_prestamo;

DELIMITER $$
CREATE PROCEDURE sp_registrar_prestamo(
    IN p_documento VARCHAR(15),
    IN p_isbn VARCHAR(20),
    OUT p_id_prestamo INT
)
BEGIN
    DECLARE v_socio_id INT;
    DECLARE v_libro_id INT;
    DECLARE v_estado VARCHAR(20);
    DECLARE v_multas INT;
    DECLARE v_prestamos_activos INT;
    DECLARE v_disponibles INT;
    
    -- 1. Validar que el socio exista
    SELECT id, estado INTO v_socio_id, v_estado 
    FROM socios WHERE documento = p_documento;
    
    IF v_socio_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El socio no existe';
    END IF;
    
    -- 2. Validar que el socio esté ACTIVO
    IF v_estado = 'SUSPENDIDO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El socio está suspendido';
    END IF;
    
    -- 3. Validar que no tenga multas pendientes
    SELECT COUNT(*) INTO v_multas 
    FROM prestamos WHERE socio_id = v_socio_id AND multa > 0 AND multa_pagada = 0;
    
    IF v_multas > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El socio tiene multas pendientes';
    END IF;
    
    -- 4. Validar que no tenga 3 o más préstamos ACTIVOS
    SELECT COUNT(*) INTO v_prestamos_activos 
    FROM prestamos WHERE socio_id = v_socio_id AND estado = 'ACTIVO';
    
    IF v_prestamos_activos >= 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El socio ya tiene 3 préstamos activos';
    END IF;
    
    -- 5. Validar que el libro exista
    SELECT id, ejemplares_disponibles INTO v_libro_id, v_disponibles 
    FROM libros WHERE isbn = p_isbn;
    
    IF v_libro_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El libro no existe';
    END IF;
    
    -- 6. Validar que haya ejemplares disponibles
    IF v_disponibles <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ejemplares disponibles';
    END IF;
    
    -- Si todo está bien, registrar el préstamo
    INSERT INTO prestamos (socio_id, libro_id, fecha_prestamo, fecha_limite, estado)
    VALUES (v_socio_id, v_libro_id, CURDATE(), CURDATE() + INTERVAL 15 DAY, 'ACTIVO');
    
    SET p_id_prestamo = LAST_INSERT_ID();
    
    -- Descontar el ejemplar
    UPDATE libros SET ejemplares_disponibles = ejemplares_disponibles - 1 
    WHERE id = v_libro_id;
    
END$$
DELIMITER ;