USE parcial2_biblioteca;

DROP PROCEDURE IF EXISTS sp_registrar_devolucion;

DELIMITER $$
CREATE PROCEDURE sp_registrar_devolucion(
    IN p_prestamo_id INT,
    OUT p_multa DECIMAL(10,2)
)
BEGIN
    DECLARE v_fecha_limite DATE;
    DECLARE v_estado VARCHAR(20);
    
    -- 1. Validar que el préstamo exista
    SELECT fecha_limite, estado INTO v_fecha_limite, v_estado 
    FROM prestamos WHERE id = p_prestamo_id;
    
    IF v_fecha_limite IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El préstamo no existe';
    END IF;
    
    -- 2. Validar que no haya sido devuelto
    IF v_estado = 'DEVUELTO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El préstamo ya fue devuelto';
    END IF;
    
    -- 3. Calcular la multa a hoy
    SET p_multa = fn_calcular_multa(v_fecha_limite, CURDATE());
    
    -- 4. Actualizar el préstamo
    UPDATE prestamos 
    SET fecha_devolucion = CURDATE(), multa = p_multa, estado = 'DEVUELTO'
    WHERE id = p_prestamo_id;
    
END$$
DELIMITER ;