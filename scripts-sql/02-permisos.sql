REVOKE ALL ON DATABASE pagila FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM PUBLIC;

GRANT CONNECT ON DATABASE pagila TO grup_gerencia;
GRANT CONNECT ON DATABASE pagila TO grup_atencio;

GRANT USAGE ON SCHEMA public TO grup_gerencia;
GRANT USAGE ON SCHEMA public TO grup_atencio;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE film TO grup_gerencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE rental TO grup_gerencia;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE inventory TO grup_gerencia;
GRANT SELECT ON TABLE customer TO grup_gerencia;
GRANT SELECT ON TABLE payment TO grup_gerencia;
GRANT SELECT ON TABLE staff TO grup_gerencia;
GRANT SELECT ON TABLE store TO grup_gerencia;

GRANT SELECT (film_id, title, description, release_year, rental_duration) ON TABLE film TO grup_atencio;
GRANT SELECT ON TABLE inventory TO grup_atencio;
GRANT SELECT, INSERT ON TABLE rental TO grup_atencio;
GRANT UPDATE (return_date, last_update) ON TABLE rental TO grup_atencio;
GRANT SELECT ON TABLE customer TO grup_atencio;

GRANT USAGE, SELECT ON SEQUENCE rental_rental_id_seq TO grup_gerencia;
GRANT USAGE, SELECT ON SEQUENCE rental_rental_id_seq TO grup_atencio;
GRANT USAGE, SELECT ON SEQUENCE inventory_inventory_id_seq TO grup_gerencia;
GRANT USAGE, SELECT ON SEQUENCE film_film_id_seq TO grup_gerencia;
