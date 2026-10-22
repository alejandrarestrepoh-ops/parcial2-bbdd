USE parcial2_biblioteca;

DROP FUNCTION IF EXISTS fn_calcular_multa;

DELIMITER $$
CREATE FUNCTION fn_calcular_multa(p_fecha_limite DATE, p_fecha_referencia DATE) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_dias INT;
    DECLARE v_multa DECIMAL(10,2);
    
    -- Si no hay retraso, la multa es 0
    IF p_fecha_referencia <= p_fecha_limite THEN
        RETURN 0.00;
    END IF;
    
    -- Calculamos los días de retraso
    SET v_dias = DATEDIFF(p_fecha_referencia, p_fecha_limite);
    
    -- $1500 por día
    SET v_multa = v_dias * 1500;
    
    -- Tope máximo de $30,000
    IF v_multa > 30000 THEN
        SET v_multa = 30000;
    END IF;
    
    RETURN v_multa;
END$$
DELIMITER ;