DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'grup_gerencia') THEN
        CREATE ROLE grup_gerencia NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'grup_atencio') THEN
        CREATE ROLE grup_atencio NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'manager_user') THEN
        CREATE ROLE manager_user LOGIN PASSWORD 'ManagerPagila_2026!';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'staff_user') THEN
        CREATE ROLE staff_user LOGIN PASSWORD 'StaffPagila_2026!';
    END IF;
END
$$;

ALTER ROLE manager_user PASSWORD 'ManagerPagila_2026!';
ALTER ROLE staff_user PASSWORD 'StaffPagila_2026!';

GRANT grup_gerencia TO manager_user;
GRANT grup_atencio TO staff_user;

COMMENT ON ROLE grup_gerencia IS 'Rol de grupo para gerencia';
COMMENT ON ROLE grup_atencio IS 'Rol de grupo para atención';
COMMENT ON ROLE manager_user IS 'Usuario de gerencia';
COMMENT ON ROLE staff_user IS 'Usuario de atención';
