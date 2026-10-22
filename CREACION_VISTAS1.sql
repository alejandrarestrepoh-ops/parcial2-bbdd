USE parcial2_biblioteca;

-- 1. Vista enmascarada
CREATE OR REPLACE VIEW vw_socios_publico AS
SELECT 
    id, 
    nombre, 
    CONCAT('******', RIGHT(documento, 4)) AS documento,
    CONCAT('******', RIGHT(telefono, 4)) AS telefono,
    estado
FROM socios;

-- 2. Vista con JOIN
CREATE OR REPLACE VIEW vw_prestamos_activos AS
SELECT 
    p.id AS id_prestamo,
    s.nombre AS socio,
    l.titulo AS libro,
    p.fecha_prestamo,
    p.fecha_limite,
    IFNULL(DATEDIFF(CURDATE(), p.fecha_limite), 0) AS dias_retraso,
    fn_calcular_multa(p.fecha_limite, CURDATE()) AS multa_estimada
FROM prestamos p
INNER JOIN socios s ON p.socio_id = s.id
INNER JOIN libros l ON p.libro_id = l.id
WHERE p.estado = 'ACTIVO';