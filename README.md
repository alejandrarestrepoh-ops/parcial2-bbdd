# Parcial 2 - Biblioteca Municipal de Cartago
**Asignatura:** Bases de Datos II  
**Estudiante:** Alejandra Restrepo  
**Fecha:** 21 de octubre de 2026  

## Pasos para ejecutar la solución
Para reproducir este parcial, los scripts deben ejecutarse en el siguiente orden estricto usando el usuario `root`:
1. `parcial2.sql` (Crea la base de datos y los datos de prueba).
2. `fn_calcular_multa.sql` (Crea la función de cálculo de multas).
3. `sp_registrar_prestamo.sql , sp_registrar_devolucion` (Crea los procedimientos de préstamo y devolución).
4. `creacion_trigger1.sql` (Crea los triggers de stock y auditoría).
5. `creacion_vistas1.sql` (Crea las vistas de enmascaramiento y JOIN).
6. `roles y usuarios_parcial.sql` (Crea los roles y usuarios).
7. `pruebas.sql` (Contiene las consultas de prueba y validaciones).

## Explicación de los objetos creados

### R2. Función
*   **`fn_calcular_multa(p_fecha_limite, p_fecha_referencia)`**: Calcula la multa por retraso. Retorna 0 si está a tiempo, o $1.500 por cada día de retraso, con un tope máximo de $30.000.

### R3. Procedimiento de Préstamo
*   **`sp_registrar_prestamo(...)`**: Valida que el socio exista, esté activo, no tenga multas pendientes y no exceda los 3 préstamos activos. También valida que el libro exista y tenga ejemplares disponibles. Si todo está bien, registra el préstamo y descuenta un ejemplar.

### R4. Procedimiento de Devolución
*   **`sp_registrar_devolucion(...)`**: Valida que el préstamo exista y no haya sido devuelto. Calcula la multa usando la función del R2, actualiza el estado del préstamo a 'DEVUELTO' y retorna el valor de la multa.

### R5. Triggers
*   **`trg_prestamo_devuelto`**: Trigger `AFTER UPDATE` en `prestamos`. Cuando el estado cambia a 'DEVUELTO', suma automáticamente 1 a los ejemplares disponibles del libro.
*   **`trg_auditar_socios`**: Trigger `AFTER UPDATE` en `socios`. Registra en la tabla `auditoria_socios` cualquier cambio en el email, teléfono o estado, guardando el valor anterior, el nuevo, `USER()` y `CURRENT_USER()`.

### R6. Vistas
*   **`vw_socios_publico`**: Muestra los datos del socio ocultando el email y enmascarando el documento y teléfono (solo muestra los últimos 4 dígitos).
*   **`vw_prestamos_activos`**: Realiza un JOIN entre `prestamos`, `socios` y `libros`. Muestra los días de retraso y la multa estimada usando la función del R2.

### R7. Seguridad (Roles y Usuarios)
*   **Roles:**
    *   `rol_lector`: Solo puede hacer `SELECT` sobre las dos vistas del R6.
    *   `rol_bibliotecario`: Hereda de `rol_lector` y tiene permiso `EXECUTE` sobre los procedimientos y la función.
    *   `rol_admin_biblioteca`: Tiene permisos `SELECT, INSERT, UPDATE, DELETE` sobre las tablas base, pero **solo** `SELECT` sobre la tabla de auditoría (no puede borrarla).
*   **Usuarios:**
    *   `u_lector` / `Lector2026*` (rol por defecto: `rol_lector`).
    *   `u_bibliotecario` / `Biblio2026*` (rol por defecto: `rol_bibliotecario`, contraseña expira en 60 días, máx 3 conexiones).
    *   `u_admin_biblio` / `Admin2026*` (rol por defecto: `rol_admin_biblioteca`).

## Capturas de Pantalla
Las evidencias visuales de la ejecución de los scripts, las pruebas de los triggers, la función, y las pruebas de conexión (permitidas y denegadas) con cada usuario se encuentran en la carpeta **`capturas/`** de este repositorio.
