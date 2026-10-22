-- ============================================================================
-- PARCIAL 2 - BIBLIOTECA MUNICIPAL DE CARTAGO
-- Archivo de Pruebas y Validaciones (R2 a R7)
-- ============================================================================
USE parcial2_biblioteca;

-- ============================================================================
-- R2. PRUEBAS DE LA FUNCIÓN fn_calcular_multa
-- ============================================================================

-- Prueba 1: A tiempo (Fecha referencia <= Fecha límite) -> Debe dar 0
SELECT fn_calcular_multa('2026-10-30', '2026-10-21') AS 'Caso 1: A tiempo';

-- Prueba 2: Retraso de 5 días (5 * 1500) -> Debe dar 7500
SELECT fn_calcular_multa('2026-10-16', '2026-10-21') AS 'Caso 2: Retraso 5 días';

-- Prueba 3: Retraso de 25 días (25 * 1500 = 37500, pero tope es 30000) -> Debe dar 30000
SELECT fn_calcular_multa('2026-09-26', '2026-10-21') AS 'Caso 3: Tope máximo';

-- Prueba 4: Uso de la función en una consulta con JOIN (Préstamos activos vencidos)
SELECT 
    p.id AS id_prestamo, s.nombre AS socio, l.titulo AS libro,
    p.fecha_limite, DATEDIFF(CURDATE(), p.fecha_limite) AS dias_retraso,
    fn_calcular_multa(p.fecha_limite, CURDATE()) AS multa_estimada
FROM prestamos p
INNER JOIN socios s ON p.socio_id = s.id
INNER JOIN libros l ON p.libro_id = l.id
WHERE p.estado = 'ACTIVO' AND p.fecha_limite < CURDATE();


-- ============================================================================
-- R3. PRUEBAS DEL PROCEDIMIENTO sp_registrar_prestamo (Validaciones)
-- ============================================================================

-- Validación 1: El socio no existe
-- ERROR ESPERADO: 'El socio no existe'
CALL sp_registrar_prestamo('999999', '978-958-001', @id);

-- Validación 2: El socio está suspendido (Santiago, doc: 1112100004)
-- ERROR ESPERADO: 'El socio está suspendido'
CALL sp_registrar_prestamo('1112100004', '978-958-001', @id);

-- Validación 3: El socio tiene multas pendientes (Julián, doc: 1112100002)
-- ERROR ESPERADO: 'El socio tiene multas pendientes'
CALL sp_registrar_prestamo('1112100002', '978-958-001', @id);

-- Validación 4: El socio ya tiene 3 préstamos activos (Mariana ya tiene 2, le sumamos 1)
CALL sp_registrar_prestamo('1112100001', '978-958-006', @id); -- Este funciona (3er préstamo)
-- ERROR ESPERADO (al intentar el 4to): 'El socio ya tiene 3 préstamos activos'
CALL sp_registrar_prestamo('1112100001', '978-958-007', @id);

-- Validación 5: El libro no existe
-- ERROR ESPERADO: 'El libro no existe'
CALL sp_registrar_prestamo('1112100003', '978-000-000', @id);

-- Validación 6: No hay ejemplares disponibles (Libro: Delirio, ISBN: 978-958-004)
-- ERROR ESPERADO: 'No hay ejemplares disponibles'
CALL sp_registrar_prestamo('1112100003', '978-958-004', @id);

-- Caso Exitoso: Préstamo registrado correctamente
CALL sp_registrar_prestamo('1112100003', '978-958-002', @id);
SELECT @id AS 'ID del Nuevo Prestamo';


-- ============================================================================
-- R4. PRUEBAS DEL PROCEDIMIENTO sp_registrar_devolucion
-- ============================================================================

-- Validación 1: El préstamo no existe
-- ERROR ESPERADO: 'El préstamo no existe'
CALL sp_registrar_devolucion(999, @multa);

-- Validación 2: El préstamo ya fue devuelto (ID 6 ya está devuelto)
-- ERROR ESPERADO: 'El préstamo ya fue devuelto'
CALL sp_registrar_devolucion(6, @multa);

-- Caso Exitoso: Devolución del préstamo 3 (Vencido hace 5 días, multa 7500)
CALL sp_registrar_devolucion(3, @multa);
SELECT @multa AS 'Multa Cobrada';


-- ============================================================================
-- R5. PRUEBAS DE LOS TRIGGERS
-- ============================================================================

-- 1. Probar Trigger de Auditoría (trg_auditar_socios)
-- Actualizamos email y estado del socio 1
UPDATE socios SET email = 'mariana.nuevo@correo.com', estado = 'SUSPENDIDO' WHERE id = 1;
-- Verificamos que se hayan insertado los 2 registros en la auditoría
SELECT * FROM auditoria_socios;

-- 2. Probar Trigger de Stock (trg_prestamo_devuelto)
-- El libro 4 (Delirio) tiene 0 ejemplares disponibles.
-- Al devolver el préstamo 4, el trigger debe sumar 1.
CALL sp_registrar_devolucion(4, @multa);
-- Verificamos el stock del libro 4 (Debe pasar de 0 a 1)
SELECT id, titulo, ejemplares_disponibles FROM libros WHERE id = 4;


-- ============================================================================
-- R6. PRUEBAS DE LAS VISTAS
-- ============================================================================

-- 1. Vista con Enmascaramiento
SELECT * FROM vw_socios_publico;

-- 2. Vista con JOIN y Multa Estimada
SELECT * FROM vw_prestamos_activos;


-- ============================================================================
-- R7. PRUEBAS DE SEGURIDAD Y CONEXIONES (Ejecutar con cada usuario)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PRUEBA CON u_lector (Contraseña: Lector2026*)
-- ----------------------------------------------------------------------------
-- Permitido: Acceso a la vista
SELECT * FROM vw_socios_publico;
-- Denegado: Acceso directo a la tabla (Error 1142)
SELECT * FROM socios;

-- ----------------------------------------------------------------------------
-- PRUEBA CON u_bibliotecario (Contraseña: Biblio2026*)
-- ----------------------------------------------------------------------------
-- Permitido: Ejecutar procedimiento
CALL sp_registrar_prestamo('1112100006', '978-958-008', @id);
-- Denegado: Modificar tabla directamente (Error 1142)
UPDATE socios SET nombre = 'Hackeado' WHERE id = 1;

-- ----------------------------------------------------------------------------
-- PRUEBA CON u_admin_biblio (Contraseña: Admin2026*)
-- ----------------------------------------------------------------------------
-- Permitido: Modificar tabla
UPDATE socios SET telefono = '3111111111' WHERE id = 1;
-- Denegado: Borrar tabla de auditoría (Error 1142)
DELETE FROM auditoria_socios;