USE parcial2_biblioteca;

-- Limpiamos cualquier intento anterior
DROP USER IF EXISTS 'u_lector'@'localhost';
DROP USER IF EXISTS 'u_bibliotecario'@'localhost';
DROP USER IF EXISTS 'u_admin_biblio'@'localhost';

-- 1. Crear los usuarios exclusivamente para localhost
CREATE USER 'u_lector'@'localhost' IDENTIFIED BY 'Lector2026*';
CREATE USER 'u_bibliotecario'@'localhost' IDENTIFIED BY 'Biblio2026*';
CREATE USER 'u_admin_biblio'@'localhost' IDENTIFIED BY 'Admin2026*';

-- 2. Asignar los roles que ya creaste
GRANT rol_lector TO 'u_lector'@'localhost';
GRANT rol_bibliotecario TO 'u_bibliotecario'@'localhost';
GRANT rol_admin_biblioteca TO 'u_admin_biblio'@'localhost';

-- 3. Activar los roles por defecto
SET DEFAULT ROLE rol_lector FOR 'u_lector'@'localhost';
SET DEFAULT ROLE rol_bibliotecario FOR 'u_bibliotecario'@'localhost';
SET DEFAULT ROLE rol_admin_biblioteca FOR 'u_admin_biblio'@'localhost';

FLUSH PRIVILEGES;